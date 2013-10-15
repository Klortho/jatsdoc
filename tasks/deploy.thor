class Deploy < Thor
  desc 'generate', 'Copies all documentation files and the framework, minifies css and js'

  def generate
    sprockets = Sprockets::Environment.new('')
    deploy_path = 'jatsdoc'

    Jqapi::ASSET_PATHS.each do |path|
      puts "appending #{path}"
      sprockets.append_path(path)
    end

    puts 'Wipe out #{deploy_path}, and starting from scratch'
    FileUtils.rm_rf "#{deploy_path}"
    Dir.mkdir(deploy_path)

    puts "Generate (and minify) jatsdoc.css"
    sprockets.find_asset('jatsdoc.css').write_to "#{deploy_path}/jatsdoc.css"

    puts "Generate (and minify) jatsdoc.js"
    sprockets.find_asset('jatsdoc.js').write_to "#{deploy_path}/jatsdoc.js"

    puts 'Copy images'
    %x[cp -r app/assets/images/** #{deploy_path}/]

    puts "Copy License File"
    FileUtils.cp 'LICENSE', "#{deploy_path}/"

    puts "Copy Readme File"
    FileUtils.cp 'README.md', "#{deploy_path}/"
  end

end
