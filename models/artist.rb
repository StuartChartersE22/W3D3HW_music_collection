require("pg")
require_relative("../db/sql_runner.rb")

class Artist

  attr_reader(:id, :name)

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

end
