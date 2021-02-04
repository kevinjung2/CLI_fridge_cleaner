require_relative('../config/environment')

class Cli
  #initialize a new instance that starts the program
  def initialize
    self.welcome
  end
  #says hello
  def welcome
    puts "Welcome to Fridge-Clear"
    self.get_ingredients
  end
  #asks the user which ingredients they would like to cook, and passes them to #how_many
  def get_ingredients
    puts "Please enter ingredients that you would like to cook, one at a time. when finished enter 'done'."
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
          popped = ing_array.pop
          puts "You removed #{popped}"
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
  #asks the user how many recipes they would like to see displayed, and calls the API to get them
  def how_many(ing_array)
    puts "How many recipes would you like to see?"
    input = gets.to_i
    if input == 0
      puts "You must see at least one recipe."
      self.how_many
    else
      Recipe.current.clear
      Api.get_recipes_from_ing(ing_array, input)
      self.display_recipe_list
    end
  end
  #puts the list of current recipe names returned from the Api
  def display_recipe_list
    Recipe.current_titles.each.with_index(1) { |title, inx| puts "#{inx}. #{title}" }
    self.get_recipe_choice
  end
  #puts the list of all recipe names returned from the Api
  def display_all_recipe_list
    Recipe.all_titles.each.with_index(1) { |title, inx| puts "#{inx}. #{title}" }
    self.get_recipe_choice_from_all
  end
  #asks the user for which recipe they would like to cook
  def get_recipe_choice
    puts "Enter the number of the recipe you would like to see"
    input = gets.to_i
    if input.between?(1, Recipe.current.length)
      @selection = Recipe.current[input-1]
    else
      puts "That is not a valid choice"
      self.get_recipe_choice
    end
    self.retrieve_recipe
  end
  #asks the user for which recipe they would like to cook from a list of all recipes
  def get_recipe_choice_from_all
    puts "Enter the number of the recipe you would like to see"
    input = gets.to_i
    if input.between?(1, Recipe.all.length)
      @selection = Recipe.all[input-1]
    else
      puts "That is not a valid choice"
      self.get_recipe_choice_from_all
    end
    self.retrieve_recipe
  end
  #sends the choice to the Api to get information
  def retrieve_recipe
    recipe = Api.get_recipe(@selection)
    self.display_recipe(recipe)
  end
  #displays the recipe to the user
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
  #displays program menu
  def menu
    puts "Would you like to:"
    puts "1. See the most recent list of recipes"
    puts "2. See a list of all the recipes you have found"
    puts "3. See a recipe again"
    puts "4. Enter new ingredients"
    puts "5. Quit Fridge Clear"
    self.menu_selection
  end
  #retrieves selection for program menu
  def menu_selection
    input = gets.strip
    case input
    when "1"
      self.display_recipe_list
    when "2"
      self.display_all_recipe_list
    when "3"
      self.display_recipe(Api.get_recipe(@selection))
    when "4"
      self.get_ingredients
    when "5"
      abort("Thank you for using Fridge-Clear")
    else
      puts "Please enter a number that corresponds to a menu option"
      self.menu
    end
  end
end
