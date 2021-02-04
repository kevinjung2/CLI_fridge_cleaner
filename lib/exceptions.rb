class EmptyUndoError < StandardError
  def message
    "You have no ingredients to undo!"
  end
end
