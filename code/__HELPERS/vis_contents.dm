// Making these procs systematic in view of a future where we have a
// proper system for queuing/caching/updating vis contents cleanly.
#define add_vis_contents(A, B)    A.vis_contents |= (B)
#define remove_vis_contents(A, B) A.vis_contents -= (B)
#define clear_vis_contents(A)     A.vis_contents.Cut()
#define set_vis_contents(A, B)    A.vis_contents = (B)

