require('pg')
require_relative('../db/sql_runner.rb')
require_relative('./film.rb')

class Customer

  attr_accessor(:name, :funds)
  attr_reader(:id)

  def initialize(options)
    @id = options['id'].to_i()
    @name = options['name']
    @funds = options['funds'].to_i()
  end

  def save()
      sql = "INSERT INTO customers (
          name,
          funds
          )
        VALUES ($1, $2)
        RETURNING id;"

      values = [@name, @funds]
      result = SqlRunner.run(sql, values)

      result_hash = result[0]
      string_id = result_hash['id']
      id = string_id.to_i()
      @id = id
  end

  def self.delete_all
     sql = "DELETE FROM customers"
     SqlRunner.run(sql)
   end

   def update()
     sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3;"
     values = [@name, @funds, @id]
     SqlRunner.run(sql, values)
    end

    def films
      sql = 'SELECT * FROM films
              INNER JOIN tickets
              ON film_id = tickets.film_id
              WHERE tickets.customer_id = $1;'
      films = SqlRunner.run(sql, [@id])
      return films.map { |films_hash| Film.new(films_hash) }
    #return user object
    end
end #class end
