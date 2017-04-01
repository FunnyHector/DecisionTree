require "./hepatitis_instance.rb"
require "./decision_tree.rb"
require "./decision_tree_node.rb"
require "./decision_tree_printer.rb"

DEFAULT_TRAINING_SET_FILE = "data/hepatitis-training.dat".freeze
DEFAULT_TEST_SET_FILE     = "data/hepatitis-test.dat".freeze

DEFAULT_TRAINING_SET_FILES_10_RUN = (1..10).map { |num| "data/hepatitis-training-run#{format("%02d", num)}.dat" }.freeze
DEFAULT_TEST_SET_FILES_10_RUN     = (1..10).map { |num| "data/hepatitis-test-run#{format("%02d", num)}.dat" }.freeze

# define helper methods
def read_file(file)
  File.readlines(file).reject { |line| line.strip.empty? }.drop(2).map do |line|
    values         = line.split
    given_category = values[0]
    attributes     = values.drop(1).map { |value| to_boolean(value) }

    HepatitisInstance.new(given_category, attributes)
  end
rescue StandardError => e
  abort("Error occurred when reading \"#{file}\". Exception message: #{e.message}.")
end

def to_boolean(string)
  { "true" => true, "false" => false, "live" => "live", "die" => "die" }.fetch(string.downcase)
rescue KeyError => _
  abort("Error occurred when reading file, unknown value: \"#{string}\".")
end

def get_integer_input_with_range(min, max)
  user_input = STDIN.gets.strip.to_i

  while user_input < min || user_input > max
    puts "Please only type integer within \"#{min}\" and \"#{max}\" (inclusive):"
    user_input = STDIN.gets.strip.to_i
  end

  user_input
end

def run_decision_tree_with(training_set_file, test_set_file)
  # read in the training file & the test file
  training_set = read_file(training_set_file)
  test_set     = read_file(test_set_file)

  # initialise the decision tree and run magic!
  decision_tree = DecisionTree.new

  # decision tree learning
  decision_tree.run_decision_tree_learning(training_set)

  # print the tree
  ascii_tree = DecisionTreePrinter.new(decision_tree.tree_root).render_tree
  File.write("./tree.txt", ascii_tree)
  puts "[NOTICE] Console output might look ugly because of auto-line-wrap. See \"tree.txt\" generated\n"
  puts ascii_tree
  puts "\n=======================================================\n"
  puts "\"tree.txt\" is generated.\n\n"

  # categorise the test tet according to the decision tree learned
  decision_tree.categorise_test_set!(test_set)

  # print the result from test set
  result = decision_tree.result
  File.write("./result.txt", result)
  puts result
  puts "\n=======================================================\n"
  puts "\"result.txt\" is generated.\n"

  decision_tree
end

# =========== Here we go ===================

if ARGV.size != 2  # no arguments provided
  puts "No valid arguments provided. Choose 1 or 2:"
  puts "  1. run with 'hepatitis-training.dat' and 'hepatitis-test.dat' (using default data files)"
  puts "  2. run with 10 pairs of training/test files (using default data files)"

  choice = get_integer_input_with_range(1, 2)

  # set parameters
  if choice == 1
    training_set_file = DEFAULT_TRAINING_SET_FILE
    test_set_file     = DEFAULT_TEST_SET_FILE

    run_decision_tree_with(training_set_file, test_set_file)

  elsif choice == 2
    decision_tree_accuracies = []
    baseline_accuracies = []

    10.times.each do |time|
      training_set_file = DEFAULT_TRAINING_SET_FILES_10_RUN[time]
      test_set_file     = DEFAULT_TEST_SET_FILES_10_RUN[time]

      decision_tree = run_decision_tree_with(training_set_file, test_set_file)

      summary_figures = decision_tree.summary_figures
      decision_tree_accuracies << summary_figures.fetch(:decision_tree_accuracy)
      baseline_accuracies << summary_figures.fetch(:baseline_accuracy)
    end

    result = "==================== Overall Summary =====================\n"
    result << "  No.  decision_tree_accuracy  baseline_accuracy\n"

    10.times.each do |time|
      result << "  #{format("%02d", time + 1)}  #{decision_tree_accuracies[time]}%  #{baseline_accuracies[time]}%\n"
    end

    average_of_d_tree_accuracy = format("%.2f", decision_tree_accuracies.map(&:to_f).reduce(&:+).to_f / decision_tree_accuracies.size)
    average_of_baseline_accuracy = format("%.2f", baseline_accuracies.map(&:to_f).reduce(&:+).to_f / baseline_accuracies.size)

    result << "Average of decision tree accuracies: #{average_of_d_tree_accuracy}%\n"
    result << "Average of baseline accuracies: #{average_of_baseline_accuracy}%\n"

    File.write("./10_runs_result.txt", result)
    puts result
    puts "\n=======================================================\n"
    puts "\"10_runs_result.txt\" is generated.\n"
  end

else
  # files provided
  training_set_file = ARGV[0]
  test_set_file     = ARGV[1]

  run_decision_tree_with(training_set_file, test_set_file)
end
