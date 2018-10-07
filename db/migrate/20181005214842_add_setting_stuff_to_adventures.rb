class AddSettingStuffToAdventures < ActiveRecord::Migration[5.2]
  def change
    add_reference :adventures, :setting, foreign_key: true
  end
end
