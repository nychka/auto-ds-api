class CreateTableAirjobs < ActiveRecord::Migration[5.1]
  def self.up
  	
    create_table :airjobs do |t|
    	t.string :job_name, null: false
    	t.integer :status, :integer, default: 0, null: false
    	t.string :result

    	t.timestamps
    end
  end

  def self.down
  	drop_table :airjobs
  end
end
