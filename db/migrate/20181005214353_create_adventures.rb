class CreateAdventures < ActiveRecord::Migration[5.2]
  def change
    create_table :adventures do |t|
      t.string :start_lat
      t.string :start_long
      t.string :destination

      t.timestamps
    end
  end
end
