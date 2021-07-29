require 'rubygems'
require 'sinatra'
require 'pony'
require 'sqlite3'
require './methods'

configure do
  $db = SQLite3::Database.new 'base.db'
  $db.execute 'CREATE TABLE IF NOT EXISTS "Users"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "username" TEXT,
      "phone" TEXT,
      "hairdresser" TEXT,
      "date_time" TEXT,
      "hair_color" TEXT
    )'

  $db.execute 'CREATE TABLE IF NOT EXISTS "Hairdressers"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "username" TEXT,
      UNIQUE("username")
    )'

  unless is_table_exists?($db, 'Walter White')
    $db.execute 'INSERT INTO Hairdressers (username)
                    VALUES (?)',
                ['Walter White']
  end

  unless is_table_exists?($db, 'Jessie Pinkman')
    $db.execute 'INSERT INTO Hairdressers (username)
                    VALUES (?)',
                ['Jessie Pinkman']
  end

  unless is_table_exists?($db, 'Gus Fring')
    $db.execute 'INSERT INTO Hairdressers (username)
                    VALUES (?)',
                ['Gus Fring']
  end
end

get '/' do
  erb 'Hello'
end

get '/about' do
	message_construct('О нас', 'Мы одна из перспективных компаний занимающаяся перспектиными разработками новых технологий в сфере парикмахерской индустрии XXI века. Мы всегда рады как бедному обросшему бездомному, так и богатенькому дяде решившегося обратиться к нам после долгово запоя.')
end

get '/contacts' do
  erb :contacts
end

get '/show_users' do
  @users_data = $db.execute 'SELECT * FROM Users ORDER BY id DESC'
  erb :show_users
end

post '/contacts' do
  @name = params[:name]
  @mail = params[:mail]
  @body = params[:body]

  #Pony.mail(:to => 'karimmarabet@hotmail.com', :from => "#{@mail}", :subject => "art inquiry from #{@name}", :body => "#{@body}", :via => :smtp)

  erb 'Спасибо за обращение.'
end

get '/visit' do
  @hairdressers_data = $db.execute 'SELECT * FROM Hairdressers'
	erb :visit
end

post '/visit' do
  @hairdressers_data = $db.execute 'SELECT * FROM Hairdressers'
  @username = params[:username]
  @phone = params[:phone]
  @hairdresser = params[:hairdresser]
  @date_time = params[:date_time]
  @hair_color = params[:hair_color]

  hh = { username: 'Введите имя',
         phone: 'Введите номер телефона',
         date_time: 'Введите дату', }

  # hh.each do |key, value|
  #   if params[key] == ''
  #     @error = hh[key]
  #     return erb :visit
  #   end
  # end

  @error = hh.select { |key, _| params[key] == "" }.values.join(", ")

  if @error != ''
    return erb :visit
  end

  save_form_data_to_database

  # f = File.open './public/users.txt', 'a'
  # f.write "Username: #{@username}, Phone: #{@phone}, Hairdresser: #{@hairdresser}, Date time: #{@date_time}, Hair Color: #{@hair_color}\n"
  # f.close

  message_construct "Спасибо #{@username}", "Ждём вас #{@date_time}."
end

