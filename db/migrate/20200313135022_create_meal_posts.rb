class CreateMealPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :meal_posts do |t|
      # TODO: content->record, time->done_at
      t.text :content
      t.datetime :time
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
