//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* docking callback status

/// succeeded
#define SHUTTLE_DOCKING_STATUS_SUCCESS 1
/// cancelled; starting the opposite docking cycle counts as this.
#define SHUTTLE_DOCKING_STATUS_ABORTED 2
/// failed
#define SHUTTLE_DOCKING_STATUS_FAILED 3
/// timed out
#define SHUTTLE_DOCKING_STATUS_TIMEOUT 4
/// the op has already passed!
#define SHUTTLE_DOCKING_STATUS_EXPIRED 5
/// we're not at somewhere that we can dock to
#define SHUTTLE_DOCKING_STATUS_INVALID 6

//* docking states

#define SHUTTLE_DOCKING_STATE_UNKNOWN 1
#define SHUTTLE_DOCKING_STATE_DOCKED 2
#define SHUTTLE_DOCKING_STATE_UNDOCKED 3
#define SHUTTLE_DOCKING_STATE_DOCKING 4
#define SHUTTLE_DOCKING_STATE_UNDOCKING 5

//* transit callback status

/// at destination
#define SHUTTLE_TRANSIT_STATUS_SUCCESS 1
/// aborted; destination was blocked on arrival
#define SHUTTLE_TRANSIT_STATUS_BLOCKED 2
/// aborted ; we got cancelled
#define SHUTTLE_TRANSIT_STATUS_CANCELLED 3
/// aborted ; we're going somewhere else
#define SHUTTLE_TRANSIT_STATUS_REDIRECTED 4
/// aborted ; unknown abort
#define SHUTTLE_TRANSIT_STATUS_FAILED 5

//* transit stages

/// undocking
#define SHUTTLE_TRANSIT_STAGE_UNDOCK 1
/// taking off
#define SHUTTLE_TRANSIT_STAGE_TAKEOFF 2
/// in transit
#define SHUTTLE_TRANSIT_STAGE_FLIGHT 3
/// landing
#define SHUTTLE_TRANSIT_STAGE_LANDING 4
/// docking
#define SHUTTLE_TRANSIT_STAGE_DOCK 5

#warn DEFINE_ENUM

//* transit flags

/// should not interrupt
///
/// * without FORCE_UNDOCK / DOCK / TAKEOFF / LANDING, the transit can still be aborted by a timeout.
#define SHUTTLE_TRANSIT_FLAG_NO_ABORT (1<<0)
/// do not allow users to abort mid-transit
#define SHUTTLE_TRANSIT_FLAG_NO_TRANSIT_ABORT (1<<1)
/// do not allow interruption from undock
#define SHUTTLE_TRANSIT_FLAG_FORCE_UNDOCK (1<<2)
/// do not allow interruption from dock
#define SHUTTLE_TRANSIT_FLAG_FORCE_DOCK (1<<3)
/// suppress negative effects from undock
///
/// * useful with FORCE_UNDOCK, as otherwise bad things might happen to occupants.
#define SHUTTLE_TRANSIT_FLAG_SAFE_UNDOCK (1<<4)
/// suppress negative effects from dock
///
/// * useful with FORCE_DOCK, as otherwise bad things might happen to occupants.
#define SHUTTLE_TRANSIT_FLAG_SAFE_DOCK (1<<5)
/// do not allow interruption from takeoff
#define SHUTTLE_TRANSIT_FLAG_FORCE_TAKEOFF (1<<6)
/// do not allow interruption from landing
#define SHUTTLE_TRANSIT_FLAG_FORCE_LANDING (1<<7)
/// suppress negative effects from takeoff
///
/// * useful with FORCE_TAKEOFF, as otherwise really bad things might happen to occupants.
#define SHUTTLE_TRANSIT_FLAG_SAFE_TAKEOFF (1<<8)
/// suppress negative effects from landing
///
/// * useful with FORCE_LANDING, as otherwise really bad things might happen to occupants.
#define SHUTTLE_TRANSIT_FLAG_SAFE_LANDING (1<<9)
/// if docking or undocking times out, force it
///
/// * unlike general FORCE flags, this allows timeout to expire first before doing so.
#define SHUTTLE_TRANSIT_FLAG_FORCE_IF_DOCK_TIMEOUT (1<<10)
/// if docking or undocking fails, force it
///
/// * unlike general FORCE flags, this will not execute unless docking fails
#define SHUTTLE_TRANSIT_FLAG_FORCE_IF_DOCK_FAIL (1<<11)
/// if takeoff or landing times out, force it
///
/// * unlike general FORCE flags, this allows timeout to expire first before doing so.
#define SHUTTLE_TRANSIT_FLAG_FORCE_IF_TRAVERSAL_TIMEOUT (1<<12)
/// if takeoff or landing fails, force it
///
/// * unlike general FORCE flags, this will not execute unless traversal fails
#define SHUTTLE_TRANSIT_FLAG_FORCE_IF_TRAVERSAL_FAIL (1<<13)

#warn reconsider this

#warn DEFINE_BITFIELD
