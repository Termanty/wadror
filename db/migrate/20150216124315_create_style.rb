class CreateStyle < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description
    end
  end
end
