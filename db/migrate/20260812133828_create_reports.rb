class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.references :task, null: false, foreign_key: true
      t.integer :status, null: false
      t.text :memo, null: false

      t.timestamps
    end
  end
end
