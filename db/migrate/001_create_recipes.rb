class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :recipe_id
      t.text :ingredients
      t.text :instructions
      t.string :recipe_link
    end
  end
end
