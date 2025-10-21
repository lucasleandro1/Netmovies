class MovieImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie_import, only: [ :show ]

  def index
    @movie_imports = current_user.movie_imports.ordered_by_newest.page(params[:page]).per(10)
  end

  def new
    @movie_import = current_user.movie_imports.build
  end

  def create
    @movie_import = current_user.movie_imports.build(movie_import_params)
    @movie_import.status = "pending"

    if @movie_import.save
      # Trigger Sidekiq job for async processing
      MovieImportJob.perform_async(@movie_import.id)
      redirect_to @movie_import, notice: t("movie_imports.upload_successful")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Show import status and details
  end

  private

  def set_movie_import
    @movie_import = current_user.movie_imports.find(params[:id])
  end

  def movie_import_params
    params.require(:movie_import).permit(:file_name, :csv_file)
  end
end
