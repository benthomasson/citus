
CREATE TABLE artists (
    id bigint NOT NULL,
    name text NOT NULL
);
SELECT create_distributed_table('artists', 'id');

-- add some data
INSERT INTO artists VALUES (1, 'Pablo Picasso');
INSERT INTO artists VALUES (2, 'Vincent van Gogh');
INSERT INTO artists VALUES (3, 'Claude Monet');
INSERT INTO artists VALUES (4, 'William Kurelek');

-- RELEASE SAVEPOINT
BEGIN;
INSERT INTO artists VALUES (5, 'Asher Lev');
SAVEPOINT s1;
DELETE FROM artists WHERE id=5;
RELEASE SAVEPOINT s1;
COMMIT;

SELECT * FROM artists WHERE id=5;

-- ROLLBACK TO SAVEPOINT
BEGIN;
INSERT INTO artists VALUES (5, 'Asher Lev');
SAVEPOINT s1;
DELETE FROM artists WHERE id=5;
ROLLBACK TO SAVEPOINT s1;
COMMIT;

SELECT * FROM artists WHERE id=5;

-- Serial sub-transaction releases
BEGIN;
SAVEPOINT s1;
DELETE FROM artists WHERE id=5;
RELEASE SAVEPOINT s1;
SAVEPOINT s2;
INSERT INTO artists VALUES (5, 'Jacob Kahn');
RELEASE SAVEPOINT s2;
COMMIT;

SELECT * FROM artists WHERE id=5;

-- Serial sub-transaction rollbacks
BEGIN;
SAVEPOINT s1;
UPDATE artists SET name='A' WHERE id=5;
ROLLBACK TO SAVEPOINT s1;
SAVEPOINT s2;
DELETE FROM artists WHERE id=5;
ROLLBACK TO SAVEPOINT s2;
COMMIT;

SELECT * FROM artists WHERE id=5;