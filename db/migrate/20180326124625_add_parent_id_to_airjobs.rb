class AddParentIdToAirjobs < ActiveRecord::Migration[5.1]
  def self.up
    add_column :airjobs, :parent_id, :integer, foreign_key: true
  end

  def self.down
    remove_column :airjobs, :parent_id
  end
end
