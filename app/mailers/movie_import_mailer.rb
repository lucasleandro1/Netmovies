class MovieImportMailer < ApplicationMailer
  default from: "noreply@netmovies.com"

  def import_completed(movie_import)
    @movie_import = movie_import
    @user = movie_import.user

    mail(
      to: @user.email,
      subject: "Importação de filmes concluída com sucesso"
    )
  end

  def import_failed(movie_import)
    @movie_import = movie_import
    @user = movie_import.user

    mail(
      to: @user.email,
      subject: "Falha na importação de filmes"
    )
  end
end
