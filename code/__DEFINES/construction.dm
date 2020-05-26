//
// Frame construction
//

// Frame construction states
#define FRAME_PLACED 0		// Has been placed (can be anchored or not).
#define FRAME_UNFASTENED 1	// Circuit added.
#define FRAME_FASTENED 2	// Circuit fastened.
#define FRAME_WIRED 3		// Frame wired.
#define FRAME_PANELED 4		// Glass panel added.

// The frame classes define a sequence of construction steps.
#define FRAME_CLASS_ALARM "alarm"
#define FRAME_CLASS_COMPUTER "computer"
#define FRAME_CLASS_DISPLAY "display"
#define FRAME_CLASS_MACHINE "machine"

// Does the frame get built on the floor or a wall?
#define FRAME_STYLE_FLOOR "floor"
#define FRAME_STYLE_WALL "wall"

//
// Disposals Construction
//
#define DISPOSAL_PIPE_STRAIGHT 0
#define DISPOSAL_PIPE_CORNER 1
#define DISPOSAL_PIPE_JUNCTION 2
#define DISPOSAL_PIPE_JUNCTION_FLIPPED 3
#define DISPOSAL_PIPE_JUNCTION_Y 4
#define DISPOSAL_PIPE_TRUNK 5
#define DISPOSAL_PIPE_BIN 6
#define DISPOSAL_PIPE_OUTLET 7
#define DISPOSAL_PIPE_CHUTE 8
#define DISPOSAL_PIPE_SORTER 9
#define DISPOSAL_PIPE_SORTER_FLIPPED 10
#define DISPOSAL_PIPE_UPWARD 11
#define DISPOSAL_PIPE_DOWNWARD 12
#define DISPOSAL_PIPE_TAGGER 13
#define DISPOSAL_PIPE_TAGGER_PARTIAL 14

#define DISPOSAL_SORT_NORMAL 0
#define DISPOSAL_SORT_WILDCARD 1
#define DISPOSAL_SORT_UNTAGGED 2
