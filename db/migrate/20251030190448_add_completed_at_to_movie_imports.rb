class AddCompletedAtToMovieImports < ActiveRecord::Migration[8.0]
  def change
    add_column :movie_imports, :completed_at, :datetime
  end
end
