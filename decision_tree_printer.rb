# This class traverses the decision tree, and records every node in its own
# data structure, and then print it out. The example structure:
# [
#   { path: nil, level: 0, attribute_name: female }  # internal node
#   { path: true, level: 1, category: live, probability: 1 }  # leaf node
#   ...
# ]
class DecisionTreePrinter
  # some predefined strings to render the tree
  TRUE_ARROW   = " |-true--> "
  FALSE_ARROW  = " `-false-> "
  BAR_INDENT   = " |         "
  BLANK_INDENT = "           "

  def initialize(root_node)
    @root_node = root_node
    @nodes     = []

    walk_tree(nil, @root_node, 0)
  end

  # most ugly ruby code I wrote ever...
  def render_tree
    root = @nodes.first
    return "" if root.nil?

    anchor_positions = []
    result = ""

    @nodes.each do |node|
      is_leaf          = node.key?(:category)
      is_internal_node = !is_leaf

      if node[:path].nil?
        # root node
        result << "[#{root[:attribute_name]}]\n"
        anchor_positions.push(node[:level])
      else
        # draw anchors
        (0..(node[:level] - 1)).each do |pos|
          if anchor_positions.include?(pos)
            if pos == anchor_positions.last
              if node[:path]
                result << TRUE_ARROW
              else
                anchor_positions.pop
                result << FALSE_ARROW
              end
            else
              result << BAR_INDENT
            end
          else
            result << BLANK_INDENT
          end
        end

        # draw node
        if is_internal_node
          result << "[#{node[:attribute_name]}]\n"
        elsif is_leaf
          result << "Category: #{node[:category]}, probability: #{node[:probability]}\n"
        end

        # deal with anchor pos array
        if is_internal_node
          # internal node
          anchor_positions.push(node[:level])
        end
      end
    end

    result
  end

  private

  def walk_tree(path, node, level)
    return if node.nil?

    if node.is_a?(DecisionTreeNode::InternalNode)
      @nodes << { path: path, level: level, attribute_name: node.attribute_name }
      walk_tree(true, node.true_node, level + 1)
      walk_tree(false, node.false_node, level + 1)
    elsif node.is_a?(DecisionTreeNode::Leaf)
      @nodes << { path: path, level: level, category: node.category, probability: node.probability }
    end
  end
end
