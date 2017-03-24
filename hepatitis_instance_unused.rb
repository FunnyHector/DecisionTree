class HepatitisInstanceUnused
  ATTRIBUTES_NAMES = %w(age female steroid antivirals fatigue malaise anorexia bigliver firmliver spleenpalpable spiders ascites varices bilirubin sgot histology).freeze

  attr_accessor :category, :attributes

  def initialize(category, attributes)
    self.category   = category
    self.attributes = attributes
  end

  def attribute_name_at(index)
    ATTRIBUTES_NAMES[index]
  end

  def attribute_value_at(index)
    attributes[index]
  end

  # format: { category: category, attr_name_1: attr_value_1, attr_name_2: attr_value_2, ... }
  def to_s
    "{ ".tap do |str|
      str << "category: #{category}, "

      ATTRIBUTES_NAMES.size.times do |index|
        str << "#{ATTRIBUTES_NAMES[index]}: #{attributes[index]}, "
      end

      str.chomp!(", ")
      str << " }"
    end
  end

end
