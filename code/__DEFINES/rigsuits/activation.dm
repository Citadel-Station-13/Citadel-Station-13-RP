//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* /obj/item/rig activation_state

#define RIG_ACTIVATION_OFFLINE (1<<0)
#define RIG_ACTIVATION_ACTIVATING (1<<1)
#define RIG_ACTIVATION_DEACTIVATING (1<<2)
#define RIG_ACTIVATION_ONLINE (1<<3)

#define RIG_ACTIVATION_IS_CYCLING (RIG_ACTIVATION_ACTIVATING | RIG_ACTIVATION_DEACTIVATING)
