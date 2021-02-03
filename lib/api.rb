require_relative('../config/environment')

class Api

  API_KEY = "7ab46aa5f86d43f2addd9e5da1e6a23d"


    def self.get_recipes_from_ing(ing_array, num_of_recipes = 2)
      ingredients = ing_array.join(",+")
      url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=#{API_KEY}&ingredients=#{ingredients}&number=#{num_of_recipes}"
      response = HTTParty.get(url)
    end
end
