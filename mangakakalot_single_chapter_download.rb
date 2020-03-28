require 'nokogiri'
require 'rest-client'
require 'open-uri'
require 'fileutils'

url = 'CHAPTER URL HERE'
response = RestClient.get(url)
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
