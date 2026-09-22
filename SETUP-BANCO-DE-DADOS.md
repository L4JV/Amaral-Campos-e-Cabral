# Banco de dados do blog — guia de configuração

O blog agora é alimentado por um banco de dados (Supabase, que por baixo é
PostgreSQL — SQL de verdade). Isso significa que qualquer pessoa do
escritório pode publicar ou editar posts pelo painel `admin.html`, sem
precisar mexer em código. Funciona com qualquer hospedagem, porque o site
continua sendo só arquivos estáticos — quem faz o trabalho pesado é o
Supabase.

Leva uns 10 minutos para configurar, uma única vez.

## 1. Criar a conta e o projeto

1. Acesse **supabase.com** e crie uma conta gratuita.
2. Clique em **New project**.
3. Dê um nome (ex: `amaral-campos-cabral`), escolha uma região perto do
   Brasil (ex: São Paulo) e defina uma senha do banco — guarde essa senha
   em local seguro, mas ela não será usada no dia a dia.
4. Aguarde ~2 minutos enquanto o projeto é criado.

## 2. Criar as tabelas do banco

1. No menu lateral, abra **SQL Editor**.
2. Clique em **New query**.
3. Abra o arquivo `supabase/schema.sql` (está junto com os arquivos do
   site), copie todo o conteúdo e cole no editor.
4. Clique em **Run**.

Isso cria a tabela de posts, as regras de segurança (visitantes só veem
posts publicados; só quem faz login pode editar) e já cadastra o artigo
que já existia no site, mais 4 rascunhos prontos para completar.

## 3. Criar o login de quem vai administrar o blog

1. No menu lateral, abra **Authentication → Users**.
2. Clique em **Add user → Create new user**.
3. Preencha o e-mail e uma senha para a pessoa do escritório que vai
   publicar os posts. Marque a opção de já confirmar o e-mail
   automaticamente (**Auto Confirm User**).
4. Esse e-mail e senha são o login do painel `admin.html`. Dá para criar
   mais de um usuário aqui, se mais de uma pessoa for mexer no blog.

## 4. Conectar o site ao banco

1. No menu lateral, abra **Project Settings → API**.
2. Copie o valor de **Project URL**.
3. Copie o valor de **anon public** (a chave pública — não a `service_role`,
   essa nunca deve ser usada no site).
4. Abra o arquivo `js/supabase-client.js` nos arquivos do site e troque:
   ```js
   const SUPABASE_URL = "COLOQUE_AQUI_A_URL_DO_SEU_PROJETO";
   const SUPABASE_ANON_KEY = "COLOQUE_AQUI_A_CHAVE_ANON_PUBLICA";
   ```
   pelos valores copiados.

A chave "anon" é feita para ficar visível no código do site — não tem
problema nenhum nisso. A proteção de verdade quem faz são as regras de
acesso (RLS) criadas no passo 2: sem estar logado, ninguém consegue
criar, editar ou apagar posts, só ler os que estão publicados.

## 5. Publicar o site e usar o painel

1. Suba os arquivos do site (agora incluindo `admin.html`,
   `js/supabase-client.js` etc.) para onde for hospedar — qualquer
   hospedagem de arquivos estáticos funciona.
2. Acesse `seusite.com.br/admin.html` e entre com o e-mail e senha
   criados no passo 3.
3. Pronto — dá para criar, editar, marcar como destaque e publicar posts
   direto por ali. O `blog.html` e as páginas de artigo já buscam tudo
   automaticamente do banco.

## Observações

- **`admin.html` não tem link em nenhum menu do site** — é intencional,
  para não aparecer para visitantes. Só quem tiver o endereço consegue
  abrir a tela de login (e, mesmo assim, precisa da senha para fazer
  qualquer alteração).
- O campo **"corpo do artigo"** no painel é um editor simples (negrito,
  itálico, títulos, listas, citação, links) — parecido com o Word, sem
  precisar saber HTML.
- Áreas de atuação, a equipe e as outras páginas continuam no código do
  site por enquanto — mudam raramente, então não valia a pena colocar no
  banco agora. Se um dia isso mudar, é só pedir.
