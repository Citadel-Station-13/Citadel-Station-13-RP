//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Supply Packs - Flags *//

/// prevent private orders from overriding access locks
#define SUPPLY_PACK_HARDLOCK (1<<0)

#warn new define bitfield
DEFINE_BITFIELD(supply_pack_flags, list(
	BITFIELD(SUPPLY_PACK_HARDLOCK),
))

//* Supply Items - Flags *//

/// prevent private orders from overriding access locks
#define SUPPLY_ITEM_HARDLOCK (1<<0)

#warn new define bitfield
DEFINE_BITFIELD(supply_item_flags, list(
	BITFIELD(SUPPLY_ITEM_HARDLOCK),
))

#warn below

//* Systems - IDs *//

#define SUPPLY_SYSTEM_ID_STATION "station"
#define SUPPLY_SYSTEM_ID_TRADER "trader"

//? supply order status
#define SUPPLY_ORDER_ERRORED 0
#define SUPPLY_ORDER_REQUESTED 1
#define SUPPLY_ORDER_APPROVED 2
#define SUPPLY_ORDER_DENIED 3
#define SUPPLY_ORDER_SHIPPED 4

//? supply system auth
#define SUPPLY_AUTH_REQUEST (1<<0) //! request stuff, either with your own money or from the handler's supply
#define SUPPLY_AUTH_DENY (1<<1) //! deny stuff
#define SUPPLY_AUTH_ACCEPT (1<<2) //! accept stuff
#define SUPPLY_AUTH_PAYMENT (1<<3) //! accept stuff with the supply system's currency
#define SUPPLY_AUTH_HANDLER (1<<4) //! send/receive handler (shuttle, elevator, etc)
#define SUPPLY_AUTH_SELFORDER (1<<5) //! can immediately order without needing cargo to accept
#define SUPPLY_AUTH_CONTRABAND (1<<6) //! can order contraband

//? system tuning

/// max number of shipments held in logs
#define SUPPLY_MAX_LOGGED_SHIPMENTS 100
/// max number of orders held in logs
#define SUPPLY_MAX_LOGGED_ORDERS 100

#warn above
