//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//*                Vehicle Control Flags                   *//
//* control flags describe access to actions in a vehicle. *//

/// controls the vehicles movement
#define VEHICLE_CONTROL_DRIVE (1<<0)
/// has access to default HUDs that everyone has
#define VEHICLE_CONTROL_USE_HUDS (1<<1)
/// exit the vehicle freely
#define VEHICLE_CONTROL_EXIT (1<<2)
