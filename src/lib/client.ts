import { createClient } from "@supabase/supabase-js";
import type { Database } from '../../supabase/types/supabase.types';

export default function createSupabaseClient() {
  return createClient<Database>(
    'http://127.0.0.1:54321',
    'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
  );
}