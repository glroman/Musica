
class UserAlbum
  attr_reader   :album_id, :user_id

  def initialize(album_id, user_id)
    @album_id   = album_id
    @user_id    = user_id
  end

  # Case-insensitive lookup
  # TODO: Refactor into a generic lookup-by-name routine
  def self.fetch(album_id, user_id)
    begin
      return nil if !album_id   || album_id < 1
      return nil if !user_id    || user_id  < 1

      ua_rec = DB[:USER_ALBUM][:album_id => album_id,
                               :user_id  => user_id]
      return nil if !ua_rec

      UserAlbum.new(ua_rec[:album_id], ua_rec[:user_id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.exists(album_id, user_id)
    return !!fetch(album_id, user_id)
  end

  def self.create(album_id, user_id)
    begin
      return nil if !album_id   || album_id < 1
      return nil if !user_id    || user_id  < 1

      return nil if exists(album_id, user_id)

      return nil if !Album.fetch_by_id(album_id)
      return nil if !User. fetch_by_id(user_id)

      return nil if !DB[:USER_ALBUM].insert(:album_id   => album_id,
                                            :user_id    => user_id)

      UserAlbum.new(album_id, user_id)
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

end
