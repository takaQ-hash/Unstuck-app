class AddLastNotifiedAtToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :last_notified_at, :datetime
  end
end
