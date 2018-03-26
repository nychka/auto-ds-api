class CreateTableAirjobs < ActiveRecord::Migration[5.1]
  def change
  	
    create_table :airjobs do |t|
    	t.string :job_name
    	t.string :status
    	t.string :result

    	t.timestamps
    end
  end
end
