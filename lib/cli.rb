require_relative('../config/environment')

class Cli

  @@pastel = Pastel.new
  @@font = TTY::Font.new(:standard)

  #initialize a new instance that starts the program
  def initialize
    welcome
  end

  #says hello
  def welcome
    puts @@pastel.green("----------------------------------------------------------------------------------------------------")
    puts @@pastel.cyan(@@font.write("            Welcome"))
    puts @@pastel.cyan(@@font.write("to Fridge-Clear"))
    puts @@pastel.green("----------------------------------------------------------------------------------------------------")
    get_ingredients
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
        leave
      else
        ing_array << input
      end
      puts @@pastel.cyan.bold("Please enter another ingredient, enter 'done' to finish, or enter 'undo' to undo your last entry.")
      input = gets.strip
    end
    if ing_array.size == 0
      puts @@pastel.red("You must enter at least one ingredient!")
      get_ingredients
    else
      how_many(ing_array)
    end
  end

  #asks the user how many recipes they would like to see displayed, and calls the API to get them
  def how_many(ing_array)
    puts @@pastel.cyan.bold("How many recipes would you like to see?")
    input = gets.strip
    if input.to_i == 0
      puts @@pastel.red("You must see at least one recipe.")
      how_many
    elsif input == "quit" || input == "exit"
      leave
    else
      Recipe.current.clear
      Api.get_recipes_from_ing(ing_array, input.to_i)
      display_recipe_list(Recipe.current_titles, Recipe.current)
    end
  end

  #puts the list of recipe names returned from the Api, either from the @@all, @@current, or @@retrieved arrays
  def display_recipe_list(list, array)
    list.each.with_index(1) { |title, inx| puts @@pastel.magenta("#{inx}. #{title}") }
    get_recipe_choice(array)
  end

  #asks the user for which recipe they would like to cook
  def get_recipe_choice(array)
    puts @@pastel.cyan.bold("Enter the number of the recipe you would like to see")
    input = gets.strip
    if input.to_i.between?(1, array.length)
      @selection = array[input.to_i-1]
    elsif input == "quit" || input == "exit"
      leave
    else
      puts @@pastel.red("That is not a valid choice")
      get_recipe_choice(array)
    end
    retrieve_recipe
  end

  #sends the choice to the Api to get information
  def retrieve_recipe
    Recipe.retrieved.include?(@selection) ? recipe = @selection : recipe = Api.get_recipe(@selection)
    display_recipe(recipe)
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
    menu
  end

  #displays program menu
  def menu
    puts @@pastel.cyan("Would you like to:")
    puts @@pastel.cyan("1. See the most " + @@pastel.blue("recent") + " list of recipes")
    puts @@pastel.cyan("2. See a list of " + @@pastel.blue("all") + " the recipes you have found")
    puts @@pastel.cyan("3. See a recipe " + @@pastel.blue("again"))
    puts @@pastel.cyan("4. Enter " + @@pastel.blue("new") + " ingredients")
    puts @@pastel.red("5. Quit Fridge Clear")
    menu_selection
  end
  #retrieves selection for program menu
  def menu_selection
    input = gets.strip
    case input
    when "1", "recent"
      display_recipe_list(Recipe.current_titles, Recipe.current)
    when "2", "all"
      display_recipe_list(Recipe.all_titles, Recipe.all)
    when "3", "again"
      display_recipe_list(Recipe.retrieved_titles, Recipe.retrieved)
    when "4", "new"
      get_ingredients
    when "5", "quit", "exit", "Quit", "Exit"
      leave
    else
      puts @@pastel.red("Please enter a number that corresponds to a menu option")
      menu
    end
  end

  #resposible for exiting the program
  def leave
    abort(@@pastel.blue.bold("Thank you for using Fridge-Clear"))
  end
end
