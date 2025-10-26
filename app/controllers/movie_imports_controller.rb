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
    @movie_import = current_user.movie_imports.build(status: "pending", error_count: 0, processed_count: 0)

    @movie_import.csv_file.attach(
      io: params[:movie_import][:csv_file],
      filename: params[:movie_import][:file_name]
    )

    if @movie_import.save
      MovieImportJob.perform_later(@movie_import.id)
      redirect_to @movie_import, notice: t("movie_imports.upload_successful")
    else
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
