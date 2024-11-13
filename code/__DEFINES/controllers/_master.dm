/**
 * This file (and its -dash files) is called MC, but actually holds quite a lot of logic including init orders
 * and subsystems as the MC and subsystems make up the global orchestration system of the codebase.
 */

#define MC_TICK_CHECK ( ( TICK_USAGE > Master.current_ticklimit || src.state != SS_RUNNING ) ? pause() : 0 )
#define MC_TICK_CHECK_USAGE ( ( TICK_USAGE > Master.current_ticklimit ) ? pause() : 0 )

#define MC_SPLIT_TICK_INIT(phase_count) var/original_tick_limit = Master.current_ticklimit; var/split_tick_phases = ##phase_count
#define MC_SPLIT_TICK \
    if(split_tick_phases > 1){\
        Master.current_ticklimit = ((original_tick_limit - TICK_USAGE) / split_tick_phases) + TICK_USAGE;\
        --split_tick_phases;\
    } else {\
        Master.current_ticklimit = original_tick_limit;\
    }

// Used to smooth out costs to try and avoid oscillation.
#define MC_AVERAGE_FAST(average, current) (0.7 * (average) + 0.3 * (current))
#define MC_AVERAGE(average, current) (0.8 * (average) + 0.2 * (current))
#define MC_AVERAGE_SLOW(average, current) (0.9 * (average) + 0.1 * (current))

#define MC_AVG_FAST_UP_SLOW_DOWN(average, current) (average > current ? MC_AVERAGE_SLOW(average, current) : MC_AVERAGE_FAST(average, current))
#define MC_AVG_SLOW_UP_FAST_DOWN(average, current) (average < current ? MC_AVERAGE_SLOW(average, current) : MC_AVERAGE_FAST(average, current))

#define START_PROCESSING(Processor, Datum) if (!(Datum.datum_flags & DF_ISPROCESSING)) {Datum.datum_flags |= DF_ISPROCESSING;Processor.processing += Datum}
#define STOP_PROCESSING(Processor, Datum) Datum.datum_flags &= ~DF_ISPROCESSING;Processor.processing -= Datum

//*                               Recreate_MC() return values                                        *//

#define MC_RESTART_RTN_FAILED -1
#define MC_RESTART_RTN_COOLDOWN 0
#define MC_RESTART_RTN_SUCCESS 1

//*                           Master Controller Loop() return values                                 *//

/// Unknown or error
#define MC_LOOP_RTN_UNKNOWN 0
/// New initialize stage happened
#define MC_LOOP_RTN_NEWSTAGES 1
/// We want the MC to exit.
#define MC_LOOP_RTN_GRACEFUL_EXIT 2
