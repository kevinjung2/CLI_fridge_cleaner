class Recipe
  attr_accessor :title, :id, :used_ing, :recipe_link

  @@all = []

  def initialize
    self.save
  end

  def self.new_from_hash(hash)
    new = self.new
    new.title = hash["title"]
    new.id = hash["id"]
    new.used_ing = hash["usedIngredientCount"]
  end

  def self.new_from_arr_of_hashes(arr_of_hases)
    arr_of_hases.each { |hash| self.new_from_hash(hash) }
  end

  def save
    @@all << self
  end
end
