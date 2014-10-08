Description
===========

csv2rdf is a super light-weight ruby framework for converting arbitrary CSV files to RDF. 
Since there are a lot of different ways that CSVs can be structured, no generic conversion functionality is provided. 
To provide conversion functionality for a specific kind of CSV document, a sub-class of the abstract `Converter` class needs to be defined by implementing the `convert` method.

Dependencies
------------

csv2rdf uses ruby-rdf (http://ruby-rdf.github.io) for generating and serialising the RDF graph.


License
-------

MIT License, http://opensource.org/licenses/MIT