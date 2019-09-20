class AddDueOnToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :due_on, :date
  end
end
