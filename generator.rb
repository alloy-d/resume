#!/usr/bin/env ruby
require 'pathname'

require 'maruku'
require 'trollop'
require 'yaml'

opts = Trollop::options do
  opt :out, "Output file", :default => 'languages/index.html'
  opt :in, "Input file", :default => 'data.yaml'
end

data = YAML.load_file opts[:in]
out = Pathname.new opts[:out]
outdir = out.dirname

description = <<EOF
This is a nearly comprehensive account of the programming language
experience that I consider important.

Most of the projects listed here are voluntary efforts; class
assignments are generally omitted unless I put forth
greater-than-average effort or gained a lot in completing them.
EOF

description = Maruku.new(description).to_html

outdir.mkdir if not outdir.exist?

out.open("w") do |o|
  o.puts "<!DOCTYPE html>"
  o.puts "<html>\n<head>"
  o.puts "<title>Adam Lloyd - Programming Languages</title>"
  o.puts "<link rel='stylesheet' href='/resume/css/style.css' />"
  o.puts "</head>\n<body>"

  o.puts "<h1>Programming Language Experience</h1>"
  o.puts description
  o.puts "<ul id='languages'>"
  data['skills']['computer_languages'].each do |lang|
    o.puts "<li id='#{lang['name']}'>"
    o.puts "<p class='name'>#{lang['name']}</p>"
    if not lang['projects'].nil?
      o.puts "<ol class='projects'>"
      lang['projects'].each do |proj|
        o.puts "<li>"
        o.puts "<p class='name'>#{proj['name']}</p>"

        if not proj['date'].nil?
          o.puts "<p class='date'>#{proj['date']}</p>"
        end
        if not proj['description'].nil?
          description = Maruku.new(proj['description']).to_html
          description.gsub!(/<\/?p>/, "") # FIXME: this is ridiculous.
          o.puts "<p class='description'>#{description}</p>"
        end
        if not proj['context'].nil?
          context = Maruku.new(proj['context']).to_html
          context.gsub!(/<\/?p>/, "")     # FIXME: this too.
          o.puts "<p class='context'>#{context}</p>"
        end
        if not proj['url'].nil?
          o.puts "<a href='#{proj['url']}'>code</a>"
        end
        if not proj['more'].nil?
          o.puts "<a href='#{proj['more']}'>more</a>"
        end
      end
      o.puts "</ol><!-- .projects -->"
    end
    o.puts "</li><!-- ##{lang['name']} -->"
  end
  o.puts "</ul><!-- #languages -->"

  o.puts "</body>\n</html>"
end
