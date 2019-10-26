class CreatePosinegas < ActiveRecord::Migration[5.2]
  def change
    create_table :posinegas do |t|
      t.string :word
      t.integer :score
      t.string :item
      t.timestamps
    end
  end
end
