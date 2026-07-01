class CreateClips < ActiveRecord::Migration[8.1]
  def change
    create_table :clips do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
