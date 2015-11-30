#!/usr/bin/env ruby
require 'erb'
require 'pathname'
require 'yaml'

require 'hashie'

INPUT = Pathname.new("data.yml")
OUTDIR = Pathname.new("resume")
TEMPLATE_DIR = Pathname.new("_templates")

OUTDIR.mkdir if not OUTDIR.exist?

FMTERS = {
  ".tex" => lambda do |thingy|
    thingy = thingy.dup

    substitutions = {
      "API" => '\textsc{api}',
      "AWS" => '\textsc{aws}',
      "EC2" => '\textsc{ec2}',
      "HTML/CSS" => '\textsc{html\slash css}',
      "HTTP" => '\textsc{http}',
      "IE8" => '\textsc{ie}8',
      "iOS" => 'i\textsc{os}',
      "MongoDB" => 'Mongo\textsc{db}',
      "PaaS" => '\textsc{p}aa\textsc{s}',
      "PostgreSQL" => 'Postgre\textsc{sql}',
      "S3" => '\textsc{s3}',
      "Sr. Software Engineer" => "Sr.~Software Engineer",
      "Unix" => '\textsc{unix}',
      "VM" => '\textsc{vm}',
    }
    substitutions.each do |raw, texified|
      thingy.gsub!(raw, texified)
    end
    thingy
  end
}

templates = TEMPLATE_DIR.children.map do |tmpl|
  next unless tmpl.to_s.match(/\.erb\z/)
  [tmpl, tmpl.basename(".erb")]
end.compact

data = Hashie::Mash.new(YAML.load_file(INPUT))

templates.each do |(tmplfile, outfile)|
  fmt = FMTERS[outfile.extname] || ->(thingy) { thingy }

  template = ERB.new(File.read(tmplfile), nil, "-")
  out = OUTDIR + outfile
  puts "rendering #{tmplfile} -> #{OUTDIR + outfile}..."
  out.write(template.result(binding))
end
