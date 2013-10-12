class Deploy < Thor
  desc 'generate', 'Copies all documentation files and the framework, minifies css and js'

  def generate
    sprockets = Sprockets::Environment.new('')
    deploy_path = 'public'
    assets_path = "#{deploy_path}/assets"

    Jqapi::ASSET_PATHS.each do |path|
      puts "appending #{path}"
      sprockets.append_path(path)
    end

    puts 'Wipe out #{deploy_path}, and starting from scratch'
    FileUtils.rm_rf "#{deploy_path}"
    Dir.mkdir(deploy_path)
    Dir.mkdir(assets_path)

    puts "Generate (and minify) bundle.css"
    sprockets.find_asset('bundle.css').write_to "#{assets_path}/bundle.css"

    puts "Generate (and minify) bundle.js"
    sprockets.find_asset('bundle.js').write_to "#{assets_path}/bundle.js"

    puts 'Copy docs directory into #{deploy_path}'
    FileUtils.cp_r 'docs', "#{deploy_path}/"

    puts 'Moving resources directory'
    FileUtils.mv "#{deploy_path}/docs/resources", "#{deploy_path}/resources"

    puts 'Copy images'
    %x[cp -r app/assets/images/** #{assets_path}/]

    puts 'Move index.html'
    FileUtils.mv "#{deploy_path}/docs/index.html", "#{deploy_path}"

    puts "Copy License File"
    FileUtils.cp 'LICENSE', "#{deploy_path}/"

    puts "Copy Readme File"
    FileUtils.cp 'README.md', "#{deploy_path}/"
  end

  desc 'pack', 'creates a .zip of the standalone version, saved to public/'

  def pack
    FileUtils.rm_f 'public/jqapi.zip'
    %x[cd public/ && zip -r jqapi.zip .]
    puts "Created public/jqapi.zip"
  end

end
