class CreateTicketWatchers < ActiveRecord::Migration
  def change
    create_table :ticket_watchers do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.index [:user_id, :ticket_id]
      t.index [:ticket_id, :user_id]
    end
  end
end
