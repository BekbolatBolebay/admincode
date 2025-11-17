import { createBrowserClient } from "@supabase/ssr"

export function createClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || ""
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ""

  console.log("[v0] Client - Supabase URL exists:", !!supabaseUrl)
  console.log("[v0] Client - Supabase Key exists:", !!supabaseAnonKey)

  return createBrowserClient(supabaseUrl, supabaseAnonKey)
}
