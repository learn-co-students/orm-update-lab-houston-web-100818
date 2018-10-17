require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade 
  attr_reader :id

  def initialize(id = nil)
    self.name = name 
    self.grade = grade 
    @id = id 
  end 
  
  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE students"
    
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update 
    else
     sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def self.create(name, grade)
    stud = self.new(name, grade)
    stud.save
    stud 
  end
  
  def self.new_from_db 
    stud = self.new
  end 
  
  def update
    sql = "UPDATE students SET name = ?, grade = ?, id = ? "
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
