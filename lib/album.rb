
class Album
  attr_reader   :id, :title, :artist_id

  def initialize(id, album_title, artist_id)
    @id         = id
    @title      = album_title
    @artist_id  = artist_id
  end

  # Case-insensitive lookup
  # TODO: Refactor into a generic lookup-by-name routine
  def self.fetch(album_title, artist_id)
    begin
      album_title and album_title.strip!
      return nil if !album_title || album_title.length  < 1
      return nil if !artist_id   || artist_id           < 1

      title_dc = album_title.downcase
      album_rec = DB[:ALBUM][Sequel.function(:lower, :title) => title_dc,
                             :artist_id                      => artist_id]
      return nil if !album_rec

      Album.new(album_rec[:id], album_rec[:title], album_rec[:artist_id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.fetch_by_id(album_id)
    begin
      return nil if !album_id   || album_id < 1

      album_rec = DB[:ALBUM][:id => album_id]
      return nil if !album_rec

      Album.new(album_rec[:id], album_rec[:title], album_rec[:artist_id])
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

  def self.exists(album_title, artist_id)
    return !!fetch(album_title, artist_id)
  end

  def self.create(album_title, artist_id)
    begin
      album_title and album_title.strip!
      return nil if !album_title || album_title.length < 1

      return nil if exists(album_title, artist_id)
      return nil if !Artist.fetch_by_id(artist_id)

      id = DB[:ALBUM].insert(:title       => album_title,
                             :artist_id   => artist_id)
      return nil if !id

      Album.new(id, album_title, artist_id)
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
        album_recs = DB[:ALBUM].all
      else
        album_recs =
          DB[:ALBUM].                                                   \
            join(:ARTIST,      :id          => :artist_id).             \
            join(:USER_ALBUM,  :album_id    => :ALBUM__id).             \
            join(:USER,       [:USER__id    => :USER_ALBUM__user_id,    \
                               :login       => login]).                 \
            select(:ALBUM__title, :ALBUM__artist_id, :ARTIST__name).all
      end

      album_recs
    rescue Sequel::Error => err
      p err.message
      nil
    end
  end

end
