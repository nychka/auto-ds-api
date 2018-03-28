class AirjobSerializer < ActiveModel::Serializer
  attributes :job_name, :status, :result
  has_many :children, include: true, if: -> { with_children? }

  def children
    object.children.map { |node| serialize node }
  end

  private

  def serialize(node)
    AirjobSerializer.new(node, @instance_options).serializable_hash
  end

  def with_children?
    @instance_options[:with_children] && object.children.any?
  end
end
