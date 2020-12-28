require 'rubygems'

require 'rake'
require 'rake/testtask'

require 'bundler'
require 'rubygems/package_task'


RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser/scanner', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__
RAGEL_SOURCE_FILES = %w{scanner} # scanner.rl includes property.rl


Bundler::GemHelper.install_tasks


task :default => [:'test:full']

namespace :test do
  task full: :'ragel:rb' do
    sh 'bin/test'
  end
end

namespace :ragel do
  desc "Process the ragel source files and output ruby code"
  task :rb do
    RAGEL_SOURCE_FILES.each do |source_file|
      output_file = "#{RAGEL_OUTPUT_DIR}/#{source_file}.rb"
      # using faster flat table driven FSM, about 25% larger code, but about 30% faster
      sh "ragel -F1 -R #{RAGEL_SOURCE_DIR}/#{source_file}.rl -o #{output_file}"

      contents = File.read(output_file)

      File.open(output_file, 'r+') do |file|
        contents = "# -*- warn-indent:false;  -*-\n" + contents

        file.write(contents)
      end
    end
  end

  desc "Delete the ragel generated source file(s)"
  task :clean do
    RAGEL_SOURCE_FILES.each do |file|
      sh "rm -f #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
  end
end


# Add ragel task as a prerequisite for building the gem to ensure that the
# latest scanner code is generated and included in the build.
desc "Runs ragel:rb before building the gem"
task :build => ['ragel:rb']


namespace :props do
  desc 'Write new property value hashes for the properties scanner'
  task :update do
    require 'regexp_property_values'
    RegexpPropertyValues.update
    dir = File.expand_path('../lib/regexp_parser/scanner/properties', __FILE__)

    require 'psych'
    write_hash_to_file = ->(hash, path) do
      File.open(path, 'w') do |f|
        f.puts '#',
               "# THIS FILE IS AUTO-GENERATED BY `rake props:update`, DO NOT EDIT",
               '#',
               hash.sort.to_h.to_yaml
      end
      puts "Wrote #{hash.count} aliases to `#{path}`"
    end

    long_names_to_tokens = RegexpPropertyValues.all.map do |val|
      [val.identifier, val.full_name.downcase]
    end
    write_hash_to_file.call(long_names_to_tokens, "#{dir}/long.yml")

    short_names_to_tokens = RegexpPropertyValues.alias_hash.map do |k, v|
      [k.identifier, v.full_name.downcase]
    end
    write_hash_to_file.call(short_names_to_tokens, "#{dir}/short.yml")
  end
end
