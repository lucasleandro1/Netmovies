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
- **Background Jobs:** Estrutura pronta para jobs assíncronos 
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

## 🤖 Configuração de APIs (Opcional)

Para integração com IA, adicione as chaves no .env:

**IAs:**
- Gemini: https://aistudio.google.com/api-keys
- TMDB: https://developer.themoviedb.org/docs/getting-started 

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
4. **Testes**
  - Execute:
    ```bash
    docker compose exec web rspec spec
    ```