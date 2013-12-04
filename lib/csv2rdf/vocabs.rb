require 'rdf'

#
# Some widely used RDF vocabulary namespaces.
#

SCHEMA = RDF::Vocabulary.new("http://schema.org/")
GEO = RDF::Vocabulary.new("http://www.w3.org/2003/01/geo/wgs84_pos#>")
GR = RDF::Vocabulary.new("http://purl.org/goodrelations/v1#")
