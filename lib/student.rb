require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :id, :grade
  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end 

  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
      SQL
      DB[:conn].execute(sql)
  end 

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
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

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

    def self.new_from_db(array)
      self.new(array[0],array[1],array[2])
    end 

    def self.find_by_name(name)
      sql = <<-SQL
        SELECT * FROM students WHERE name = ?
      SQL
     result = DB[:conn].execute(sql, name)
      self.new_from_db(result[0])
    end 
end
