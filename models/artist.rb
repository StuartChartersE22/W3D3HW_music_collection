require("pg")
require_relative("../db/sql_runner.rb")

class Artist

  attr_reader(:id)
  attr_accessor(:name)

  def initialize(details)
    @id = details["id"].to_i() if details["id"]
    @name = details["name"]
  end

  def save()
    sql = "INSERT INTO artists
    (name)
    VALUES
    ($1)
    RETURNING id"
    values = [@name]
    db_id_result = SqlRunner.run(sql,values)
    @id = db_id_result[0]["id"].to_i()
  end

  def self.all()
    sql = "SELECT * FROM artists"
    artists = SqlRunner.run(sql)
    return artists.map {|artist| Artist.new(artist)} #takes in hash of artist and we create objects from them.
  end

  def self.delete_all()
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end

  def albums()
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    artists_album_details = SqlRunner.run(sql, values)
    return artists_album_details.map {|album_detail| Album.new(album_detail)}
  end

  def update()
    sql = "UPDATE artists SET name = $1 WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql,values)
  end

  def delete()
    sql = "DELETE FROM artists WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def force_delete()
    sql = "DELETE FROM albums WHERE artist_id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
    delete()
  end

  def self.find_artists_by_name(name_of_artists)
    sql = "SELECT * FROM artists WHERE name = $1"
    values = [name_of_artists]
    results = SqlRunner.run(sql, values)
    return results.map {|artist| Artist.new(artist)}
  end

  def self.find_artist_by_id(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Artist.new(results[0])
  end

  def self.find_artists_by_genre(genre)
    sql = "SELECT artist_id FROM albums WHERE genre = $1"
    values = [genre]
    results = SqlRunner.run(sql, values).values().flatten()
    return results.map {|id| self.find_artist_by_id(id)}
  end

  def self.delete(id)
    sql = "DELETE FROM artists WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.force_delete(id)
    sql = "DELETE FROM albums WHERE artist_id = $1"
    values = [id]
    SqlRunner.run(sql, values)
    self.delete(id)
  end

end
