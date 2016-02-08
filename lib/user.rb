require 'bcrypt'
require 'yaml'

class User
  include       BCrypt
  attr_reader   :name

  def initialize(username)
    @name = username.capitalize
  end

  # TODO: refactor user name cleanup
  def self.create(user_name, user_pwd)
    begin
      return nil if !user_name

      user_name.strip!
      return nil if user_name.length < 1

      user_name.downcase!
      return nil if DB[:USER][:login => user_name]

      pwd_hash = Password.create(user_pwd)
      DB[:USER].insert(:login   => user_name,
                       :passwd  => pwd_hash.to_s)

      DB[:USER][:login => user_name]
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.authenticate(user_name, user_pwd)
    begin
      return nil if !user_name || user_name.length < 1
      return nil if !user_pwd  || user_pwd.length  < 1

      user_name.downcase!

      return nil if !user_rec = DB[:USER][:login => user_name]

      curr_pwd = Password.new(user_rec[:passwd])
      return User.new(user_name) if curr_pwd == user_pwd

      nil
    rescue Sequel::Error => err
      p err.message
      nil
    end
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

end
