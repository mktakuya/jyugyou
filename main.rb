require 'open-uri'
require 'nokogiri'
require 'sequel'
require './classes'
require 'pry'

unless ENV.has_key?('DB_HOST') && ENV.has_key?('DB_USER') && ENV.has_key?('DB_PASSWORD') && ENV.has_key?('DB_NAME')
  puts 'Set db settings.'
  exit
end

connect_opt =  {"options"=>{"host"=>ENV['DB_HOST'], "user"=>ENV['DB_USER'], "password"=>ENV['DB_PASSWORD']}}
db = Sequel.postgres(ENV['DB_NAME'], connect_opt)

base_url = 'http://jyugyou.tomakomai-ct.ac.jp/jyugyou.php'

CLASSES.each do |k, v|
  url = base_url + "?class=#{k.to_s.upcase}"
  html = Nokogiri::HTML(open(url))
  table = html.search('table')[-1]

  table.search('tr')[1..-1].each do |tr|
    data = {class: v}
    td0 = tr.search('td')[0]
    td0_text = td0.text.gsub('　', '').split
    data[:date] = Date.strptime(td0_text[0], '%m月%d日')
    data[:period] = td0_text[1]

    td1 = tr.search('td')[1]
    data[:content] = td1.text
    data[:content].slice!(0)

    db.transaction do
      db[:jyugyous].insert(data) unless db[:jyugyous].where(data).first
    end
  end
end

db.disconnect
