require "./hepatitis_instance.rb"
require "./decision_tree.rb"
require "./decision_tree_node.rb"
require "./decision_tree_printer.rb"

DEFAULT_TRAINING_SET_FILE = "data/hepatitis-training.dat".freeze
DEFAULT_TEST_SET_FILE     = "data/hepatitis-test.dat".freeze

# helper methods
def read_file(file)
  File.readlines(file).reject { |line| line.strip.empty? }.drop(2).map do |line|
    values     = line.split
    category   = values[0]
    attributes = values.drop(1).map { |value| to_boolean(value) }

    HepatitisInstance.new(category, attributes)
  end
rescue StandardError => e
  abort("Error occurred when reading \"#{file}\". Exception message: #{e.message}.")
end

def to_boolean(string)
  { "true" => true, "false" => false, "live" => "live", "die" => "die" }.fetch(string.downcase)
rescue KeyError => _
  abort("Error occurred when reading file, unknown value: \"#{string}\".")
end

# set parameters
training_set_file = ARGV[0].nil? ? DEFAULT_TRAINING_SET_FILE : ARGV[0]
test_set_file     = ARGV[1].nil? ? DEFAULT_TEST_SET_FILE : ARGV[1]

# read in the training file & the test file
training_set = read_file(training_set_file)
test_set     = read_file(test_set_file)

# initialise the decision tree and run magic!
decision_tree = DecisionTree.new

decision_tree.run_decision_tree_learning(training_set)

puts DecisionTreePrinter.new(decision_tree.tree_root).render_tree





# result = decision_tree.categorise_test_set!(test_set)



