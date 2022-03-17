// The below should be used to define an item's w_class variable.
// Example: w_class = ITENSIZE_LARGE
// This allows the addition of future w_classes without needing to change every file.
#define ITEM_SIZE_TINY				1
#define ITEM_SIZE_SMALL				2
#define ITEM_SIZE_NORMAL			3
#define ITEM_SIZE_LARGE				4
#define ITEM_SIZE_HUGE				5
#define ITEM_SIZE_NO_CONTAINER		100 // Use this to forbid item from being placed in a container.

// Tweak these to determine how much space an item takes in a container.
// Look in storage.dm for get_storage_cost(), which uses these.  Containers also use these as a reference for size.
// ITEM_SIZE_COST_NORMAL is equivalent to one slot using the old inventory system.  As such, it is a nice reference to use for
// defining how much space there is in a container.
#define ITEM_SIZE_COST_TINY			1
#define ITEM_SIZE_COST_SMALL			2
#define ITEM_SIZE_COST_NORMAL		4
#define ITEM_SIZE_COST_LARGE			8
#define ITEM_SIZE_COST_HUGE			16
#define ITEM_SIZE_COST_NO_CONTAINER	1000

// Container sizes.  Note that different containers can hold a maximum ITEMSIZE.
#define INVENTORY_STANDARD_SPACE	ITEM_SIZE_COST_NORMAL * 7 // 28
#define INVENTORY_DUFFLEBAG_SPACE	ITEM_SIZE_COST_NORMAL * 10 // 36
#define INVENTORY_BOX_SPACE			ITEM_SIZE_COST_SMALL * 7

//this all needs a refactor to tg storage but for now..
#define MAX_STORAGE_REACH 2		//maximum you can reach down to grab things from storage.
