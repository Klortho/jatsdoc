class Dev < Thor
  desc 'start', 'start the development sinatra server'
  method_option :docset,
                :aliases => "-d",
                :desc => "Documentation set to serve"

  def start
    docset = options[:docset]
    puts("Deploying documentation set #{docset}") if docset
    %x[bundle exec rackup #{(docset + ".ru") if docset}]

  end
end