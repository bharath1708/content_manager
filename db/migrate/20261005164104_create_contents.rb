class CreateContents < ActiveRecord::Migration[8.1]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :description
      t.string :platform
      t.string :content_type

      t.timestamps
    end
  end
end
