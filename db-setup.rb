require 'sequel'

unless ENV.has_key?('JYUGYOU_DB_HOST') && ENV.has_key?('JYUGYOU_DB_USER') && ENV.has_key?('JYUGYOU_DB_PASSWORD') && ENV.has_key?('JYUGYOU_DB_NAME')
  puts 'Set db settings.'
  exit
end

connect_opt =  {"options"=>{"host"=>ENV['JYUGYOU_DB_HOST'], "user"=>ENV['JYUGYOU_DB_USER'], "password"=>ENV['JYUGYOU_DB_PASSWORD']}}

db = Sequel.postgres(ENV['JYUGYOU_DB_NAME'], connect_opt)

unless db.table_exists?(:jyugyous)
  db.create_table :jyugyous do
    primary_key :id
    String      :class
    Date        :date
    String      :period
    String      :content
  end
end

db.disconnect
