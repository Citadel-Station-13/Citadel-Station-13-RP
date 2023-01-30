// The below should be used to define an item's w_class variable.
// Example: w_class = ITENSIZE_LARGE
// This allows the addition of future w_classes without needing to change every file.
#define ITEMSIZE_TINY				1
#define ITEMSIZE_SMALL				2
#define ITEMSIZE_NORMAL				3
#define ITEMSIZE_LARGE				4
#define ITEMSIZE_HUGE				5
//I am done with having to adjust these everytime I port something from bay or nebula
#define ITEM_SIZE_TINY           1
#define ITEM_SIZE_SMALL          2
#define ITEM_SIZE_NORMAL         3
#define ITEM_SIZE_LARGE          4
#define ITEM_SIZE_HUGE           5
#define ITEM_SIZE_GARGANTUAN     6
#define ITEM_SIZE_NO_CONTAINER   10 // Use this to forbid item from being placed in a container.
#define ITEM_SIZE_STRUCTURE      20

/// Use this to forbid item from being placed in a container.
#define ITEMSIZE_NO_CONTAINER		100
// Tweak these to determine how much space an item takes in a container.
// Look in storage.dm for get_storage_cost(), which uses these.  Containers also use these as a reference for size.
// ITEMSIZE_COST_NORMAL is equivalent to one slot using the old inventory system.  As such, it is a nice reference to use for
// defining how much space there is in a container.
#define ITEMSIZE_COST_TINY			1
#define ITEMSIZE_COST_SMALL			2
#define ITEMSIZE_COST_NORMAL		4
#define ITEMSIZE_COST_LARGE			8
#define ITEMSIZE_COST_HUGE			16
#define ITEMSIZE_COST_NO_CONTAINER	1000

// Container sizes.  Note that different containers can hold a maximum ITEMSIZE.
/// 28
#define INVENTORY_STANDARD_SPACE	ITEMSIZE_COST_NORMAL * 7
/// 36
#define INVENTORY_DUFFLEBAG_SPACE	ITEMSIZE_COST_NORMAL * 10
#define INVENTORY_BOX_SPACE			ITEMSIZE_COST_SMALL * 7

//this all needs a refactor to tg storage but for now..
///maximum you can reach down to grab things from storage.
#define MAX_STORAGE_REACH 2
