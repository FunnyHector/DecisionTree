class DecisionTree
  attr_reader :tree_root

  def run_decision_tree_learning(training_set)
    attributes = HepatitisInstance::ATTRIBUTES_NAMES.clone
    @tree_root = build_tree(training_set, attributes)
  end

  def build_tree(instances, attributes)
    if instances.empty? # instances is empty
      # return a leaf node containing the name and probability of the overall most
      # probable class (ie, the "baseline" predictor)

      # TODO: need to fix this temporary return
      return DecisionTreeNode::Leaf.new(
        category:    "instance empty",
        probability: 0.8888
      )
    end

    categories_count = count_categories(instances)

    if attributes.empty?
      # return a leaf node containing the name and probability of the majority class
      # of the instances in the node (choose randomly if classes are equal)

      return DecisionTreeNode::Leaf.new(
        category:    majority_of(categories_count),
        probability: probability_of_majority(categories_count)
      )
    end

    if pure?(categories_count) # instances is pure
      # return a leaf node containing the name of the class of the instances
      # in the node and probability 100% or 1

      return DecisionTreeNode::Leaf.new(
        category:    majority_of(categories_count),
        probability: 1
      )
    end

    # find the best attribute:
    impurities_by_attributes = attributes.each_with_object({}) do |attribute, hash|
      # separate instances into 2 sets:
      #    1. instances for which the attribute is true,
      #    2. instances for which the attribute is false
      #
      # compute purity of each set
      # record the weighted average purity
      #

      true_instances  = instances.select { |instance| instance.send(attribute.to_sym) }
      false_instances = instances - true_instances

      hash[attribute] = weighted_average_impurity_of(true_instances, false_instances)
    end

    # best_attribute = attribute with the best weighted average purity
    # best_true_instances = 1. instances for which the attribute is true
    # best_false_instances = 2. instances for which the attribute is false

    best_attribute = impurities_by_attributes.key(impurities_by_attributes.values.min)
    true_instances_at_best_attribute  = instances.select { |instance| instance.send(best_attribute.to_sym) }
    false_instances_at_best_attribute = instances - true_instances_at_best_attribute

    #  left_node = build_tree(best_true_instances, attributes - best_attribute)
    #  right_node = build_tree(best_false_instances, attributes - best_attribute)
    true_node  = build_tree(true_instances_at_best_attribute, attributes - [best_attribute])
    false_node = build_tree(false_instances_at_best_attribute, attributes - [best_attribute])

    DecisionTreeNode::InternalNode.new(true_node: true_node, false_node: false_node, attribute_name: best_attribute)
  end

  def categorise_test_set!(test_set)
    test_set.each { |instance| categorise!(instance) } unless @tree_root.nil?
  end

  def categorise!(instance)
    # TODO
  end

  private

  def count_categories(instances)
    instances.each_with_object(Hash.new(0)) { |instance, hash| hash[instance.category] += 1 }
  end

  def pure?(categories_count)
    categories_count.size == 1
  end

  def weighted_average_impurity_of(true_instances, false_instances)
    impurity_of_true_instances  = impurity_of(true_instances)
    impurity_of_false_instances = impurity_of(false_instances)

    size_true_instances  = true_instances.size.to_f
    size_false_instances = false_instances.size.to_f

    weight_of_true_instances  = size_true_instances / (size_true_instances + size_false_instances)
    weight_of_false_instances = size_false_instances / (size_true_instances + size_false_instances)

    (weight_of_true_instances * impurity_of_true_instances) + (weight_of_false_instances * impurity_of_false_instances)
  end

  def impurity_of(instances) # measured with P(A)P(B)
    return 0 if instances.empty?

    categories_count = count_categories(instances).values
    value_1 = categories_count.first.to_f
    value_2 = categories_count.last.to_f

    (value_1 * value_2) / ((value_1 + value_2)**2)
  end

  def majority_of(categories_count)
    categories_count.key(categories_count.values.max)
  end

  def probability_of_majority(categories_count)
    values = categories_count.values
    num_majority = values.max.to_f
    total = values.inject(0, :+)

    num_majority / total
  end
end
