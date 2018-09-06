require 'rubygems'
require 'erb'

# set up some variables that we want to replace in the template
$storage_account_name=ENV['STORAGE_ACCOUNT_NAME']
$storage_account_key_value=ENV['STORAGE_ACCOUNT_KEY_VALUE']

# method update_tokens takes template_file, expecting globals
# to be set, and will return an updated string with tokens replaced.
# you can either save to a new file, or output to the user some
# other way.
def update_tokens(template_file)
 template = ""
 open(template_file) {|f|
   template = f.to_a.join
 }
 updated = ERB.new(template, 0, "%<>").result

 return updated
end

new_xml=update_tokens(Dir.getwd+"/core-site-template.xml")
open('core-site.xml', 'w') { |f|
    f.puts new_xml
}