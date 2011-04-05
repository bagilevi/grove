require 'test/unit'
require 'test/helpers'

class GroveTest < Test::Unit::TestCase
  include ProcessTestHelper

  def test_basic
    server_process "
      class Calculator
        def self.add(a, b)
          a + b
        end
      end
      Grove.run_service(Calculator)
    "
    client_process "
      puts Grove::Calculator.add(2, 2).inspect
    "
    assert_equal "4\n", processes.last.output
  end

end
