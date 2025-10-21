class CreateMovieImports < ActiveRecord::Migration[8.0]
  def change
    create_table :movie_imports do |t|
      t.string :file_name
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.integer :processed_count
      t.integer :error_count

      t.timestamps
    end
  end
end
