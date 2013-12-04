require 'rdf'
require 'rdf/ntriples'

# Abstract super-class for all converters.
#
# == Usage
#
# Usually, a converter will be used as follows:
#  converter = RatingConverter.new("path/to/file.csv", "path/to/output_folder", context_object)
#  converter.convert
#  converter.serialize
#
class Converter
  
  # ==== Attributes
  #
  # * +csv_in+ - Path to the CSV file that is going to be converted. Is tested for existence and type, might raise an 
  #   +IOError+.
  # * +out_folder+ - Path to the desired output folder. Is tested for existence and type, might raise an 
  #   +IOError+.
  # * +context+ - Optionally a context Hash, can be used to pass information to the converter.
  #
  def initialize(csv_in, out_folder, context=nil)
    unless (File.exists?(csv_in))
      raise IOError, "file '#{csv_in}' does not exist"
    end
    unless (File.file?(csv_in))
      raise IOError, "'#{csv_in}' is not a regular file"
    end
    unless (File.exists?(out_folder))
      raise IOError, "directory '#{out_folder}' does not exist"
    end
    unless (File.directory?(out_folder))
      raise IOError, "'#{out_folder}' is not a directory"
    end
    @csv_in = csv_in
    @rdf_out = File.join(out_folder, "#{File.basename(csv_in)}.nt")
    @context = context
    @graph = RDF::Graph.new
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

  # Convert the string of a German-style float ("1,59") into an actual float
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
    return float.gsub(",", ".").to_f
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