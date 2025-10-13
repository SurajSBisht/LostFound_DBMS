-- ========================
-- FOUNDITEM TABLE DATA
-- ========================
INSERT INTO founditem (user_id, item_name, category, description, location_found, date_found, status)
VALUES (3, 'Wallet', 'Wallet', 'Brown wallet with few ID cards', 'Library Entrance', TO_DATE('2025-10-03', 'YYYY-MM-DD'), 'unclaimed');

INSERT INTO founditem (user_id, item_name, category, description, location_found, date_found, status)
VALUES (2, 'Phone', 'Phone', 'Black phone with crack on top right', 'Cafeteria Table', TO_DATE('2025-10-03', 'YYYY-MM-DD'), 'unclaimed');

COMMIT;
