class DecisionTreeNode
  attr_accessor :left_node, :right_node, :parent_node, :attribute_name, :probability

  def initialize(left_node, right_node, parent_node, attribute_name, probability = nil)
    self.left_node      = left_node
    self.right_node     = right_node
    self.parent_node    = parent_node   # might not be used
    self.attribute_name = attribute_name
    self.probability    = probability
  end

  def to_s
    # TODO: recursively print the tree out
  end
end
