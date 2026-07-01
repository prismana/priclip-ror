class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :code_hash, null: false

      t.timestamps
    end
    add_index :users, :code_hash, unique: true
  end
end
