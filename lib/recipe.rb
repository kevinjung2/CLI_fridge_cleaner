class Recipe
  attr_accessor :title, :id, :used_ing, :recipe_link, :instructions, :ingredients

  @@all = []
  @@retrieved = []

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

  def self.titles
    @@all.collect { |r| r.title }
  end

  def self.id_from_title(title)
    @@all.find { |r| r.title == title }.id
  end

  def self.all
    @@all
  end
  #add #self.find_by_id
  def self.find_by_id(id)
    @@all.find { |r| r.id == id }
  end
  #add #info_from_hash
  def info_from_hash(hash)
    self.recipe_link = hash["sourceUrl"]
    self.ingredients = hash["extendedIngredients"].collect {|ing| ing["originalString"] }
    self.instructions = hash["instructions"]
    @@retrieved << self
  end
end
