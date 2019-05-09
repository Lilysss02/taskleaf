class ChangeTasksNameLimit30 < ActiveRecord::Migration[5.2]
  # バージョンを上げる処理
  def up
  	change_column :tasks, :name, :string, limit: 30
  end
  # バージョンを下げる処理
  def down
  	change_column :tasks, :name, :string
  end
end
