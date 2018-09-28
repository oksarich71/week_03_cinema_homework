require('pg')
require_relative('../db/sql_runner.rb')

class Ticket

  attr_accessor(:customer_id, :film_id)
  attr_reader(:id)

  def initialize(options)
    @id = options['id'].to_i()
    @customer_id = options['customer_id']
    @film_id = options['film_id']
  end

  def save()
      sql = "INSERT INTO tickets (
          customer_id,
          film_id
          )
        VALUES ($1, $2)
        RETURNING id;"

      values = [@customer_id, @film_id]
      result = SqlRunner.run(sql, values)

      result_hash = result[0]
      string_id = result_hash['id']
      id = string_id.to_i()
      @id = id
     end

     def self.delete_all
     sql = "DELETE FROM tickets"
     SqlRunner.run(sql)
   end
   def update()
     sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2) WHERE id = $3;"
     values = [@customer_id, @film_id, @id]
     SqlRunner.run(sql, values)
    end
end #class end
