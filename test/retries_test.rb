require "coveralls"
Coveralls.wear!

require "minitest/autorun"
require "rr"
require "timeout"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "../lib")
require "retries"

class CustomErrorA < RuntimeError; end
class CustomErrorB < RuntimeError; end

class RetriesTest < Minitest::Test
  def test_retries_until_successful
    tries = 0

    result = with_retries(max_tries: 4, recover: CustomErrorA) do |attempt|
      tries += 1
      assert_equal tries, attempt
      raise CustomErrorA.new if tries < 4
      "done"
    end

    assert_equal "done", result
    assert_equal 4, tries
  end

  def test_re_raises_after_max_tries
    assert_raises(CustomErrorA) do
      with_retries(recover: CustomErrorA) do
        raise CustomErrorA.new
      end
    end
  end

  def test_rescue_standarderror_if_no_rescue_is_specified
    tries = 0

    with_retries do
      tries += 1
      raise CustomErrorA, "boom" if tries < 2
    end

    assert_equal 2, tries
  end

  def test_immediately_raise_any_exception_not_specified_by_rescue
    tries = 0

    assert_raises(CustomErrorA) do
      with_retries(recover: CustomErrorB) do
        tries += 1
        raise CustomErrorA.new
      end
    end

    assert_equal 1, tries
  end

  def test_allow_for_catching_any_of_multiple_exceptions_specified_by_rescue
    result = with_retries(max_tries: 3,
                          recover: [CustomErrorA, CustomErrorB]) do |attempt|
      raise CustomErrorA.new if attempt == 0
      raise CustomErrorB.new if attempt == 1
      "done"
    end

    assert_equal "done", result
  end

  def test_run_handler_with_the_expected_args_upon_each_handled_exception
    exception_handler_run_times = 0
    tries = 0

    handler = proc do |exception, attempt_number|
      exception_handler_run_times += 1
      assert_equal exception_handler_run_times, attempt_number
      assert exception.is_a?(CustomErrorA)
    end

    with_retries(max_tries: 4, handler: handler, recover: CustomErrorA) do
      tries += 1
      raise CustomErrorA.new if tries < 4
    end

    assert_equal 4, tries
    assert_equal 3, exception_handler_run_times
  end
end
