class CreateContentTags < ActiveRecord::Migration[8.1]
  def change
    create_table :content_tags do |t|
      t.references :content, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :content_tags, [ :content_id, :tag_id ], unique: true
  end
end
