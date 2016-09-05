class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :image_url
      t.string :image
      t.string :date
      t.integer :user_id
      t.text :picktext

      t.timestamps
    end
  end
end
