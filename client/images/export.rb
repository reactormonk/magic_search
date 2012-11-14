#!/usr/bin/env ruby

require 'nokogiri'
require 'fileutils'
require 'pry'

svg = Nokogiri::XML(File.read('Mana.svg'))

separate_svgs = svg.xpath('//*[local-name() = "svg"]/*[local-name() = "g"]').map do |child|
  svg.dup(1).tap do |doc|
    doc.child.children.each do |ch|
      ch.unlink unless ch.name != "g" or child['id'] == ch['id']
      ch.unlink if ch.text =~ /\n+/ and ch.name != "g"
    end
  end
end

FileUtils.rm_rf('split')
Dir.mkdir('split')
separate_svgs.map do |svg|
  filename = 'split/' + svg.css('title').first.text + ".svg"
  File.open(filename, "w") {|f| f.write(svg)}
  filename
end.each do |name|
  puts "passing inkscape " + name
  system("inkscape #{name} --verb=FitCanvasToDrawing --verb=FileVacuum --verb=FileSave --verb=FileClose")
end
