
// What each index means:
#define DNA_OFF_LOWERBOUND 0
#define DNA_OFF_UPPERBOUND 1
#define DNA_ON_LOWERBOUND  2
#define DNA_ON_UPPERBOUND  3

// Define block bounds (off-low,off-high,on-low,on-high)
// Used in setupgame.dm
#define DNA_DEFAULT_BOUNDS list(1,2049,2050,4095)
#define DNA_HARDER_BOUNDS  list(1,3049,3050,4095)
#define DNA_HARD_BOUNDS    list(1,3490,3500,4095)

// UI Indices (can change to mutblock style, if desired)
#define DNA_UI_HAIR_R      1
#define DNA_UI_HAIR_G      2
#define DNA_UI_HAIR_B      3
#define DNA_UI_BEARD_R     4
#define DNA_UI_BEARD_G     5
#define DNA_UI_BEARD_B     6
#define DNA_UI_SKIN_TONE   7
#define DNA_UI_SKIN_R      8
#define DNA_UI_SKIN_G      9
#define DNA_UI_SKIN_B      10
#define DNA_UI_EYES_R      11
#define DNA_UI_EYES_G      12
#define DNA_UI_EYES_B      13
#define DNA_UI_GENDER      14
#define DNA_UI_BEARD_STYLE 15
#define DNA_UI_HAIR_STYLE  16
#define DNA_UI_EAR_STYLE   17 // VOREStation snippet.
#define DNA_UI_TAIL_STYLE  18
#define DNA_UI_PLAYERSCALE 19
#define DNA_UI_TAIL_R      20
#define DNA_UI_TAIL_G      21
#define DNA_UI_TAIL_B      22
#define DNA_UI_TAIL2_R     23
#define DNA_UI_TAIL2_G     24
#define DNA_UI_TAIL2_B     25
#define DNA_UI_EARS_R      26
#define DNA_UI_EARS_G      27
#define DNA_UI_EARS_B      28
#define DNA_UI_EARS2_R     29
#define DNA_UI_EARS2_G     30
#define DNA_UI_EARS2_B     31
#define DNA_UI_WING_STYLE  32
#define DNA_UI_WING_R      33
#define DNA_UI_WING_G      34
#define DNA_UI_WING_B      35 // VOREStation snippet end.
#define DNA_UI_LENGTH      35 // VOREStation Edit to 35

#define DNA_SE_LENGTH 46 // VOREStation Edit (original was UI+11)