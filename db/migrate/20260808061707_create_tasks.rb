class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.date :deadline, null: false
      t.integer :notification_type, null: false
      t.string :notification_value, null: false

      t.timestamps
    end
  end
end
