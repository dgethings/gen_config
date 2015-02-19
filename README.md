## Summary

gen_config produces a Junos configuration based on a given template and parameters. This is a Ruby script that depends on the YAML, ERB, Ostruct and Rake gems.

A template file - written in ERB - is merged with variables - written in YAML - to produce a configuration file. This file can then be applied to any device that supports the syntax generated.

This documentation shows how to generate Junos configuration. Other syntaxes are possible too.

## INSTALLATION on OS X

OS X comes with Ruby and the required libraries installed. In order to make use of this tool you must iginstall it and have `/usr/local/bin` in your $PATH. The follow shell commands download and install the tool:

```bash
git clone https://github.com/dgjnpr/gen_config.git
cd gen_config
sudo rake install
cd ..
rm -rf gen_config
```

## Configuration

`gen_config` learns the location of the templates from a configuration file. For convenience `gen_config` will look in one of three locations:

1. ./.gen_config.conf
2. ~/.gen_config.conf
3. /etc/gen_config.conf

This order allows for per-project, per-user and per-system wide configuration. The installation of `gen_config` generates a default `/etc/gen_config.conf` that will need editing to be useable.

### Configuration File format

The configuration file contains a single line. It defines the path to the ERB template files. It defaults to the relitave path. To ensure a fixed path define the full path.

```yaml
template_path: example/templates
```

The aboove defines a relitave path.

```yaml
template_path: /usr/local/share/templates
```

The above defines a fixed path.

If no configuration file is found `gen_config` defaults to `./templates` for finding the template files.

## Usage

The following example uses a `interfaces.yaml` file to generate the configuration. This output is printed to the screen. To save the output to a file redirect the output to a file

```bash
gen_config interfaces.yaml > interfaces.conf
```

This example produces the file `interface.conf` with the values from the YAML config file in it. This can then be applied to any device that supports `interface.conf` format.

A more general example is this:

```yaml
gen_config <instance_variables>.yaml
```

## Instance Variables Format

The instance variables file must be written in a valid YAML format. The only requirement is that the YAML file contains 'template' key with a value that is the name of the template file.

For example here is a YAML config file that assigns an IP address to an interface using template file 'interface.erb':

```yaml
- template: interface.erb
  interface: xe-0/0/0
  ip_address: 10.0.0.1/24

- template: interface.erb
  interface: xe-1/0/0
  ip_address: 11.0.0.1/24
```

This will produce config for both xe-0/0/0 and xe-1/0/0. `gen_config` will iterate over each `- template` line. All key/value pairs after this line populate the ERB template file.

## ERB Template Format

The current format supported for templates is ERB. This section provides information on the syntax for the template file and how to easily create a YAML for that template.

The gen_config takes the values from the YAML file and substitutes the variables in the ERB with the values. Provided the ERB variables syntax is correct the substitution will work.

The correct format for an ERB variable is `<%= c.variable %>`. `variable` is the name of the variable that needed to be substituted. For example, if the template initially has all variables marked as `$variable$` this would need to be changed to `<%= c.variable %>`. Here is an example template file for an interface:

```erb
interfaces {
  <%= c.interface %> {
    unit 0 {
      family inet {
        address <%= c.ip_address %>;
      }
    }
  }
}
```

Once the template is complete you can extract a list of variables using the `yaml_from_erb` command (which is part of this distribution):

    yaml_from_erb <filename>.erb > <filename>.yaml

From this list you can build the YAML file. You must preface the list of variables with `- template: path/to/file.erb`. See Instance Variables Format for an example.

# CREATING N INSTANCES OF A TEMPLATE

If you need to create hundreds (or thousands) of something, interfaces for example, then follow the instructions below. This generates the Instance Variables File that `gen_config` can then use to generate the configuration file.

This package contains `iterate_yaml` that generates the Instance Variables used by `gen_config`.

## CONFIGURATION FOR `iterate_yaml`

The following YAML format is used by `iterate_yaml`:

```yaml
template: 
number_of_iterations: 
variables:
- name: 
  type: 
  initial_value: 
  step:
```

One set of `- name`, `type`, `initial_value` and `step` is required per varaible. For variables that do not need to iterate you can omit the `type` and `step` parameters. The parameters are defined as follows:

*   template:
    Name of the template that gen_config will use to populate.
*   number_of_iterations:
    The number of times the following parameters are iterated
*   variables:
    Define name, type, initial_value and step for each of the parameters in the YAML file
*   name:
    Name of the parameter
*   type:
    Can be one of integer, string, ip_addr or ipv6_addr. Can be omitted if parameter does not need to iterate
*   initial_value:
    Starting value point for parameter
*   step:
    By how much the initial_value should increase by.

## USAGE

```bash
iterate_yaml lots_of_interfaces.yaml
```

## SUPPORT

This software is not officially supported by Juniper Networks, but by a team dedicated to helping customers, partners, and the development community.  To report bug-fixes, issues, susggestions, please contact David Gethings <dgjnpr@gmail.com>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request