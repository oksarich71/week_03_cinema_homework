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

    def customers
      sql = 'SELECT * FROM customers
              INNER JOIN tickets
              ON customer_id = tickets.customer_id
              WHERE tickets.film_id = $1;'
      customers = SqlRunner.run(sql, [@id])
      return customers.map { |customers_hash| Customer.new(customers_hash) }
    #return user object
    end

end #class end
