ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  test "create a user" do
      assert_difference "test.count",1 do
        test.create(:name=>"李磊",:age=>15,:login=>"lilei")
      end
      lilei = test.last
      assert_equal [lilei.name,lilei.age,lilei.login],["李磊",15,"lilei"]
  end
end
