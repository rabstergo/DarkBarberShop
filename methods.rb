def message_construct(title, message="")
  @title = title
  @message = message
  erb :message
end

def save_form_data_to_database
  $db.execute 'INSERT INTO Users (username, phone, hairdresser, date_time, hair_color)
                  VALUES (?, ?, ?, ?, ?)',
             [@username, @phone, @hairdresser, @date_time, @hair_color]
end

def is_table_exists?(db, username)
  db.execute('SELECT * FROM Hairdressers WHERE username=?', [username]).length > 0
end