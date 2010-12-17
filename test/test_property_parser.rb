require 'helper'

class TestPropertyParser < Test::Unit::TestCase
  def setup
    @file = File.dirname(__FILE__) + "/test.property"
  end

  should "return empty on invalid file name" do
    # bad name
    assert_equal({}, PropertyParser.parse("nothing.txt"))
    # not a file
    assert_equal({}, PropertyParser.parse(File.dirname(__FILE__)))
  end

  should "ignore all comments" do
    results = PropertyParser.parse(@file)
    
    [ "TEST_COMMENT1",
      "TEST_COMMENT2",
      "TEST_COMMENT3",
      "TEST_COMMENT4" ].each do |comment_key|
      assert !results.keys.include?(comment_key), 
        "should not parsed #{comment_key}"
    end
  end

  should "return hash of name value pairs" do
    results = PropertyParser.parse(@file)
    
    # normal key value pairs
    [1, 2, 3, 4, 5, 6].each do |index|
      expected_key = "TEST.PROPERTY_#{index}_NAME"
      expected_value = "test.prop_#{index}.value"
      assert results.keys.include?(expected_key)
      assert_equal expected_value, results[expected_key]
    end

    # values that has ! and # in it
    [7, 8].each do |index|
      expected_key = "TEST.PROPERTY_#{index}_NAME"
      expected_value = "\#test prop_#{index} value!" 
      assert results.keys.include?(expected_key) 
      assert_equal expected_value, results[expected_key]
    end

    # keys that has ! and # in it
    [9, 10].each do |index|
      expected_key = "TEST.PROPERTY##{index}_NAME!"
      expected_value = "\#test prop_#{index} value!" 
      assert results.keys.include?(expected_key) 
      assert_equal expected_value, results[expected_key]
    end

    # empty keys 
    [11, 12].each do |index|
      assert !results.keys.include?("TEST.PROPERTY_#{index}_NAME")
    end
  end
  
end
