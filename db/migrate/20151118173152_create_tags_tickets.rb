class CreateTagsTickets < ActiveRecord::Migration
  def change
    create_table :tag_tickets do |t|
      t.integer :tag_id
      t.integer :ticket_id
      t.index [:tag_id, :ticket_id]
      t.index [:ticket_id, :tag_id]
    end
  end
end
