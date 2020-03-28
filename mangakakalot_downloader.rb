require 'nokogiri'
require 'rest-client'
require 'open-uri'
require 'fileutils'


url = 'MANGA URL HERE'
home = RestClient.get(url)
home_parsed = Nokogiri::HTML(home)
chapters = home_parsed.css('div.panel-story-chapter-list > ul > li > a')
title = home_parsed.xpath('/html/body/div/div[3]/div/div[3]/div[2]/h1').text
folder = FileUtils.mkdir_p "#{title}"
chapters_url = Array.new
chapters.each{|chap| chapters_url << chap.attr('href')}
Dir.chdir("#{Dir.pwd.chomp}/#{title}") do
  chapters_url.each do |chapter|
    response = RestClient.get(chapter)
    chapter_parsed = Nokogiri::HTML(response)
    chapter_title = chapter_parsed.xpath('/html/body/div/div/div[2]/a[3]').text
    chapter_images = chapter_parsed.css('div.container-chapter-reader > img')
    chapter_images.each do |img|
      image = img.attr('src')
      chapter_folder = FileUtils.mkdir_p "#{chapter_title}"
      Dir.chdir("#{Dir.pwd.chomp}/#{chapter_folder.join(" ")}") do
        File.open("page#{chapter_images.find_index(img)}", "wb") do |f|
          f.write open(image).read
        end
      end
    end
  end
end