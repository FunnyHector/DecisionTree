class DecisionTreeBuilder

  def self.build_tree(instances, attributes)
    if instances.empty? # instances is empty
      # return a leaf node containing the name and probability of the overall most
      # probable class (ie, the "baseline" predictor)

    end

    if is_pure?(instances) # instances is pure
      # return a leaf node containing the name of the class of the instances
      # in the node and probability 100% or 1

    end

    if attributes.empty?
      # return a leaf node containing the name and probability of the majority class
      # of the instances in the node (choose randomly if classes are equal)

    else
      # find the best attribute:
      attributes.each do |attribute|
        # separate instances into 2 sets:
        #    1. instances for which the attribute is true,
        #    2. instances for which the attribute is false
        #
        # compute purity of each set
        # record the weighted average purity
        #
      end


      # best_attribute = attribute with the best weighted average purity
      # best_true_instances = 1. instances for which the attribute is true
      # best_false_instances = 2. instances for which the attribute is false

      #  left_node = build_tree(best_true_instances, attributes - best_attribute)
      #  right_node = build_tree(best_false_instances, attributes - best_attribute)

      # return Node containing (best_attribute, left_node, right_node)
    end


  end




  private

  def self.is_pure?(instances)

  end

  def self.weighted_average_purity_is_best?

  end


end

class DecisionTreeBuilder::Node
  attr_accessor :left_node, :right_node, :attribute_name, :probability

  def initialize(left_node, right_node, attribute_name, probability = nil)
    self.left_node      = left_node
    self.right_node     = right_node
    self.attribute_name = attribute_name
    self.probability    = probability
  end

  def to_s
    # recursively print the tree out
  end
end
