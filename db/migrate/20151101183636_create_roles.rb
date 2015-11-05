class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :role
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
