class CreateVideosTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :videos do |t|
  		t.string :embed
  		t.integer :user_id
  		t.timestamp
  	end
  end
end
