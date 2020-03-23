class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meal_post, null: false, foreign_key: true
      t.boolean :is_upvote, null: false
      t.timestamps
    end

    add_index :votes, %i[user_id meal_post_id], unique: true
  end
end
