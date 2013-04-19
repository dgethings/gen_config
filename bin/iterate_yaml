#!/usr/bin/ruby
require 'ipaddr'
require 'yaml'

class IPAddr
  def to_octet
      new_array =  Array.new()
    if (self.ipv4?)
      self.to_s.split(".").map(&:to_i)
    elsif (self.ipv6?)
      self.to_s.split(":").map(&:to_i)
    else
      return false
    end
  end
  
  def step (step, iter)
    new_address_array =  Array.new()
    i = 0
    self.to_octet.each { |value| new_address_array[i] = self.to_octet[i] + (step.to_octet[i]*iter); i += 1}
    new_address = IPAddr.new new_address_array.join(".")
    return new_address
  end
end

indent = "  "
unless ARGV[0]
  puts '', "Usage : ruby  #{$0}  <YAML_FILE> [OUTPUT_FILENAME] [test]"
  puts '', "\t[OUTPUT_FILENAME] is optional, if not provided output will be to the screen"
  puts '', "\t[test] is optional, if set output will be the YAML configuration"
  system("pause")
  exit
end

yaml_file = ARGV[0]
output = ARGV[1]

current_time = Time.now

yaml = YAML.load( File.read( yaml_file ) )
number_of_iterations = yaml['number_of_iterations']

generated_yaml = '###### ' " generated at : #{current_time}, using YAML file :  #{yaml_file}, number of iterations : #{number_of_iterations}\n" 


i = 0
while i < number_of_iterations  do
  generated_yaml << "- template: #{yaml['template']}\n"
  yaml['variables'].each { |value| 
    if value['type'] == "integer"
      variable_value = value['initial_value'] + (i * value['step'])
    
    elsif value['type'] == "string"
      variable_value = "#{value['initial_value']}  " + (i * value['step']).to_s()
    
    elsif value['type'] == "ip_addr"
      variable_value = (IPAddr.new value['initial_value']).step((IPAddr.new value['step']), i)
      
    
    elsif value['type'] == "ipv6_addr"
      variable_value = value['initial_value']
    
    else
      variable_value = value['initial_value']
      end
   # puts "result : "
    generated_yaml << "#{indent}#{value['name']}: #{variable_value}\n"
  }
  i +=1
end

#generated_yaml = ""

if output
  if output == "test"
    
    puts YAML::dump(c)
  elsif  output != "test"
    File.open(output, 'a') do |f|
      f.puts generated_yaml
    end  
end
else
  puts generated_yaml
end
