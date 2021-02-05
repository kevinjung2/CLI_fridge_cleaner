require_relative('../config/environment')

class Api

  API_KEY = "7ab46aa5f86d43f2addd9e5da1e6a23d"

  #get request to the api for a list of recipes including the ingredients that user inputs, creates Recipe instances with the returned recipes
  def self.get_recipes_from_ing(ing_array, num_of_recipes = 2)
    ingredients = ing_array.join(",+")
    #ingredients KW = the ingredients to include; number KW indeicates the number of recipes; ranking KW indicates to the program to proritize recipes with more of the given ingredients.
    url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=#{API_KEY}&ingredients=#{ingredients}&number=#{num_of_recipes}&ranking=1"
    response = HTTParty.get(url)
    Recipe.new_from_arr_of_hashes(response)
  end

  #get request to the api for the users chosen recipe, updates that recipe instance with the info returned
  def self.get_recipe(recipe)
    recipe_id = recipe.id
    url = "https://api.spoonacular.com/recipes/#{recipe_id}/information?apiKey=#{API_KEY}&includeNutrition=false"
    response = HTTParty.get(url)
    current = Recipe.find_by_id(recipe_id)
    current.info_from_hash(response)
    current
  end
end
