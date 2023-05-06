// Supply shuttle status defines
/// Error state
#define SUP_SHUTTLE_ERROR -1
#define SUP_SHUTTLE_DOCKED 0
#define SUP_SHUTTLE_UNDOCKED 1
#define SUP_SHUTTLE_DOCKING 2
#define SUP_SHUTTLE_UNDOCKING 3
#define SUP_SHUTTLE_TRANSIT 4
#define SUP_SHUTTLE_AWAY 5

#warn above


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

//? supply_pack_flags
#define SUPPLY_PACK_CONTRABAND (1<<0) //! is contraband
#define SUPPLY_PACK_HARDLOCK (1<<1) //! prevent private orders from overriding access locks

DEFINE_BITFIELD(supply_pack_flags, list(
	BITFIELD(SUPPLY_PACK_CONTRABAND),
	BITFIELD(SUPPLY_PACK_HARDLOCK),
))

//? supply_item_flags
#define SUPPLY_ITEM_CONTRABAND (1<<0) //! is contraband
#define SUPPLY_ITEM_HARDLOCK (1<<1) //! prevent private orders from overriding access locks

DEFINE_BITFIELD(supply_item_flags, list(
	BITFIELD(SUPPLY_ITEM_CONTRABAND),
	BITFIELD(SUPPLY_ITEM_HARDLOCK),
))

//? system tuning

/// max number of shipments held in logs
#define SUPPLY_MAX_LOGGED_SHIPMENTS 100
/// max number of orders held in logs
#define SUPPLY_MAX_LOGGED_ORDERS 100

//? system ids

#define SUPPLY_SYSTEM_ID_STATION "station"
#define SUPPLY_SYSTEM_ID_TRADER "trader"
