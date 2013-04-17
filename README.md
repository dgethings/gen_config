## Summary

gen_config produces a Junos configuration based on a given template and parameters - supplied in a YAML formatted file

## Usage

    gen_config <YAML_FILE> [test]
    [test] is optional, if set output will be the YAML configuration

For example `gen_config interface.yaml > interface.conf` will produce a file called "interface.conf" with the values from the YAML config file in it. This can then be applied to any device that supports "interface.conf" format.

## YAML format

The YAML config file can be written in an valid YAML format. The only requirement is that the YAML file contains 'template' key with a value that points to a template file. The only supported template format is ERB, but others could be included.

For example here is a YAML config file that assigns an IP address to an interface using template file 'interface.erb' to add the additional syntax:

    - template: interface.erb
      interface: xe-0/0/0
      ip_address: 10.0.0.1/24

    - template: interface.erb
      interface: xe-1/0/0
      ip_address: 11.0.0.1/24

This will produce config for both xe-0/0/0 and xe-1/0/0. gen_config will iterate over each `- template` line. All key/value pairs after this line populate the ERB template file.

## Adding New Templates

The current format supported for templates is ERB. This section provides information on the syntax and how to easily create a YAML for that template.

The gen_config takes the values from the YAML file and substitutes the variables in the ERB with the values. Provided the ERB variables syntax is correct the substitution will work.

The correct format for an ERB variable is "<%= c.variable %>" without the surrounding quotes (that is the quotes are no necessary). "variable" is the name of the variable that needed to be substituted. For example, if the template initially has all variables marked as $variable$ this would need to be changed to <%= c.variable %>.

Once the template is complete you can extract a list of variables using the yaml_from_erb command (which is part of this distribution):

    yaml_from_erb <filename>.erb > <filename>.yaml

From this list you can build the YAML file. You must preface the list of variables with `- template: path/to/file.erb`. See YAML format for an example.

## INSTALLATION

First you must download this reposity to the desired machine. Once done you can then install the script. To install this script run the following command from the path of this file:

    sudo rake install

You must have root privilages to install these tools.

## SUPPORT

This software is not officially supported by Juniper Networks, but by a team dedicated to helping customers, partners, and the development community.  To report bug-fixes, issues, susggestions, please contact David Gethings <dgjnpr@gmail.com>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request