//! ## DB defines
/**
 * DB major schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MAJOR_VERSION 1

/**
 * DB minor schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MINOR_VERSION 3

//* Misc *//

/// pass this into duplicate_key on mass_insert() to overwrite old values
#define DB_MASS_INSERT_DUPLICATE_KEY_AUTO_OVERWRITE -1337
