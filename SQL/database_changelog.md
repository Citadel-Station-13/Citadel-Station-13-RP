# Changelog

This covers the **game** database. The unified database has no unified schema + changelog yet.

## Schema Versioning

Any time you make a change to the schema files, remember to increment the database schema version. Generally increment the minor number, major should be reserved for significant changes to the schema. Both values go up to 255.

The latest database version is 5.12; The query to update the schema revision table is:

INSERT INTO `schema_revision` (`major`, `minor`) VALUES (5, 12);
or
INSERT INTO `SS13_schema_revision` (`major`, `minor`) VALUES (5, 12);

In any query remember to add a prefix to the table names if you use one.

## Changelog

### 6/16/22 - 1.1 - silicons

Database migrated to DBCore. Schema will start at MAJOR 1, MINOR 1.

### 11/21/22 - 1.2 - silicons

persist_keyed_strings added.
