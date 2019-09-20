class AddFinishedToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :finished, :boolean
  end
end
