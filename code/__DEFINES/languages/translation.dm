//! adaptive translation stuff
//! don't mess with this unless you know math

/// above this point we're considered perfect, stop doing expensive computations
#define TRANSLATION_CONTEXT_PERFECT_THRESHOLD 0.98
