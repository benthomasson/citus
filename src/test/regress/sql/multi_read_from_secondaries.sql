ALTER SEQUENCE pg_catalog.pg_dist_shardid_seq RESTART 1600000;

SET citus.use_secondary_nodes TO 'always';

CREATE TABLE the_table (a int, b int);

-- attempts to change metadata should fail while reading from secondaries
SELECT create_distributed_table('the_table', 'a');

SET citus.use_secondary_nodes TO 'never';
SELECT create_distributed_table('the_table', 'a');

INSERT INTO the_table (a, b) VALUES (1, 1);
INSERT INTO the_table (a, b) VALUES (2, 1);

SET citus.use_secondary_nodes TO 'always';

-- inserts are disallowed
INSERT INTO the_table (a, b) VALUES (1, 2);

-- router selects are allowed
SELECT a FROM the_table WHERE a = 1;

-- real-time selects are not allowed
SELECT a FROM the_table;

SET citus.use_secondary_nodes TO 'never';
DROP TABLE the_table;
