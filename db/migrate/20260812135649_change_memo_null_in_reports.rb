class ChangeMemoNullInReports < ActiveRecord::Migration[7.2]
  def change
     change_column_null :reports, :memo, true
  end
end
