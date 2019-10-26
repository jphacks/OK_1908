class AddIndexPosinegaWord < ActiveRecord::Migration[5.2]
  def change
    add_index :posinegas, :word
  end
end
