Gem::Specification.new do |s|
  s.name        = 'csv2rdf'
  s.version     = '0.0.0'
  s.date        = '2013-12-01'
  s.summary     = "Convert CSV files to RDF"
  s.description = "A super light-weight framework for converting arbitrary CSV files to RDF."
  s.authors     = ["Knud Möller"]
  s.email       = 'knud@datalysator.com'
  s.files       = [
    "lib/csv2rdf.rb",
    "lib/csv2rdf/vocabs.rb",
    "lib/csv2rdf/converter.rb"
  ]
  s.homepage    =
    'https://github.com/knudmoeller/csv2rdf'
  s.add_runtime_dependency "rdf", [">= 1.0.9"]
  s.add_runtime_dependency "activesupport", [">= 4.0.1"]
end