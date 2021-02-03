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
  #asks the user which recipe they would like to cook
  #returns that recipe
  #asks if the user would like to see the list of recipes again, put more ingredients in, or exit
end
