task :install do
  `cp gen_config /usr/local/bin/`
  conf_location = ENV['CONFIG_PREFIX'] || '/etc'
  File.open( "#{conf_location}/gen_conf.conf", "w") do |f|
    template_location = ENV['TEMPLATE_PREFIX'] || '/usr/local/share/templates'
    f.write( "template: #{template_location}" )
  end
end
