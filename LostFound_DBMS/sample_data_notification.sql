-- ========================
-- NOTIFICATION TABLE DATA
-- ========================
INSERT INTO notification (user_id, message, created_at)
VALUES (1, 'A wallet similar to yours has been found. Match ID: 1', SYSDATE);

INSERT INTO notification (user_id, message, created_at)
VALUES (2, 'A phone similar to yours has been found. Match ID: 2', SYSDATE);

COMMIT;
