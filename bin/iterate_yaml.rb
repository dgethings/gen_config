#!/usr/bin/ruby
#  v1.0
#  iterate_yaml.rb
#  gen_config
#  
#  Created by Levent Ogut logut@juniper.net on 2013-04-19.
#  
#  


require 'ipaddr'
require 'yaml'

## adding two methods to IPAddr class
class IPAddr

  ## this method splits IP address to each segment(octet / hextet) and returns an array
  def to_octet
    ## if given address is IPv4
    if (self.ipv4?)
      self.to_string.split(".").map {|i| i.to_i(10) } 
    ## if given address is IPv6
    elsif (self.ipv6?)
      self.to_string.split(":").map {|i| i.to_i(16) } 
    else
      return false
    end # end of if
  end # end of def

  ## this method increases the IP address (v4 or v6) using the given step argument
  def step (step, iter)
    new_address_array =  Array.new()
    ## if given address is IPv4
    if (self.ipv4?)
      i = 0
      self.to_octet.each { |value| new_address_array[i] = self.to_octet[i] + (step.to_octet[i]*iter); i += 1}
      return IPAddr.new new_address_array.join(".")
    ## if given address is IPv6
    elsif (self.ipv6?)
      i = 0
      self.to_octet.each { |value| new_address_array[i] = (self.to_octet[i] + (step.to_octet[i]*iter)).to_s(16); i += 1}
      return IPAddr.new new_address_array.join(":")
    else
      return false
    end # end of if
  end # end of def

#defining required indent as a variable
indent = "  "
## checking given arguments
unless ARGV[0]
  puts '', "Usage : ruby  #{$0}  <YAML_FILE> [OUTPUT_FILENAME] [test]"
  puts '', "\t[OUTPUT_FILENAME] is optional, if not provided output will be to the screen"
  puts '', "\t[test] is optional, if set output will be the YAML configuration"
  system("pause")
  exit
end # end of unless

yaml_file = ARGV[0]
output = ARGV[1]

current_time = Time.now

yaml = YAML.load( File.read( yaml_file ) )
## get number of iterations from th YAML file
number_of_iterations = yaml['number_of_iterations']

# adding comment to newly generated YAML file about time / original yaml file / number of iterations
generated_yaml = '###### ' " generated at : #{current_time}, using YAML file :  #{yaml_file}, number of iterations : #{number_of_iterations}\n" 


# for each iteration we will check the type and modify using the step
i = 0
while i < number_of_iterations  do
  generated_yaml << "- template: #{yaml['template']}\n"
  yaml['variables'].each { |value| 
    if value['type'] == "integer"
      variable_value = value['initial_value'] + (i * value['step'])
    
    elsif value['type'] == "string"
      if value['step'] != 0
        variable_value = "#{value['initial_value']}  " + (i * value['step']).to_s()
      else
        variable_value = "#{value['initial_value']}"
      end

    elsif value['type'] == "ip_addr"
      variable_value = (IPAddr.new value['initial_value']).step((IPAddr.new value['step']), i)
    
    elsif value['type'] == "ipv6_addr"
      variable_value = value['initial_value']
    # we can't recognize the type or type is not give, by default give back what was given to us
    else
      variable_value = value['initial_value']
    end
    generated_yaml << "#{indent}#{value['name']}: #{variable_value}\n"
  } # end of each
  i +=1
end # end of while

if output
  if output == "test" 
    puts YAML::dump(c)
  ## append to file
  elsif  output != "test"
    ## append to given file name (if file does not exists it will be created)
    File.open(output, 'a') do |f| 
      f.puts generated_yaml
    end
  end
  else
    ## send to STDOUT
    puts generated_yaml
  end # end of inner if
end # end of outer if
