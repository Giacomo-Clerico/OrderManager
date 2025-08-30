class CreateStorages < ActiveRecord::Migration[8.0]
  def change
    create_table :storages do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false
      t.timestamps
    end
  end
end
