class AddCategoryToContents < ActiveRecord::Migration[8.1]
  def change
    add_reference :contents, :category, null: true, foreign_key: true
  end
end
