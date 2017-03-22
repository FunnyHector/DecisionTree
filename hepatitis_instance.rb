class HepatitisInstance
  ATTRIBUTES_NAMES = %w(age female steroid antivirals fatigue malaise anorexia bigliver firmliver spleenpalpable spiders ascites varices bilirubin sgot histology)

  attr_accessor :category, :age, :female, :steroid, :antivirals, :fatigue, :malaise, :anorexia, :bigliver, :firmliver, :spleenpalpable, :spiders, :ascites, :varices, :bilirubin, :sgot, :histology

  # attr_accessor :category
  #
  # ATTRIBUTES_NAMES.each do |name|
  #   define_method name.to_sym do
  #     instance_variable_get("@#{name.to_sym}")
  #   end
  #
  #   define_method "#{name}=".to_sym do |argument|
  #     instance_variable_set("@#{name.to_sym}", argument)
  #   end
  # end

  def initialize(category, age, female, steroid, antivirals, fatigue, malaise, anorexia, bigliver, firmliver, spleenpalpable, spiders, ascites, varices, bilirubin, sgot, histology)
    self.category       = category
    self.age            = age
    self.female         = female
    self.steroid        = steroid
    self.antivirals     = antivirals
    self.fatigue        = fatigue
    self.malaise        = malaise
    self.anorexia       = anorexia
    self.bigliver       = bigliver
    self.firmliver      = firmliver
    self.spleenpalpable = spleenpalpable
    self.spiders        = spiders
    self.ascites        = ascites
    self.varices        = varices
    self.bilirubin      = bilirubin
    self.sgot           = sgot
    self.histology      = histology
  end

  # format: { category: category, attr_name_1: attr_value_1, attr_name_2: attr_value_2, ... }
  def to_s
    "{ ".tap do |str|
      str << "category: #{category}, "

      ATTRIBUTES_NAMES.each do |name|
        str << "#{name}: #{self.send(name.to_sym)}, "
      end

      str.chomp!(", ")
      str << " }"
    end
  end
end