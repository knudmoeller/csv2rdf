require 'rdf'
require 'rdf/ntriples'
require 'logger'


# Abstract super-class for all converters.
#
# == Usage
#
# Usually, a converter will be used as follows:
#  converter = RatingConverter.new("path/to/file.csv", "path/to/output_file.nt", context_object)
#  converter.convert
#  converter.serialize
#
class Converter
  
  # The Logger object, defaults to STDOUT
  attr_accessor :log
  
  # ==== Attributes
  #
  # * +csv_in+ - Path to the CSV file that is going to be converted. Is tested for existence and type, might raise an 
  #   +IOError+.
  # * +out_file+ - Path to the desired output file. The containing folder is tested for existence, might raise an 
  #   +IOError+.
  # * +context+ - Optionally a context Hash, can be used to pass information to the converter.
  # * +log+ - the Logger object, defaults to STDOUT
  #
  def initialize(csv_in, out_file, context=nil)
    unless (File.exists?(csv_in))
      raise IOError, "file '#{csv_in}' does not exist"
    end
    unless (File.file?(csv_in))
      raise IOError, "'#{csv_in}' is not a regular file"
    end
    unless (File.exists?(File.dirname(out_file)))
      raise IOError, "directory '#{File.dirname(out_file)}' does not exist"
    end
    @csv_in = csv_in
    @rdf_out = out_file
    @context = context
    @graph = RDF::Graph.new
    @log = Logger.new(STDOUT)
    @log.info("#{self.class}: converting #{@csv_in} to #{@rdf_out}")
  end
  
  # Turn any string into a URI component, useful for creating URIs from names and titles. 
  # The conversion is based on ActiveSupport's +parameterize+ method.
  #
  # ==== Attributes
  #
  # * +name+ - the string to be converted
  # * +capitalize+ - if TRUE, the individual components of the name will be capitalized
  #
  # ==== Examples
  #
  #  Converter.name2uri("Knud Möller")
  #   => "knud-moller"
  #
  #  Converter.name2uri("Knud Möller", TRUE)
  #   => "Knud-Moller"
  #
  def Converter.name2uri(name, capitalize=FALSE)
    name = name.parameterize.downcase
    if capitalize
      name = name.split("-").map { |x| x.capitalize }.join("-")
    end
    return name
  end

  # Convert the string of a German-style float ("1,59") into an actual float.
  # If passed an actual float, it will just return it.
  #
  # ==== Attributes
  #
  # * +float+ - the string to be converted
  #
  # ==== Examples
  #
  #  Converter.german_to_english_float("1,59")
  #   => 1.59
  #
  def Converter.german_to_english_float(float)
    return float.to_s.gsub(",", ".").to_f
  end

  # Convert a string into a boolean
  # For string.downcase == "ja" the method will return TRUE, for all other 
  # values it will return FALSE
  # 
  # === Attributes
  # 
  # * +string+ - the string to be converted
  # 
  # === Examples
  # 
  #  Converter.ja_nein("ja")
  #   => true
  #  Converter.ja_nein("Ja")
  #   => true
  #  Converter.ja_nein("nein")
  #   => false
  #  Converter.ja_nein("hurtz")
  #   => false
  # 
  def Converter.ja_nein(string)
    return string.downcase.eql?("ja")
  end

  # The actual conversion takes place in this method. Implementations in sub-classes 
  # need to build the output graph on the +graph+ instance variable.
  #
  def convert
    raise "method #{self.class.name}#convert() is not implemented!"
  end
  
  # After calling +convert+, +serialize+ will write the +graph+ to the desired output path
  # (+rdf_out+) as an N-Triples file (http://www.w3.org/TR/n-triples/).
  #
  def serialize
    RDF::Writer.open(@rdf_out) { |writer| writer << @graph }
  end
end