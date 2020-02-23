require "active_record"
require "./connect_db"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def over_due?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def self.duetoday
    where("due_date = ?" , Date.today)
  end

  def self.overdue
    where("due_date < ?" , Date.today)
  end

  def self.duelater
    where("due_date > ?" , Date.today)
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{self.id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts overdue.order(id: :asc).map { |todo| todo.to_displayable_string}
    puts "\n\n"

    puts "Due Today\n"
    puts duetoday.order(id: :asc).map { |todo| todo.to_displayable_string}
    puts "\n\n"

    puts "Due Later\n"
    puts duelater.order(id: :asc).map { |todo| todo.to_displayable_string}
    puts "\n\n"
  end

  def self.add_task(h)
    create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.update(completed: true)
    return todo
  end
end
