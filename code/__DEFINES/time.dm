#define DS2TICKS(DS) ((DS)/world.tick_lag)	// Convert deciseconds to ticks
#define TICKS2DS(T) ((T) TICKS) 				// Convert ticks to deciseconds

#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOUR *36000
#define HOURS *36000

#define DAY *864000
#define DAYS *864000

#define TICK *world.tick_lag
#define TICKS *world.tick_lag
