require_relative('../db/sql_runner.rb')

class Film

  attr_accessor(:title, :price)
  attr_reader(:id)

  def initialize(options)
    @id = options['id'].to_i()
    @title = options['title']
    @price = options['price'].to_i()
  end

  def save()
    sql = "INSERT INTO films (
        title,
        price
        )
      VALUES ($1, $2)
      RETURNING id;"

    values = [@title, @price]
    result = SqlRunner.run(sql, values)

    result_hash = result[0]
    string_id = result_hash['id']
    id = string_id.to_i()
    @id = id
   end

   def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def update()
     sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3;"
     values = [@title, @price, @id]
     SqlRunner.run(sql, values)
    end

end #class end
