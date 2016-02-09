
class Artist
  attr_reader   :name, :id

  def initialize(artist_name, id)
    @name   = artist_name
    @id     = id
  end

  # Case-insensitive lookup
  def self.fetch(artist_name)
    begin
      artist_name and artist_name.strip!
      return nil if !artist_name || artist_name.length < 1

      name_dc = artist_name.downcase
      artist_rec = DB[:ARTIST][Sequel.function(:lower, :name) => name_dc]
      return nil if !artist_rec

      Artist.new(artist_rec[:name], artist_rec[:id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.fetch_by_id(artist_id)
    begin
      return nil if !artist_id || artist_id < 1

      artist_rec = DB[:ARTIST][:id => artist_id]
      return nil if !artist_rec

      Artist.new(artist_rec[:name], artist_rec[:id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.exists(artist_name)
    return !!fetch(artist_name)
  end

  def self.create(artist_name)
    begin
      artist_name and artist_name.strip!
      return nil if !artist_name || artist_name.length < 1

      return nil if exists(artist_name)

      artist_id = DB[:ARTIST].insert(:name   => artist_name)
      return nil if !artist_id

      Artist.new(artist_name, artist_id)
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.list(login = nil)
    begin
      login and login.strip!
      login and login.downcase!

      login = nil if login.length < 1

      if !login
        artist_recs = DB[:ARTIST].all
      else
        artist_recs =
          DB[:ARTIST].                                              \
            join(:ALBUM,       :artist_id  => :id).                 \
            join(:USER_ALBUM,  :album_id   => :ALBUM__id).          \
            join(:USER,       [:USER__id   => :USER_ALBUM__user_id, \
                               :login      => login]).              \
            select(:ARTIST__name, :ARTIST__id).distinct.all
      end

      artist_recs
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

end
