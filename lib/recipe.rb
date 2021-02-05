class Recipe
  attr_accessor :title, :id, :used_ing, :recipe_link, :instructions, :ingredients

  @@all = []
  @@retrieved = []
  @@current = []

  #saves all new instances of the Recipe class
  def initialize
    self.save
  end

  #creates a new recipe instance from a hash of data retrieved by api
  def self.new_from_hash(hash)
    new = self.new
    new.title = hash["title"]
    new.id = hash["id"]
    new.used_ing = hash["usedIngredientCount"]
  end

  #creates a number of new recipe instances from the array of hashes recieved by the api using #.new_from_hash
  def self.new_from_arr_of_hashes(arr_of_hases)
    arr_of_hases.each { |hash| self.new_from_hash(hash) }
  end

  #saves an instance of a recipe to the all and current arrays
  def save
    @@all << self
    @@current << self
  end

  #returns the titles of all the recipes in the @@current array
  def self.current_titles
    @@current.collect { |r| r.title }
  end

  #returns the titles of all the recipes in the @@all array
  def self.all_titles
    @@all.collect { |r| r.title }
  end

  #returns the titles of all the recipes in the @@retrieved array
  def self.retrieved_titles
    @@retrieved.collect { |r| r.title }
  end

  # returns the @@all array
  def self.all
    @@all
  end

  #returns the @@current array
  def self.current
    @@current
  end

  #returns the @@retrieved array
  def self.retrieved
    @@retrieved
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
