require 'bcrypt'

class User
  include       BCrypt
  attr_reader   :name, :id

  def initialize(username, id)
    @name   = username.capitalize
    @id     = id
  end

  def self.exists(user_name)
    begin
      return nil if !user_name
      user_name.strip!
      return nil if user_name.length < 1

      user_name.downcase!
      return true if DB[:USER][:login => user_name]

      false
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.fetch_by_id(user_id)
    begin
      return nil if !user_id    || user_id  < 1

      user_rec = DB[:USER][:id => user_id]
      return nil if !user_rec

      User.new(user_rec[:login], user_rec[:id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  # TODO: refactor user name cleanup
  def self.create(user_name, user_pwd)
    begin
      return nil if !user_name

      user_name.strip!
      user_name.downcase!

      return nil if user_name.length < 1
      #return nil if DB[:USER][:login => user_name]
      return nil if exists(user_name)

      pwd_hash = Password.create(user_pwd)
      id = DB[:USER].insert(:login   => user_name,
                            :passwd  => pwd_hash.to_s)
      return nil if !id

      User.new(user_name, id)
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.authenticate(user_name, user_pwd)
    begin
      return nil if !user_name || user_name.length < 1
      return nil if !user_pwd  || user_pwd.length  < 1

      name_dc = user_name.downcase
      return nil if !user_rec = DB[:USER][:login => name_dc]

      curr_pwd = Password.new(user_rec[:passwd])
      return nil if curr_pwd != user_pwd

      User.new(user_name, user_rec[:id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

end
