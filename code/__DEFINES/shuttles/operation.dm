//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* - Returned via callback - *//

/**
 * Still running.
 */
#define SHUTTLE_OPERATION_STATUS_RUNNING 0
/**
 * Operation completed successfully.
 */
#define SHUTTLE_OPERATION_STATUS_SUCCESS 1
/**
 * Returned if the operation is considered failed.
 */
#define SHUTTLE_OPERATION_STATUS_FAILURE 2
/**
 * Returned if an operation is cancelled by the player or
 * by something else.
 */
#define SHUTTLE_OPERATION_STATUS_CANCELLED 3
/**
 * Returned if a function that allows an operation ID discovers that operation is
 * no longer active.
 */
#define SHUTTLE_OPERATION_STATUS_EXPIRED 4
