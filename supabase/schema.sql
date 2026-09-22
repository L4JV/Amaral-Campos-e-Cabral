-- =========================================================
-- Amaral, Campos e Cabral Advocacia — banco de dados do blog
-- Rode este arquivo inteiro em: Supabase > SQL Editor > New query > Run
-- =========================================================

create extension if not exists pgcrypto;

-- ---------------------------------------------------------
-- Tabela principal: posts do blog
-- ---------------------------------------------------------
create table if not exists public.posts (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,        -- usado na URL: blog-artigo.html?post=slug
  title         text not null,
  category      text not null,               -- 'Famílias' | 'Sucessões' | 'Patrimonial' | 'Civil' | 'Saúde'
  excerpt       text not null,                -- resumo curto (aparece nos cards)
  body_html     text not null default '',     -- corpo do artigo
  read_minutes  int  not null default 5,
  author        text not null default 'Amaral, Campos e Cabral Advocacia',
  is_featured   boolean not null default false,
  is_published  boolean not null default false,
  published_at  timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists posts_published_idx
  on public.posts (is_published, published_at desc);

-- ---------------------------------------------------------
-- Mantém updated_at / published_at em dia automaticamente
-- ---------------------------------------------------------
create or replace function public.posts_set_meta()
returns trigger as $$
begin
  new.updated_at = now();
  if new.is_published = true
     and (tg_op = 'INSERT' or (old.is_published is distinct from true)) then
    new.published_at = coalesce(new.published_at, now());
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists posts_set_meta_trigger on public.posts;
create trigger posts_set_meta_trigger
before insert or update on public.posts
for each row execute function public.posts_set_meta();

-- ---------------------------------------------------------
-- Segurança (RLS): visitantes só leem posts publicados;
-- só quem faz login no painel pode criar/editar/apagar.
-- ---------------------------------------------------------
alter table public.posts enable row level security;

drop policy if exists "Leitura pública de posts publicados" on public.posts;
create policy "Leitura pública de posts publicados"
  on public.posts for select
  using (is_published = true);

drop policy if exists "Administradores logados fazem tudo" on public.posts;
create policy "Administradores logados fazem tudo"
  on public.posts for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- ---------------------------------------------------------
-- Dados iniciais: migra o conteúdo que já existia no site
-- (o artigo real fica publicado; os 4 exemplos ficam como
-- rascunho, prontos para o escritório completar e publicar)
-- ---------------------------------------------------------
insert into public.posts (slug, title, category, excerpt, body_html, read_minutes, is_featured, is_published, published_at)
values (
  'inventario-extrajudicial',
  'Inventário extrajudicial: quando é possível evitar o processo na Justiça',
  'Sucessões',
  'Entenda os requisitos para fazer o inventário em cartório e economizar tempo e desgaste para a família.',
  '<p>Quando alguém falece, os bens deixados precisam passar por um processo de inventário antes de serem transferidos aos herdeiros. Muita gente ainda acredita que esse caminho passa obrigatoriamente por um juiz — mas, em boa parte dos casos, é possível resolver tudo em um cartório, de forma mais rápida e menos desgastante.</p>
<h2>O que é o inventário extrajudicial</h2>
<p>O inventário extrajudicial é feito por escritura pública, diretamente em um Tabelionato de Notas, sem a necessidade de abrir um processo judicial. Ele existe desde 2007 e, desde então, tem se tornado o caminho mais comum para famílias que reúnem certas condições.</p>
<h2>Quando é possível usar esse caminho</h2>
<p>Três requisitos precisam estar presentes ao mesmo tempo:</p>
<ul><li>Todos os herdeiros são maiores de idade e plenamente capazes;</li><li>Há consenso entre todos sobre a partilha dos bens;</li><li>Não existe testamento deixado pela pessoa falecida.</li></ul>
<p>Se qualquer um desses pontos não se aplicar ao seu caso — por exemplo, se houver um herdeiro menor de idade ou um testamento — o inventário precisará ser judicial, ainda que exista consenso entre as partes.</p>
<blockquote>A via extrajudicial não é apenas mais rápida: costuma reduzir o desgaste emocional de um processo judicial em um momento já difícil para a família.</blockquote>
<h2>Vantagens do inventário em cartório</h2>
<p>Além da agilidade, o processo em cartório tende a ter um custo total menor, já que dispensa honorários mais longos de acompanhamento processual. A escritura pública já é, por si só, um documento hábil para transferência de imóveis e outros bens, sem depender de homologação judicial posterior.</p>
<h2>O papel do advogado no processo</h2>
<p>Mesmo sendo extrajudicial, a lei exige a presença de um advogado para orientar a lavratura da escritura. Esse acompanhamento é importante para conferir se a partilha proposta é justa, se os documentos estão corretos e se não há riscos de contestação futura por parte de terceiros ou de herdeiros que venham a se manifestar depois.</p>
<h2>Próximos passos</h2>
<p>Se a sua família está diante de um inventário e não tem certeza sobre qual caminho seguir, o primeiro passo é reunir a documentação do falecido e dos herdeiros e buscar orientação jurídica antes de tomar qualquer decisão — inclusive sobre bens que possam ser vendidos ou usados durante o processo.</p>',
  8, true, true, now()
)
on conflict (slug) do nothing;

insert into public.posts (slug, title, category, excerpt, body_html, read_minutes, is_published)
values
(
  'guarda-compartilhada',
  'Guarda compartilhada: o que muda na rotina dos filhos e dos pais',
  'Famílias',
  'Um guia sobre como funciona a guarda compartilhada na prática, além do que diz a lei.',
  '<p>Rascunho — complete o conteúdo deste artigo no painel de administração antes de publicar.</p>',
  6, false
),
(
  'holding-familiar',
  'Holding familiar: para quem faz sentido e quando ainda é cedo',
  'Patrimonial',
  'Nem toda família precisa de uma holding. Veja os sinais de que é hora de considerar essa estrutura.',
  '<p>Rascunho — complete o conteúdo deste artigo no painel de administração antes de publicar.</p>',
  7, false
),
(
  'plano-de-saude-negou-tratamento',
  'Plano de saúde negou o tratamento: o que fazer nas primeiras 48 horas',
  'Saúde',
  'Passo a passo prático para reverter uma negativa de cobertura sem perder tempo precioso.',
  '<p>Rascunho — complete o conteúdo deste artigo no painel de administração antes de publicar.</p>',
  5, false
),
(
  'uniao-estavel-como-formalizar',
  'União estável: como formalizar (e por que isso protege os dois lados)',
  'Famílias',
  'Os documentos e cuidados essenciais para registrar uma união estável com segurança jurídica.',
  '<p>Rascunho — complete o conteúdo deste artigo no painel de administração antes de publicar.</p>',
  6, false
)
on conflict (slug) do nothing;
