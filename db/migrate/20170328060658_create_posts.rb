class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :content
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :user_id
    end

    add_index :posts, :user_id
  end
end
