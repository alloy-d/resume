#!/usr/bin/env ruby
require 'pathname'

require 'maruku'
require 'yaml'

data = YAML.load_file 'data.yaml'
out = Pathname.new 'languages/index.html'
outdir = out.dirname

outdir.mkdir if not outdir.exist?

out.open("w") do |o|
  o.puts "<!DOCTYPE html>"
  o.puts "<html>\n<head>"
  o.puts "<title>Adam Lloyd - Programming Languages</title>"
  o.puts "<link rel='stylesheet' href='/resume/css/style.css' />"
  o.puts "</head>\n<body>"

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
          o.puts "<p class='description'>#{description}</p>"
        end
        if not proj['context'].nil?
          context = Maruku.new(proj['context']).to_html
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
