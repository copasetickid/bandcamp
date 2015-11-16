class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :color

      t.timestamps null: false
    end

    add_reference :tickets, :state, index: true, foreign_key: true
    add_reference :comments, :state, foreign_key: true
  end
end
