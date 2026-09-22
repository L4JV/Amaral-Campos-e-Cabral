// =========================================================
// Amaral, Campos e Cabral Advocacia — conexão com o banco


const SUPABASE_URL = "https://dndtctfsqbaqdobnmndy.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRuZHRjdGZzcWJhcWRvYm5tbmR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAwMDg1NTcsImV4cCI6MjEwNTU4NDU1N30.xkn2lzRT1PFVr8FuJKSS-ZTyjiDytU5qNPuzhDK0Y2k"
window.supabaseClient = (SUPABASE_URL.startsWith("http"))
  ? window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
  : null;

if (!window.supabaseClient) {
}
