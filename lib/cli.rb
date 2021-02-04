require_relative('../config/environment')

class Cli
  #initialize a new instance that starts the program
  def initialize
    self.welcome
  end

  def welcome
    puts "Welcome to Fridge-Clear"
    puts "Please enter ingredients that you would like to cook, one at a time. when finished enter 'done'."
    self.get_ingredients
  end
  #welcomes user to program and asks for ingredients that would like to be cooked
  #gets users input and shows the user a list of recipes
  def get_ingredients
    ing_array = []
    input = gets.strip
    while input != "done"
      if input == "undo"
        if ing_array.size == 0
          begin
            raise EmptyUndoError
          rescue EmptyUndoError => error
            puts error.message
          end
        else
          ing_array.pop
        end
      else
        ing_array << input
      end
      puts "Please enter another ingredient, enter 'done' to finish, or enter 'undo' to undo your last entry."
      input = gets.strip
    end
    if ing_array.size == 0
      puts "You must enter at least one ingredient!"
      self.get_ingredients
    else
      self.how_many(ing_array)
    end
  end

  def how_many(ing_array)
    puts "How many recipes would you like to see?"
    input = gets.to_i
    if input == 0
      puts "You must see at least one recipe."
      self.how_many
    else
      Api.get_recipes_from_ing(ing_array, input)
      self.display_recipe_list
    end
  end

  def display_recipe_list
    Recipe.titles.each.with_index(1) { |title, inx| puts "#{inx}. #{title}" }
    self.get_recipe_choice
  end

  def get_recipe_choice
    puts "Enter the number of the recipe you would like to see"
    input = gets.to_i
    if input.between?(1, Recipe.all.length)
      @selection = Recipe.all[input-1]
    else
      puts "That is not a valid choice"
      self.get_recipe_choice
    end
    self.retrieve_recipe
  end

  def retrieve_recipe
    recipe = Api.get_recipe(@selection)
    self.display_recipe(recipe)
  end

  def display_recipe(recipe)
    puts "------------------------------"
    puts "#{recipe.title}"
    puts "------------------------------"
    recipe.ingredients.each {|ing| puts ing}
    puts "------------------------------"
    puts recipe.instructions
    puts "------------------------------"
    puts TTY::Link.link_to("Recipe source link", recipe.recipe_link)
    self.menu
  end

  def menu
    puts "Would you like to:"
    puts "1. See the list of recipes"
    puts "2. See a recipe again"
    puts "3. Enter new ingredients"
    puts "4. Quit Fridge Clear"
    self.menu_selection
  end

  
  #returns that recipe
  #asks if the user would like to see the list of recipes again, put more ingredients in, or exit
end
