class HepatitisInstance
  ATTRIBUTES_NAMES = %w(age female steroid antivirals fatigue malaise anorexia bigliver firmliver spleenpalpable spiders ascites varices bilirubin sgot histology).freeze

  attr_accessor :given_category, :categorised_category, :age, :female, :steroid, :antivirals, :fatigue, :malaise, :anorexia, :bigliver, :firmliver, :spleenpalpable, :spiders, :ascites, :varices, :bilirubin, :sgot, :histology

  def initialize(given_category, attributes, categorised_category = nil)
    self.given_category   = given_category
    self.age              = attributes[0]
    self.female           = attributes[1]
    self.steroid          = attributes[2]
    self.antivirals       = attributes[3]
    self.fatigue          = attributes[4]
    self.malaise          = attributes[5]
    self.anorexia         = attributes[6]
    self.bigliver         = attributes[7]
    self.firmliver        = attributes[8]
    self.spleenpalpable   = attributes[9]
    self.spiders          = attributes[10]
    self.ascites          = attributes[11]
    self.varices          = attributes[12]
    self.bilirubin        = attributes[13]
    self.sgot             = attributes[14]
    self.histology        = attributes[15]
    @categorised_category = categorised_category
  end

  def categorisation_mismatched?
    if @categorised_category.nil? # label not given, or not classified yet
      false
    else
      categorised_category != given_category
    end
  end

  def categorised_category
    @categorised_category.nil? ? "Uncategorised" : @categorised_category
  end

  # format: { given_category: given_category, categorised_category: categorised_category, attr_name_1: attr_value_1, attr_name_2: attr_value_2, ... }
  def to_s
    "{ ".tap do |str|
      str << "given_category: #{given_category}, "
      str << "categorised_category: #{categorised_category}, "

      ATTRIBUTES_NAMES.each do |name|
        str << "#{name}: #{self.send(name.to_sym)}, "
      end

      str.chomp!(", ")
      str << " }"
    end
  end
end
