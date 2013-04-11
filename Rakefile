task :install do
  `cp gen_config /usr/local/bin`
  `cp bin/yaml_from_erb /usr/local/bin`
  conf_location = ENV['CONFIG_PREFIX'] || '/etc'
  File.open( "#{conf_location}/gen_config.conf", "w") do |f|
    template_location = ENV['TEMPLATE_PREFIX'] || '/usr/local/share/templates'
    f.write( "template: #{template_location}" )
  end
  puts "gen_config & yaml_from_erb installed."
  puts "Please edit #{conf_location}/gen_conf.conf to meet your environment."
end
