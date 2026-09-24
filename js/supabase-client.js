// =========================================================
// Amaral, Campos e Cabral Advocacia — conexão com o banco
//
// Troque os dois valores abaixo pelos do SEU projeto Supabase:
// Project Settings (ícone de engrenagem) > API
//   SUPABASE_URL      = "Project URL"
//   SUPABASE_ANON_KEY = "anon public" (a chave pública, NÃO a service_role)
//
// A chave "anon" é feita para ficar visível no site — a proteção
// real dos dados está nas regras de acesso (RLS) do banco, não em
// esconder essa chave. Veja o arquivo supabase/schema.sql.
// =========================================================

const SUPABASE_URL = "https://dndtctfsqbaqdobnmndy.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRuZHRjdGZzcWJhcWRvYm5tbmR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAwMDg1NTcsImV4cCI6MjEwNTU4NDU1N30.xkn2lzRT1PFVr8FuJKSS-ZTyjiDytU5qNPuzhDK0Y2k";

const supabaseClient = (SUPABASE_URL.startsWith("http"))
  ? window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
  : null;

if (!supabaseClient) {
  console.warn(
    "Supabase ainda não configurado: edite js/supabase-client.js com a URL e a chave do seu projeto."
  );
}
