class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end


  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
    SELECT * 
    FROM students
    SQL

    students_array = DB[:conn].execute(sql)
    students_array.map do |student_row|
      self.new_from_db(student_row)
    end
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE students.name = (?)
    SQL

    student_row = DB[:conn].execute(sql, name).flatten
    # return a new instance of the Student class
    self.new_from_db(student_row)

  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade = 9
    SQL

    students_array = DB[:conn].execute(sql)
    # students_array.map do |student_row|
    #   self.new_from_db(student_row)
    # end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade = 10
    LIMIT (?)
    SQL

    students_array = DB[:conn].execute(sql, x)
    # students_array.map do |student_row|
    #   self.new_from_db(student_row)
    # end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade = 10
    LIMIT 1
    SQL

    student_array = DB[:conn].execute(sql).flatten
    new_student = self.new_from_db(student_array)
    new_student
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade < 12
    SQL

    students_array = DB[:conn].execute(sql)
    new_students = students_array.map do |student_row|
      self.new_from_db(student_row)
    end
    new_students
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade = (?)
    SQL

    students_array = DB[:conn].execute(sql, x)
    # students_array.map do |student_row|
    #   self.new_from_db(student_row)
    # end
  end
end
