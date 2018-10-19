require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    self.id = id
    self.name = name
    self.grade = grade
  end

  # creates students table with id, name, grade columns
  def self.create_table
    # creates students table with id, name, grade columns
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL

    DB[:conn].execute(sql)
  end

  # drops students table
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  # updates DB row that corresponds to the given Student instance
  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  # inserts new DB row based on object's attributes & assigns DB id back to object
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?,?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  # creates a student with two attributes, name and grade, saves it in DB
  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end

  # takes row (array of id, name, grade)from DB, creates new Student object
  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  # takes name argument, queries the DB for row with matching name, instantiates a Student object with the database row that the SQL query returns.
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end

end
