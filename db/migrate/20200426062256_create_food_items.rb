class CreateFoodItems < ActiveRecord::Migration[6.0]
  def change
    create_table :food_items do |t|
      t.string :name, null: false
      t.string :amount
      t.bigint :calory
      t.references :meal_post, null: false, foreign_key: true
    end
  end
end
