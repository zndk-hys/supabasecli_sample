-- table
CREATE TABLE entities (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id   uuid NOT NULL REFERENCES auth.users (id),
  title      text NOT NULL,
  url        text NOT NULL,
  memo       text NOT NULL,
  status     text NOT NULL DEFAULT 'planned',
	
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- rls
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "entities_select_rls" ON entities
FOR SELECT
USING (true);

CREATE POLICY "entities_all_rls" ON entities FOR ALL TO authenticated
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());