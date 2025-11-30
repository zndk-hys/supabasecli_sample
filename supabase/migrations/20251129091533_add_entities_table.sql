-- function
CREATE FUNCTION update_updated_at()
RETURNS TRIGGER SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- enum
CREATE TYPE entity_status_enum
AS ENUM ('planned', 'in_progress', 'completed', 'is_archived');


-- table
CREATE TABLE entities (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id   uuid NOT NULL REFERENCES auth.users (id),
  title      text NOT NULL,
  url        text NOT NULL,
  memo       text NOT NULL,
  status     entity_status_enum NOT NULL DEFAULT 'planned',
	
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- rls
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "entities_select_rls" ON entities
FOR SELECT
USING (true);

CREATE POLICY "entities_insert_rls" ON entities FOR INSERT TO authenticated WITH CHECK (owner_id = (SELECT auth.uid()));
CREATE POLICY "entities_update_rls" ON entities FOR UPDATE TO authenticated USING (owner_id = (SELECT auth.uid())) WITH CHECK (owner_id = (SELECT auth.uid()));
CREATE POLICY "entities_delete_rls" ON entities FOR DELETE TO authenticated USING (owner_id = (SELECT auth.uid()));


-- trigger
CREATE TRIGGER update_entities_updated_at
BEFORE UPDATE ON entities
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();