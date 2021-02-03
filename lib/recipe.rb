class Recipe
  def self.new_from_hash(hash)
    new = self.new
    new.title = hash["title"]
    new.id = hash["id"]
    new.used_ing = hash["usedIngredientCount"]
  end
end
