#!/usr/bin/env ruby
require 'erb'
require 'pathname'
require 'yaml'

require 'hashie'

INPUT = Pathname.new("data.yml")
OUTDIR = Pathname.new("resume")
TEMPLATE_DIR = Pathname.new("_templates")

OUTDIR.mkdir if not OUTDIR.exist?

templates = TEMPLATE_DIR.children.map do |tmpl|
  next unless tmpl.to_s.match(/\.erb\z/)
  [tmpl, tmpl.basename(".erb")]
end.compact

data = Hashie::Mash.new(YAML.load_file(INPUT))

templates.each do |(tmplfile, outfile)|
  template = ERB.new(File.read(tmplfile))
  out = OUTDIR + outfile
  puts "rendering #{tmplfile} -> #{OUTDIR + outfile}..."
  out.write(template.result(binding))
end
