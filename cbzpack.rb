#!/usr/bin/env ruby

gem 'rubyzip'
require 'zip'
::Zip.sort_entries = true

def main
  begin
    folder_path = Dir.pwd
    cbz = File.basename(folder_path) + '.cbz'
    cbz_path = File.join(folder_path, cbz)
    Zip::File.open(cbz_path, Zip::File::CREATE) do |zipfile|
      file_list = Dir.glob('*.{jpg,JPG}').to_a
      cover = file_list.select {|i| i =~ /cover/i}
      unless cover.empty?
        zipfile.add("!#{cover[0]}", cover[0])
        STDERR.puts "Added #{cover[0]} as cover"
        file_list.delete(cover[0])
      end
      file_list.each do |file|
        zipfile.add(file, file)
        STDERR.puts "Added #{file}"
      end
    end
    puts "Successfully packed #{cbz}"
  rescue Interrupt
  rescue Exception => e
    STDERR.puts "Error! #{e.to_s}"
  end
end

main if __FILE__==$0