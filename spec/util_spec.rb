require 'qualtrics'

describe "The qualtrics utility functions" do
  before(:each) do
    class Util
      include Qualtrics::Util
    end
    @util = Util.new
  end

  it "parses json and returns the result key" do
    json_str = "{\"Result\": {\"another_key\": 1}}"
    result = @util.json_result json_str
    result.should eq({:another_key => 1})
  end

  it "converts a hash to use symbols as keys" do
    h = { "HelloWorld" => 1, "CoolBeans" => 2, "NestedHash" => {"UnaffectedKey" => 3}}
    @util.symbolize_keys! h
    h.should eq({hello_world: 1, cool_beans: 2, nested_hash: { "UnaffectedKey" => 3 }})
  end

  it "can convert from camel-case to snake-case" do
    camel = "HelloWorld"
    snake = @util.underscore camel
    snake.should eq("hello_world")
  end

  it "can convert a string from snake-case to camel-case" do
    snake = "hello_world"
    camel = @util.camel_case snake
    camel.should eq("HelloWorld")
  end
end


