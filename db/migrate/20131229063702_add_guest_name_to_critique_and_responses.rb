class AddGuestNameToCritiqueAndResponses < ActiveRecord::Migration
  def change
    add_column :critiques, :guest_name, :string
    add_column :responses, :guest_name, :string
  end
end
