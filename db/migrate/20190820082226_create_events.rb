class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :url
      t.string :title
      t.string :address
      t.datetime :started_at

      t.timestamps
    end
  end
end
