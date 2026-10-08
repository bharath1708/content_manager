class AddStatusToContents < ActiveRecord::Migration[8.1]
  def change
    add_column :contents, :status, :string, null: false, default: "draft"
    add_index :contents, :status
  end
end
