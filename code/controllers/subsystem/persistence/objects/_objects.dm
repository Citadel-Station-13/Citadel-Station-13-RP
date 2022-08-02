/**
 * ! Persistent Object Storage
 *
 * ? SQL is required. Savefiles are too unperformant for us to do generic object storage.
 *
 * This folder contains most generic non-feature-specific storages
 *
 * If you want to do something regarding either
 * 1. persisting a lot of map objects
 * 2. persisting map objects generically
 * 3. persisting runtime objects generically and specifically
 * 4. persisting strings generically
 *
 * You have come to the right folder
 *
 * For more general server things like panic bunker, gamemodes, paintings, photos, etc,
 * please make new files for the code for them. Don't overload the object system with snowflake,
 * it's optimized specifically for these 4 use cases
 *
 * Yes, you can add more use cases, if you know what you're doing.
 * Considering I don't, you probably don't either.
 */

/**
 * Checks if the object storage module is online
 */
/datum/controller/subsystem/persistence/proc/ObjectStoreEnabled()
	return SSdbcore.Connect()
