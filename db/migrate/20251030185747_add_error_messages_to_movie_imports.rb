class AddErrorMessagesToMovieImports < ActiveRecord::Migration[8.0]
  def change
    add_column :movie_imports, :error_messages, :text
  end
end
