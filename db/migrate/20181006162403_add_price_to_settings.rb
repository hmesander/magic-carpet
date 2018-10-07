class AddPriceToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :price, :string
  end
end
