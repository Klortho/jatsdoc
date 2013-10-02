# Same as config.ru, but this overrides the documentation set (docset) that will
# be served.  Right now it is a hack, using the global variable $docset.

$docset = "jats"
require "#{File.dirname(__FILE__)}/app/jqapi.rb"

map '/assets' do
  run Jqapi::Server.sprockets
end

map '/' do
  run Jqapi::Server
end
