#define STATE_UNDEFINED -1 //Manual overrides
#define STATE_CLOSED 0 //Both doors closed
#define STATE_OPEN_IN 1 //Interior doors open, exterior closed
#define STATE_OPEN_OUT 2 //Exterior doors open, interior closed
#define STATE_BYPASS 3

#define STATE_CYCLING_IN 4 //Matching indoors pressure and composition
#define STATE_CYCLING_OUT 5 //Matching outdoors pressure
#define STATE_SEALING 6 //Closing both doors
#define STATE_BYPASSING 7 //Unlocking both doors
