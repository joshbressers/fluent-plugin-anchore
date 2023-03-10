require "helper"
require "fluent/plugin/in_anchore.rb"

class AnchoreInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::AnchoreInput).configure(conf)
  end
end
