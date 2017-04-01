class DecisionTree
  attr_reader :tree_root, :summary_figures

  def run_decision_tree_learning(training_set)
    attributes = HepatitisInstance::ATTRIBUTES_NAMES.clone
    categories_count = count_categories(training_set)

    # get the baseline figures ready
    @baseline_category = majority_of(categories_count)
    @baseline_probability = probability_of_majority(categories_count)
    @baseline_proportion = proportion_of_majority_to_s(categories_count) << "  # baseline predictor"

    # dirty dirty recursion here we go
    @tree_root = build_tree(training_set, attributes)
  end

  def build_tree(instances, attributes)
    # return a leaf node containing the name and probability of the overall most
    # probable class (ie, the "baseline" predictor)
    if instances.empty?
      return DecisionTreeNode::Leaf.new(
        category:    @baseline_category,
        probability: @baseline_probability,
        proportion:  @baseline_proportion
      )
    end

    categories_count = count_categories(instances)

    # return a leaf node containing the name and probability of the majority class
    # of the instances in the node (choose randomly if classes are equal)
    if attributes.empty?
      return DecisionTreeNode::Leaf.new(
        category:    majority_of(categories_count),
        probability: probability_of_majority(categories_count),
        proportion:  proportion_of_majority_to_s(categories_count)
      )
    end

    # return a leaf node containing the name of the class of the instances
    # in the node and probability 100% or 1
    if pure?(categories_count)
      return DecisionTreeNode::Leaf.new(
        category:    majority_of(categories_count),
        probability: 1,
        proportion:  proportion_of_majority_to_s(categories_count)
      )
    end

    # record the impurity of each attribute
    impurities_by_attributes = attributes.each_with_object({}) do |attribute, hash|
      true_instances  = instances.select { |instance| instance.send(attribute.to_sym) }
      false_instances = instances - true_instances

      hash[attribute] = weighted_average_impurity_of(true_instances, false_instances)
    end

    # find the best attribute
    best_attribute = impurities_by_attributes.key(impurities_by_attributes.values.min)

    # split instances based on the best attribute
    true_instances_at_best_attribute  = instances.select { |instance| instance.send(best_attribute.to_sym) }
    false_instances_at_best_attribute = instances - true_instances_at_best_attribute

    # left node and right node
    true_node  = build_tree(true_instances_at_best_attribute, attributes - [best_attribute])
    false_node = build_tree(false_instances_at_best_attribute, attributes - [best_attribute])

    # return the node itself
    DecisionTreeNode::InternalNode.new(true_node: true_node, false_node: false_node, attribute_name: best_attribute)
  end

  def categorise_test_set!(test_set)
    raise "Decision tree is not learned yet" if @tree_root.nil?

    @test_set = test_set
    @test_set.each { |instance| categorise!(instance) }

    summary  # summarise figures
  end

  def summary
    @num_incorrect_d_tree = @test_set.count(&:categorisation_mismatched?)
    @num_correct_d_tree   = @test_set.size - @num_incorrect_d_tree
    @accuracy_d_tree      = format("%.2f", ((@num_correct_d_tree.to_f / @test_set.size) * 100))

    @num_correct_baseline        = @test_set.count { |instance| @baseline_category == instance.given_category }
    @num_incorrect_baseline      = @test_set.size - @num_correct_baseline
    @accuracy_baseline           = format("%.2f", ((@num_correct_baseline.to_f / @test_set.size) * 100))
    @baseline_probability_format = format("%.2f", @baseline_probability * 100)

    @summary_figures = {
        test_set_size:           @test_set.size,
        decision_tree_correct:   @num_correct_d_tree,
        decision_tree_incorrect: @num_incorrect_d_tree,
        decision_tree_accuracy:  @accuracy_d_tree,
        baseline_probability:    @baseline_probability_format,
        baseline_correct:        @num_correct_baseline,
        baseline_incorrect:      @num_incorrect_baseline,
        baseline_accuracy:       @accuracy_baseline,
    }
  end

  def result
    @result =  "========== Results of categorisation (test set) ==========\n"
    @result << "No.  given_category  category_based_on_decision_tree\n"

    @test_set.each_with_index do |instance, index|
      @result << "#{format("%02d", index + 1)}  #{instance.given_category}  #{instance.categorised_category}"
      @result << "    # categorisation mismatched" if instance.categorisation_mismatched?
      @result << "\n"
    end

    @result << "======================== Summary =========================\n"
    @result << "Test set size: #{@test_set.size}\n"
    @result << " - Correct vs. Incorrect ratio by decision tree: #{@num_correct_d_tree} vs. #{@num_incorrect_d_tree}\n"
    @result << "   Accuracy of decision tree: #{@accuracy_d_tree}%\n"

    @result << " - Baseline probability: #{@baseline_probability_format}% probability as #{@baseline_category}\n"
    @result << "   Correct vs. Incorrect ratio by baseline predictor: #{@num_correct_baseline} vs. #{@num_incorrect_baseline}\n"
    @result << "   Accuracy of baseline predictor: #{@accuracy_baseline}%\n"

    @result
  end

  private

  def count_categories(instances)
    instances.each_with_object(Hash.new(0)) { |instance, hash| hash[instance.given_category] += 1 }
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

  def proportion_of_majority(categories_count)
    values = categories_count.values

    [values.max, values.inject(0, :+)]
  end

  def proportion_of_majority_to_s(categories_count)
    proportion = proportion_of_majority(categories_count)

    "#{proportion.first} / #{proportion.last}"
  end

  def probability_of_majority(categories_count)
    proportion = proportion_of_majority(categories_count)

    proportion.first.to_f / proportion.last
  end

  def categorise!(instance)
    pointer = @tree_root

    loop do
      break unless pointer.respond_to?(:attribute_name)

      attribute_name = pointer.attribute_name.to_sym
      path = instance.send(attribute_name)
      pointer = path ? pointer.true_node : pointer.false_node
    end

    instance.categorised_category = pointer.category
  end
end
