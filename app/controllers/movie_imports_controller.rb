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
    result = MovieImportManager::Creator.call(current_user, params[:movie_import])
    if result[:success]
      MovieImportJob.perform_async(result[:resource].id)
      redirect_to result[:resource], notice: result[:message] || t("movie_imports.upload_successful")
    else
      @movie_import = current_user.movie_imports.build
      flash.now[:alert] = result[:error_message]
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_movie_import
    @movie_import = current_user.movie_imports.find(params[:id])
  end

  def movie_import_file_params
    params.require(:movie_import).permit(:file_name, :csv_file)
  end
end
