//? Stat var - lets us get the most basic of mob health status from one var. higher = 'worse' / less conscious.
/// we're conscious
#define CONSCIOUS   0
/// we're unconscious
#define UNCONSCIOUS 1
/// we're dead
#define DEAD        2

//? stat helpers - since most semantic checks are going to be compound checks
#define IS_CONSCIOUS(M)               (M.stat == CONSCIOUS)
#define IS_ALIVE_BUT_UNCONSCIOUS(M)   (M.stat == UNCONSCIOUS) //! named this way because dead is technically unconscious
#define IS_DEAD(M)                    (M.stat == DEAD)
#define IS_ALIVE(M)                   (M.stat != DEAD)

//? direct stat helpers
#define STAT_IS_CONSCIOUS(N)			(N == CONSCIOUS)
#define STAT_IS_DEAD(N)					(N == DEAD)
