-- ========================
-- LOSTITEM TABLE DATA
-- ========================
INSERT INTO lostitem (user_id, item_name, category, description, location_lost, date_lost, status)
VALUES (1, 'Red Wallet', 'Wallet', 'Leather wallet with ID cards', 'Library', TO_DATE('2025-10-01', 'YYYY-MM-DD'), 'unfound');

INSERT INTO lostitem (user_id, item_name, category, description, location_lost, date_lost, status)
VALUES (2, 'Samsung Phone', 'Phone', 'Black phone with cracked screen', 'Cafeteria', TO_DATE('2025-10-02', 'YYYY-MM-DD'), 'unfound');

COMMIT;
