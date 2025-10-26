# 🎬 Netmovies - Catálogo de Filmes

Netmovies é uma aplicação Ruby on Rails completa para gerenciamento de catálogo de filmes, desenvolvida como projeto de portfólio seguindo as melhores práticas do mercado.

## 🚀 Funcionalidades

### ✅ Área Pública (sem login)
- [x] Listagem de filmes ordenados do mais novo ao mais antigo
- [x] Paginação (6 filmes por página)
- [x] Visualização detalhada de filmes (título, sinopse, ano, duração, diretor)
- [x] Sistema de comentários anônimos
- [x] Comentários ordenados do mais recente ao mais antigo
- [x] Cadastro de usuários e recuperação de senha

### ✅ Área Autenticada (com login)
- [x] Logout e gerenciamento de perfil
- [x] CRUD completo de filmes (criar, editar, excluir próprios filmes)
- [x] Comentários autenticados automáticos
- [x] Edição de perfil e alteração de senha
- [x] Sistema de categorias (relacionamento muitos-para-muitos)
- [x] Sistema de tags para filmes
- [x] Busca avançada por título, diretor e/ou ano
- [x] Filtros por categoria, ano e diretor
- [x] Upload de pôster com Active Storage
- [x] Internacionalização (Português e Inglês)

### 🔧 Funcionalidades Técnicas
- [x] Testes automatizados com RSpec
- [x] Importação em massa via CSV (estrutura implementada)
- [x] Integração preparada para IA (estrutura criada)
- [x] Deploy configurado para Render

## 🛠️ Stack Tecnológica

- **Backend:** Ruby on Rails 8.0.3
- **Banco de Dados:** PostgreSQL
- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5
- **Autenticação:** Devise
- **Upload de Arquivos:** Active Storage
- **Paginação:** Kaminari
- **Background Jobs:** Estrutura pronta para jobs assíncronos (sem Sidekiq por enquanto)
- **Testes:** RSpec + FactoryBot + Faker
- **Internacionalização:** Rails I18n
- **Deploy:** Render (configurado)

## 📋 Pré-requisitos

- Ruby 3.4.4 ou superior
- Rails 8.0.3 ou superior
- PostgreSQL 12 ou superior

## 🔧 Instalação e Configuração

### 1. Clone o repositório
```bash
git clone https://github.com/lucasleandro1/netmovies.git
cd netmovies
```

### 2. Instale as dependências
```bash
bundle install
```

### 3. Configure o banco de dados
```bash
# Configure as credenciais no arquivo .env ou diretamente no database.yml
export DATABASE_USERNAME=postgres
export DATABASE_PASSWORD=postgres
export DATABASE_HOST=localhost

# Crie e configure o banco
rails db:create
rails db:migrate
rails db:seed
```

### 4. Configure o Active Storage
```bash
# As tabelas já foram criadas na migração
# Configure o storage local ou cloud conforme necessário
```

### 5. Inicie o servidor
```bash
rails server
```

A aplicação estará disponível em `http://localhost:3000`

## 👤 Credenciais de Teste

O arquivo `db/seeds.rb` cria usuários de exemplo:

- **Admin:** admin@netmovies.com / 123456
- **Usuário Demo:** usuario@demo.com / 123456

## 📊 Estrutura do Banco de Dados

### Modelos Principais

- **User** - Usuários do sistema (Devise)
- **Movie** - Filmes do catálogo
- **Comment** - Comentários nos filmes
- **Category** - Categorias de filmes
- **Tag** - Tags dos filmes
- **MovieImport** - Importações em massa (CSV)

### Relacionamentos

```ruby
User
├── has_many :movies
├── has_many :comments
└── has_many :movie_imports

Movie
├── belongs_to :user
├── has_many :comments
├── has_and_belongs_to_many :categories
├── has_and_belongs_to_many :tags
└── has_one_attached :poster

Comment
├── belongs_to :movie
└── belongs_to :user (optional)

Category
└── has_and_belongs_to_many :movies

Tag
└── has_and_belongs_to_many :movies
```

## 🧪 Executando os Testes

```bash
# Configurar banco de teste
rails db:test:prepare

# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
```

## 📤 Importação CSV

### Formato do Arquivo CSV

O arquivo deve conter as seguintes colunas (cabeçalho obrigatório):

```csv
title,synopsis,year,duration,director,categories,tags
Matrix,"Um programador descobre a realidade...",1999,136,"Lana Wachowski","Ação|Ficção Científica","sci-fi|cult"
Pulp Fiction,"Histórias entrelaçadas de crime...",1994,154,"Quentin Tarantino","Crime|Drama","cult|indie"
```

### Regras de Importação

- Campos obrigatórios: `title`, `year`, `director`
- Use `|` (pipe) para separar múltiplas categorias ou tags
- Campos com vírgulas devem estar entre aspas
- Codificação: UTF-8
- Máximo: 1000 filmes por importação

### Executando Importação

1. Acesse "Importações de Filmes" no menu
2. Clique em "Nova Importação"
3. Preencha a descrição e faça upload do CSV
4. Acompanhe o status na lista de importações

## 🔄 Sidekiq (Background Jobs)

## 🔄 Background Jobs

O projeto possui estrutura pronta para jobs assíncronos, mas **Sidekiq não está ativo por enquanto**. Quando for ativado, será possível processar importações CSV e outras tarefas em segundo plano.

## 📧 Configuração de E-mail (Opcional)

Para notificações de importação, configure o Action Mailer no `config/environments/production.rb` conforme exemplo abaixo:

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: Rails.application.credentials.email_username,
  password: Rails.application.credentials.email_password,
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## 🤖 Configuração de APIs (Opcional)

Para integração com IA, adicione as chaves no Rails credentials:

```bash
# Editar credentials
rails credentials:edit

# Adicionar:
openai_api_key: sua_chave_openai
omdb_api_key: sua_chave_omdb

# Ou via variáveis de ambiente:
export OPENAI_API_KEY=sua_chave
export OMDB_API_KEY=sua_chave
```

**Obtendo as chaves:**
- OpenAI: https://platform.openai.com/api-keys
- OMDB: http://www.omdbapi.com/apikey.aspx (gratuita)

## 🤖 Funcionalidades de IA

A integração com IA oferece duas funcionalidades principais:

### 📝 **Preenchimento Automático**
1. Digite o título do filme no campo IA
2. Clique em "Preencher Formulário"
3. Todos os campos são preenchidos automaticamente
4. Revise e edite conforme necessário
5. Salve o filme

### ⚡ **Criação Automática**
1. Digite o título do filme no campo IA
2. Clique em "Criar Automaticamente"
3. O filme é criado instantaneamente com:
   - Todos os dados (título, sinopse, ano, diretor, duração)
   - Categorias e tags apropriadas
   - **Pôster baixado e anexado automaticamente** 🖼️
4. Redirecionamento automático para o filme criado

**Fontes de dados:**
- Primário: OpenAI/ChatGPT (se configurado)
- Fallback: OMDB API (sempre disponível com chave gratuita)
```

## 🌍 Internacionalização

A aplicação suporta:

- **Português (pt)** - Idioma padrão
- **Inglês (en)**

### Trocar idioma

- Use os links no canto superior direito da navegação
- Ou acesse diretamente: `/?locale=en` ou `/?locale=pt`

### Adicionar novas traduções

Edite os arquivos:
- `config/locales/pt.yml`
- `config/locales/en.yml`

## 🚀 Deploy no Render

### 1. Prepare a aplicação

```bash
# Render usa PostgreSQL por padrão
# Configure as variáveis de ambiente
```

### 2. Configure as variáveis de ambiente

No dashboard do Render, configure:

```
DATABASE_URL=postgresql://...
RAILS_MASTER_KEY=sua_master_key
RAILS_ENV=production
```

### 3. Build Command

```bash
bundle install && rails assets:precompile && rails db:migrate
```

### 4. Start Command

```bash
rails server
```

### 5. Primeiro deploy

```bash
git push origin main
# Render fará o deploy automaticamente
```

## 📁 Estrutura de Arquivos

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── movies_controller.rb
│   ├── comments_controller.rb
│   ├── categories_controller.rb
│   └── movie_imports_controller.rb
├── models/
│   ├── user.rb
│   ├── movie.rb
│   ├── comment.rb
│   ├── category.rb
│   ├── tag.rb
│   └── movie_import.rb
├── views/
│   ├── layouts/
│   ├── movies/
│   ├── categories/
│   ├── movie_imports/
│   └── devise/
└── jobs/ (para Sidekiq)

config/
├── locales/
│   ├── pt.yml
│   └── en.yml
├── database.yml
└── routes.rb

spec/ (testes)
```

## 🔮 Próximas Funcionalidades

### 💎 Super Diferencial 1 - Sidekiq Avançado
- [x] Processamento assíncrono completo de CSV
- [x] Job de importação com MovieImportJob
- [x] Notificações por e-mail pós-importação
- [x] Sistema de status (pending/processing/completed/failed)
- [ ] Interface web do Sidekiq integrada
- [ ] Retry automático para jobs falhados

### 💎 Super Diferencial 2 - Integração com IA
- [x] Estrutura de integração com OpenAI/ChatGPT API
- [x] Preenchimento automático via OMDB API (fallback)
- [x] Interface JavaScript para busca automática
- [x] **Download automático de pôster do filme** 🖼️
- [x] **Criação de filme completa em um clique** ⚡
- [x] Tratamento de erros da integração
- [ ] Sugestões inteligentes de categorias
- [ ] Análise de sentiment em comentários

### 🚀 Melhorias Futuras
- [ ] API REST completa
- [ ] Avaliações por estrelas
- [ ] Sistema de favoritos
- [ ] Recomendações personalizadas
- [ ] Notificações em tempo real
- [ ] PWA (Progressive Web App)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE.md](LICENSE.md) para detalhes.

## 👨‍💻 Autor

**Lucas Leandro**

- GitHub: [@lucasleandro1](https://github.com/lucasleandro1)
- LinkedIn: [lucas-leandro](https://linkedin.com/in/lucas-leandro)
- Email: contato@lucasleandro.dev

---

⭐ Se este projeto te ajudou, não esqueça de dar uma estrela!

🎬 **Netmovies** - Seu catálogo de filmes profissional

---

## 🐳 Docker

Este projeto já possui um `Dockerfile` pronto para produção.

### Como usar:

1. **Build da imagem:**
  ```bash
  docker build -t netmovies .
  ```

2. **Rodar o container:**
  ```bash
  docker run -d -p 80:80 --name netmovies netmovies
  ```

  - O app estará disponível em `http://localhost`.

3. **Banco de dados:**
  - Recomenda-se usar um container PostgreSQL separado e configurar a variável `DATABASE_URL`.

4. **Para desenvolvimento:**
  - Recomenda-se usar ambiente local ou Dev Containers. O Dockerfile é focado em produção.

---

## 🐳 Docker Compose

Para facilitar o deploy local, utilize o arquivo `docker-compose.yml` já incluso:

1. **Suba os containers:**
  ```bash
  docker-compose up --build
  ```

2. **Acesse a aplicação:**
  - O app estará disponível em `http://localhost`.
  - O banco de dados estará disponível em `localhost:5432` (usuário e senha: postgres).

3. **Primeiro uso:**
  - Execute as migrações e seeds dentro do container web:
    ```bash
    docker-compose exec web rails db:create db:migrate db:seed
    ```

---

---
