class DecisionTreeNode
  class InternalNode < DecisionTreeNode
    attr_accessor :true_node, :false_node, :attribute_name

    def initialize(true_node:, false_node:, attribute_name:)
      self.true_node      = true_node
      self.false_node     = false_node
      self.attribute_name = attribute_name
    end
  end

  class Leaf < DecisionTreeNode
    attr_accessor :category, :probability

    def initialize(category:, probability:)
      self.category    = category
      self.probability = probability
    end
  end
end
