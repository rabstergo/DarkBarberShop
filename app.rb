require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'
require './methods'
#comment
set :database, { adapter: 'sqlite3', database: 'barbershop.db' }

class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  validates :phone, presence: true, length: { in: 9..13 }
  validates :datestamp, presence: true
  validates :barber, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  validates :mail, presence: true
  validates :body, presence: true, length: { maximum: 200 }
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
  @con = Contact.new
  erb :contacts
end

post '/contacts' do
  @con = Contact.new params[:contact]

  if @con.save
    erb "Спасибо за обращение."
  else
    @error = @con.errors.full_messages.first
    erb :contacts
  end
end

get '/show_contacts' do
  erb :show_contacts
end

get '/visit' do
  @c = Client.new
	erb :visit
end

post '/visit' do
  @c = Client.new params[:client]

  if @c.save
    erb "Спасибо за запись! Мы вас ждём."
  else
    @error = @c.errors.full_messages.first
    erb :visit
  end
end

get '/show_barbers' do
  erb :show_barbers
end

get '/barber/:id' do
  barber_id = params[:id]

  barber = Barber.find(barber_id)
  @title = "#{barber.name} barber"
  @message = "placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups."

  erb :message
end

get '/show_users' do
  erb :show_users
end
