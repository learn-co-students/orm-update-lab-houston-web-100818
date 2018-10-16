require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade 
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name 
    @grade = grade 
    @id = id
  end 

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE students')
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade) 
    student.save
    student
  end

  def self.new_from_db(array)
    self.new(array[1], array[2], array[0])
    # @id = array[0]
    # @name = array[1]
    # @grade = array[2]
    # new_student = self.new(@name, @grade, @id)
    # new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    array = DB[:conn].execute(sql, name)
    self.new_from_db(array[0])
  end

  def update
    sql = <<-SQL 
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
