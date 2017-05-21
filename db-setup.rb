require 'sequel'

unless ENV.has_key?('DB_HOST') && ENV.has_key?('DB_USER') && ENV.has_key?('DB_PASSWORD') && ENV.has_key?('DB_NAME')
  puts 'Set db settings.'
  exit
end

connect_opt =  {"options"=>{"host"=>ENV['DB_HOST'], "user"=>ENV['DB_USER'], "password"=>ENV['DB_PASSWORD']}}

db = Sequel.postgres(ENV['DB_NAME'], connect_opt)

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
