require_relative('../config/environment')

class Cli
  @@pastel = Pastel.new
  @@font = TTY::Font.new(:standard)
  #initialize a new instance that starts the program
  def initialize
    self.welcome
  end
  #says hello
  def welcome
    puts @@pastel.green("----------------------------------------------------------------------------------------------------")
    puts @@pastel.cyan(@@font.write("            Welcome"))
    puts @@pastel.cyan(@@font.write("to Fridge-Clear"))
    puts @@pastel.green("----------------------------------------------------------------------------------------------------")
    self.get_ingredients
  end
  #asks the user which ingredients they would like to cook, and passes them to #how_many
  def get_ingredients
    puts @@pastel.cyan.bold("Please enter ingredients that you would like to cook, one at a time. when finished enter 'done'.\n                           "+ @@pastel.red(" Or enter quit at anytime to leave."))
    ing_array = []
    input = gets.strip
    while input != "done" && input != ""
      if input == "undo"
        if ing_array.size == 0
          begin
            raise EmptyUndoError
          rescue EmptyUndoError => error
            puts @@pastel.red.bold(error.message)
          end
        else
          popped = ing_array.pop
          puts @@pastel.red("You removed #{popped}")
        end
      elsif input == "quit" || input == "exit"
        abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
      else
        ing_array << input
      end
      puts @@pastel.cyan.bold("Please enter another ingredient, enter 'done' to finish, or enter 'undo' to undo your last entry.")
      input = gets.strip
    end
    if ing_array.size == 0
      puts @@pastel.red("You must enter at least one ingredient!")
      self.get_ingredients
    else
      self.how_many(ing_array)
    end
  end
  #asks the user how many recipes they would like to see displayed, and calls the API to get them
  def how_many(ing_array)
    puts @@pastel.cyan.bold("How many recipes would you like to see?")
    input = gets.strip
    if input.to_i == 0
      puts @@pastel.red("You must see at least one recipe.")
      self.how_many
    elsif input == "quit" || input == "exit"
      abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
    else
      Recipe.current.clear
      Api.get_recipes_from_ing(ing_array, input.to_i)
      self.display_recipe_list
    end
  end
  #puts the list of current recipe names returned from the Api
  def display_recipe_list
    Recipe.current_titles.each.with_index(1) { |title, inx| puts @@pastel.magenta("#{inx}. #{title}") }
    self.get_recipe_choice
  end
  #puts the list of all recipe names returned from the Api
  def display_all_recipe_list
    Recipe.all_titles.each.with_index(1) { |title, inx| puts @@pastel.magenta("#{inx}. #{title}") }
    self.get_recipe_choice_from_all
  end
  #asks the user for which recipe they would like to cook
  def get_recipe_choice
    puts @@pastel.cyan.bold("Enter the number of the recipe you would like to see")
    input = gets.to_i
    if input.to_i.between?(1, Recipe.current.length)
      @selection = Recipe.current[input.to_i-1]
    elsif input == "quit" || input == "exit"
      abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
    else
      puts @@pastel.red("That is not a valid choice")
      self.get_recipe_choice
    end
    self.retrieve_recipe
  end
  #asks the user for which recipe they would like to cook from a list of all recipes
  def get_recipe_choice_from_all
    puts @@pastel.cyan.bold("Enter the number of the recipe you would like to see")
    input = gets.strip
    if input.to_i.between?(1, Recipe.all.length)
      @selection = Recipe.all[input.to_i-1]
    elsif input == "quit" || input == "exit"
      abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
    else
      puts @@pastel.red("That is not a valid choice")
      self.get_recipe_choice_from_all
    end
    self.retrieve_recipe
  end
  #sends the choice to the Api to get information
  def retrieve_recipe
    Recipe.retrieved.include?(@selection) ? recipe = @selection : recipe = Api.get_recipe(@selection)
    self.display_recipe(recipe)
  end
  #displays a list of the recipes already retrieved from the API
  def display_retrieved_recipes
    Recipe.retrieved_titles.each.with_index(1) { |title, inx| puts @@pastel.magenta("#{inx}. #{title}") }
    self.get_recipe_choice_from_retrieved
  end
  #asks the user for which recipe they would like to cook from a list of retrieved recipes
  def get_recipe_choice_from_retrieved
    puts @@pastel.cyan.bold("Enter the number of the recipe you would like to see")
    input = gets.strip
    if input.to_i.between?(1, Recipe.retrieved.length)
      @selection = Recipe.retrieved[input.to_i-1]
    elsif input == "quit" || input == "exit"
      abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
    else
      puts @@pastel.red("That is not a valid choice")
      self.get_recipe_choice_from_retrieved
    end
    self.retrieve_recipe
  end
  #displays the recipe to the user
  def display_recipe(recipe)
    puts @@pastel.green("------------------------------")
    puts @@pastel.on_blue("#{recipe.title}")
    puts @@pastel.green("------------------------------")
    recipe.ingredients.each {|ing| puts @@pastel.on_blue("#{ing}")}
    puts @@pastel.green("------------------------------")
    puts @@pastel.on_blue("#{recipe.instructions}")
    puts @@pastel.green("------------------------------")
    puts @@pastel.magenta(TTY::Link.link_to("Recipe source link", recipe.recipe_link))
    self.menu
  end
  #displays program menu
  def menu
    puts @@pastel.cyan("Would you like to:")
    puts @@pastel.cyan("1. See the most recent list of recipes")
    puts @@pastel.cyan("2. See a list of all the recipes you have found")
    puts @@pastel.cyan("3. See a recipe again")
    puts @@pastel.cyan("4. Enter new ingredients")
    puts @@pastel.red("5. Quit Fridge Clear")
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
      self.display_retrieved_recipes
      self.display_recipe(Api.get_recipe(@selection))
    when "4"
      self.get_ingredients
    when "5", "quit", "exit"
      abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
    else
      puts @@pastel.red("Please enter a number that corresponds to a menu option")
      self.menu
    end
  end
end
