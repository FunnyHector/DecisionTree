class DecisionTree
  def run_decision_tree_learning(training_set)
    attributes = HepatitisInstance::ATTRIBUTES_NAMES.clone
    @tree_root = build_tree(training_set, attributes)
  end

  def build_tree(instances, attributes)
    if instances.empty? # instances is empty
      # return a leaf node containing the name and probability of the overall most
      # probable class (ie, the "baseline" predictor)

    end

    if instances_pure?(instances) # instances is pure
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

  def categorise_test_set!(test_set)
    test_set.each { |instance| categorise!(instance) } unless @tree_root.nil?
  end

  def categorise!(instance)
    # TODO
  end

  def to_s
    return "Decision tree not learned yet" if @tree_root.nil?
    @tree_root.to_s
  end

  private

  def instances_pure?(instances)
    # TODO
  end

  def weighted_average_purity_is_best?
    # TODO
  end

end

