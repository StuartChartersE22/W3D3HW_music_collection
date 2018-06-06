require("pg")
require_relative("../db/sql_runner.rb")

class Album

  attr_reader(:id, :artist_id)
  attr_accessor(:name, :genre)

  def initialize(details)
    @id = details["id"].to_i() if details["id"]
    @name = details["name"]
    @genre = details["genre"]
    @artist_id = details["artist_id"].to_i()
  end

  def save()
    sql = "INSERT INTO albums
    (name, genre, artist_id)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@name, @genre, @artist_id]
    db_id_result = SqlRunner.run(sql,values)
    @id = db_id_result[0]["id"].to_i()
  end

  def self.all()
    sql = "SELECT * FROM albums"
    albums = SqlRunner.run(sql)
    return albums.map {|album| Album.new(album)} #takes in hash of albums and we create objects from them.
  end

  def self.delete_all()
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def artist()
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    artist_details = SqlRunner.run(sql,values)
    return Artist.new(artist_details[0])
  end

  def update()
    sql = "UPDATE albums SET (name, genre, artist_id) = ($1, $2, $3) WHERE id = $4"
    values = [@name, @genre, @artist_id, @id]
    SqlRunner.run(sql,values)
  end

  def change_artist(id)
    sql = "SELECT id FROM artists WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    @artist_id = id if result.values().length() != 0
  end

  def delete()
    sql = "DELETE FROM albums WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find_albums_by_name(name_of_album)
    sql = "SELECT * FROM albums WHERE name = $1"
    values = [name_of_album]
    results = SqlRunner.run(sql, values)
    return results.map {|album| Album.new(album)}
  end

  def self.find_albums_by_id(id)
    sql = "SELECT * FROM albums WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Album.new(results[0])
  end

  def self.delete(id)
    sql = "DELETE FROM albums WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

end
