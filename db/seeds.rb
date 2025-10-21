# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🎬 Criando dados de exemplo para Netmovies..."

# Criar usuários
puts "👤 Criando usuários..."
admin_user = User.find_or_create_by(email: "admin@netmovies.com") do |user|
  user.password = "123456"
  user.password_confirmation = "123456"
end

demo_user = User.find_or_create_by(email: "usuario@demo.com") do |user|
  user.password = "123456"
  user.password_confirmation = "123456"
end

puts "✅ Usuários criados: #{User.count}"

# Criar categorias
puts "🏷️ Criando categorias..."
categories_data = [
  "Ação", "Aventura", "Comédia", "Drama", "Ficção Científica",
  "Terror", "Romance", "Suspense", "Animação", "Documentário",
  "Musical", "Western", "Guerra", "Crime", "Família"
]

categories_data.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

puts "✅ Categorias criadas: #{Category.count}"

# Criar tags
puts "🏷️ Criando tags..."
tags_data = [
  "blockbuster", "indie", "cult", "oscar", "netflix", "marvel", "dc",
  "adaptação", "remake", "sequência", "trilogia", "baseado-em-livro",
  "true-story", "sci-fi", "fantasy", "superhero", "vintage", "modern"
]

tags_data.each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

puts "✅ Tags criadas: #{Tag.count}"

# Criar filmes
puts "🎬 Criando filmes..."
ai_service = MovieAiService.new

movies_data = [
  {
    title: "Matrix",
    synopsis: "Um programador de computador descobre que a realidade como ele conhece é uma simulação controlada por máquinas inteligentes. Ele se junta a uma rebelião para libertar a humanidade desta prisão digital.",
    year: 1999,
    duration: 136,
    director: "Lana e Lilly Wachowski",
    categories: [ "Ação", "Ficção Científica" ],
    tags: [ "cult", "sci-fi", "blockbuster" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BNzQzOTk3OTAtNDQ0Zi00ZTVkLWI0MTEtMDllZjNkYzNjNTc4L2ltYWdlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg"
  },
  {
    title: "Pulp Fiction",
    synopsis: "As vidas de dois assassinos da máfia, um boxeador, a esposa de um gângster e dois bandidos se entrelaçam em quatro histórias de violência e redenção.",
    year: 1994,
    duration: 154,
    director: "Quentin Tarantino",
    categories: [ "Crime", "Drama" ],
    tags: [ "cult", "indie", "oscar" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg"
  },
  {
    title: "O Poderoso Chefão",
    synopsis: "A saga épica da família Corleone, que segue a transformação de Michael Corleone de relutante forasteiro da família para chefe implacável da máfia.",
    year: 1972,
    duration: 175,
    director: "Francis Ford Coppola",
    categories: [ "Crime", "Drama" ],
    tags: [ "oscar", "vintage", "baseado-em-livro" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg"
  },
  {
    title: "Cidade de Deus",
    synopsis: "A história de duas crianças que crescem em caminhos diferentes na Cidade de Deus, uma favela violenta nos subúrbios do Rio de Janeiro.",
    year: 2002,
    duration: 130,
    director: "Fernando Meirelles",
    categories: [ "Crime", "Drama" ],
    tags: [ "oscar", "true-story", "indie" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BMGU5OWEwZDItNmNkMC00NzZmLTk1YTctNzVhZTJjM2NlZTVmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg"
  },
  {
    title: "Vingadores: Ultimato",
    synopsis: "Após Thanos eliminar metade do universo, os Vingadores restantes se unem para uma batalha final para desfazer suas ações e restaurar o equilíbrio do universo.",
    year: 2019,
    duration: 181,
    director: "Anthony e Joe Russo",
    categories: [ "Ação", "Aventura", "Ficção Científica" ],
    tags: [ "marvel", "blockbuster", "superhero" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_SX300.jpg"
  },
  {
    title: "Parasita",
    synopsis: "Uma família pobre esquematiza para se infiltrar na casa de uma família rica, mas seu plano cuidadosamente elaborado começa a se desenrolar.",
    year: 2019,
    duration: 132,
    director: "Bong Joon-ho",
    categories: [ "Drama", "Suspense", "Comédia" ],
    tags: [ "oscar", "indie", "modern" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BYWZjMjk3ZTItODQ2ZC00NTY5LWE0ZDYtZTI3MjcwN2Q5NTVkXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_SX300.jpg"
  },
  {
    title: "Toy Story",
    synopsis: "Um cowboy de brinquedo fica enciumado quando um novo brinquedo espacial se torna o favorito do menino, mas eles devem trabalhar juntos quando ficam presos na casa do vizinho.",
    year: 1995,
    duration: 81,
    director: "John Lasseter",
    categories: [ "Animação", "Família", "Comédia" ],
    tags: [ "oscar", "família", "modern" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BMDU2ZWJlMjktMTRhMy00ZTA5LWEzNDgtYmNmZTEwZTViZWJkXkEyXkFqcGdeQXVyNDQ2OTk4MzI@._V1_SX300.jpg"
  },
  {
    title: "O Silêncio dos Inocentes",
    synopsis: "Uma jovem agente do FBI busca a ajuda do brilhante mas perigoso Dr. Hannibal Lecter para capturar outro serial killer conhecido como Buffalo Bill.",
    year: 1991,
    duration: 118,
    director: "Jonathan Demme",
    categories: [ "Suspense", "Terror", "Crime" ],
    tags: [ "oscar", "cult", "adaptação" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BNjNhZTk0ZmEtNjJhMi00YzFlLWE1MmEtYzM1M2ZmMGMwMTU4XkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg"
  },
  {
    title: "Forrest Gump",
    synopsis: "A vida extraordinária de Forrest Gump, um homem simples que inadvertidamente influencia momentos históricos importantes enquanto busca seu amor verdadeiro.",
    year: 1994,
    duration: 142,
    director: "Robert Zemeckis",
    categories: [ "Drama", "Romance" ],
    tags: [ "oscar", "inspiracional", "baseado-em-livro" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BNWIwODRlZTUtY2U3ZS00Yzg1LWJhNzYtMmZiYmEyNmU1NjMzXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"
  },
  {
    title: "Gladiador",
    synopsis: "Um general romano é traído e sua família assassinada por um príncipe corrupto. Ele retorna como gladiador para buscar vingança.",
    year: 2000,
    duration: 155,
    director: "Ridley Scott",
    categories: [ "Ação", "Drama", "Histórico" ],
    tags: [ "oscar", "épico", "vintage" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BMDliMmNhNDEtODUyOS00MjNlLTgxODEtN2U3NzIxMGVkZTA1L2ltYWdlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg"
  },
  {
    title: "Clube da Luta",
    synopsis: "Um funcionário de escritório insone forma um clube de luta underground com um vendedor de sabão carismático.",
    year: 1999,
    duration: 139,
    director: "David Fincher",
    categories: [ "Drama", "Suspense" ],
    tags: [ "cult", "dark", "adaptação" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BNDIzNDU0YzEtYzE5Ni00ZjlkLTk5ZjgtNjM3NWE4YzA3Nzk3XkEyXkFqcGdeQXVyMjUzOTY0NTM@._V1_SX300.jpg"
  },
  {
    title: "Interestelar",
    synopsis: "Em um futuro próximo, um grupo de exploradores usa um buraco de minhoca para atravessar o espaço e tentar garantir a sobrevivência da humanidade.",
    year: 2014,
    duration: 169,
    director: "Christopher Nolan",
    categories: [ "Ficção Científica", "Drama" ],
    tags: [ "modern", "tech", "épico" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg"
  },
  {
    title: "O Senhor dos Anéis: A Sociedade do Anel",
    synopsis: "Um hobbit herda um anel mágico de seu tio e deve destruí-lo para salvar a Terra Média das forças do mal.",
    year: 2001,
    duration: 178,
    director: "Peter Jackson",
    categories: [ "Fantasia", "Aventura" ],
    tags: [ "épico", "baseado-em-livro", "oscar" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_SX300.jpg"
  },
  {
    title: "Coringa",
    synopsis: "Em Gotham City, Arthur Fleck, um comediante fracassado, se transforma no icônico vilão Coringa.",
    year: 2019,
    duration: 122,
    director: "Todd Phillips",
    categories: [ "Drama", "Crime", "Suspense" ],
    tags: [ "oscar", "dark", "modern" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BNGVjNWI4ZGUtNzE0MS00YTJmLWE0ZDctN2ZiYTk2YmI3NTYyXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SX300.jpg"
  },
  {
    title: "La La Land",
    synopsis: "Um pianista de jazz e uma aspirante a atriz se apaixonam em Los Angeles enquanto perseguem seus sonhos.",
    year: 2016,
    duration: 128,
    director: "Damien Chazelle",
    categories: [ "Musical", "Romance", "Drama" ],
    tags: [ "oscar", "modern", "musical" ],
    poster_url: "https://m.media-amazon.com/images/M/MV5BMzUzNDM2NzM2MV5BMl5BanBnXkFtZTgwNTM3NTg4OTE@._V1_SX300.jpg"
  }
]

movies_data.each_with_index do |movie_data, index|
  puts "📽️ Criando filme #{index + 1}/#{movies_data.length}: #{movie_data[:title]}"

  movie = Movie.find_or_create_by(title: movie_data[:title]) do |m|
    m.synopsis = movie_data[:synopsis]
    m.year = movie_data[:year]
    m.duration = movie_data[:duration]
    m.director = movie_data[:director]
    m.user = [ admin_user, demo_user ].sample
  end

  # Associar categorias
  movie_data[:categories].each do |category_name|
    category = Category.find_by(name: category_name)
    movie.categories << category if category && !movie.categories.include?(category)
  end

  # Associar tags
  movie_data[:tags].each do |tag_name|
    tag = Tag.find_by(name: tag_name)
    movie.tags << tag if tag && !movie.tags.include?(tag)
  end

  # Baixar e anexar poster do filme
  if movie_data[:poster_url].present? && !movie.poster.attached?
    puts "🖼️ Baixando poster para #{movie.title}..."
    if ai_service.download_and_attach_poster(movie, movie_data[:poster_url])
      puts "✅ Poster anexado com sucesso para #{movie.title}"
    else
      puts "❌ Erro ao baixar poster para #{movie.title}"
    end
  end
end

puts "✅ Filmes criados: #{Movie.count}"

# Criar comentários
puts "💬 Criando comentários..."
comments_data = [
  "Filme incrível! Um dos melhores que já vi!",
  "Excelente direção e atuações impecáveis.",
  "Uma obra-prima do cinema mundial.",
  "Recomendo para todos os amantes de cinema.",
  "História envolvente do início ao fim.",
  "Efeitos especiais impressionantes!",
  "Um clássico que nunca envelhece.",
  "Assisti várias vezes e ainda me emociono.",
  "Roteiro brilhante e bem executado.",
  "Filme que marca uma geração."
]

Movie.all.each do |movie|
  # Comentários autenticados
  rand(2..4).times do
    Comment.create!(
      movie: movie,
      user: [ admin_user, demo_user ].sample,
      content: comments_data.sample
    )
  end

  # Comentários anônimos
  rand(1..3).times do
    Comment.create!(
      movie: movie,
      commenter_name: [ "João Silva", "Maria Santos", "Pedro Oliveira", "Ana Costa" ].sample,
      content: comments_data.sample
    )
  end
end

puts "✅ Comentários criados: #{Comment.count}"

puts "\n🎉 Seeds executados com sucesso!"
puts "📊 Estatísticas finais:"
puts "   👤 Usuários: #{User.count}"
puts "   🎬 Filmes: #{Movie.count}"
puts "   🏷️ Categorias: #{Category.count}"
puts "   🏷️ Tags: #{Tag.count}"
puts "   💬 Comentários: #{Comment.count}"
puts "\n🔑 Credenciais de teste:"
puts "   📧 admin@netmovies.com / 123456"
puts "   📧 usuario@demo.com / 123456"
