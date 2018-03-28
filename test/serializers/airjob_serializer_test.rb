require 'test_helper'

class AirjobSerializerTest < ActiveSupport::TestCase
  test 'tree with three levels' do
    parent = airjobs(:valid)
    son = parent.children.create job_name: 'son', status: Airjob::PROCESSING
    grandson = son.children.create job_name: 'grandson', status: Airjob::PROCESSING
    parent_hash = AirjobSerializer.new(parent).serializable_hash
    son_hash = AirjobSerializer.new(son).serializable_hash
    grandson_hash = AirjobSerializer.new(grandson).serializable_hash
    son_hash[:children] = [grandson_hash]
    parent_hash[:children] = [son_hash]
    serialization = AirjobSerializer.new(parent, with_children: true).serializable_hash.deep_symbolize_keys

    assert_equal serialization, parent_hash
  end
end
