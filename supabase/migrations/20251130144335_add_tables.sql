CREATE TABLE categories (
  id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug      text NOT NULL,
  name      text NOT NULL,
  parent_id uuid REFERENCES categories (id),
	
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE entity_categories (
  entity_id   uuid REFERENCES entities (id),
  category_id uuid REFERENCES categories (id),
  
  PRIMARY KEY (entity_id, category_id)
);

-- categories
-- SELECTは全員許可、INSERT/UPDATE/DELETEはとりあえず全員拒否
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "categories_select_rls" ON categories FOR SELECT USING (true);

-- entity_categories
-- SELECTは全員許可、INSERT/UPDATE/DELETEは本人のみ許可。entitiesのowner_idを参照する。
ALTER TABLE entity_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "entity_categories_select_rls" ON entity_categories FOR SELECT USING (true);
CREATE POLICY "entity_categories_insert_rls" ON entity_categories FOR INSERT TO authenticated
	WITH CHECK ( EXISTS ( SELECT 1 FROM entities WHERE entities.id = entity_categories.entity_id AND entities.owner_id = (SELECT auth.uid()) ) )
;
CREATE POLICY "entity_categories_update_rls" ON entity_categories FOR UPDATE TO authenticated
	USING ( EXISTS ( SELECT 1 FROM entities WHERE entities.id = entity_categories.entity_id AND entities.owner_id = (SELECT auth.uid()) ) )
	WITH CHECK ( EXISTS ( SELECT 1 FROM entities WHERE entities.id = entity_categories.entity_id AND entities.owner_id = (SELECT auth.uid()) ) )
;
CREATE POLICY "entity_categories_delete_rls" ON entity_categories FOR DELETE TO authenticated
	USING ( EXISTS ( SELECT 1 FROM entities WHERE entities.id = entity_categories.entity_id AND entities.owner_id = (SELECT auth.uid()) ) )
;