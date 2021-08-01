require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'
require './methods'

set :database, { adapter: 'sqlite3', database: 'barbershop.db' }

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

configure do
end

get '/' do
  redirect '/visit'
end

get '/about' do
	message_construct('О нас', 'Мы одна из перспективных компаний занимающаяся перспектиными разработками новых технологий в сфере парикмахерской индустрии XXI века. Мы всегда рады как бедному обросшему бездомному, так и богатенькому дяде решившегося обратиться к нам после долгово запоя.')
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  Contact.create params[:contact]

  erb "Спасибо #{@name} за обращение."
end

get '/show_contacts' do
  erb :show_contacts
end

get '/visit' do
	erb :visit
end

post '/visit' do
  hh = { name: 'Введите имя', phone: 'Введите номер телефона', datestamp: 'Введите дату', }

  @error = hh.select { |key, _| params[key] == "" }.values.join(", ")

  return erb :visit if @error != ''

  Client.create params[:client]

  erb "Спасибо за запись! Мы вас ждём."
end

get '/show_users' do
  erb :show_users
end