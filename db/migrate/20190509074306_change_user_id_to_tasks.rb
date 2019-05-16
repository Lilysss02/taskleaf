class ChangeUserIdToTasks < ActiveRecord::Migration[5.2]
  def change
  	change_column :tasks, :user_id, :integer, null: false
  end
end
