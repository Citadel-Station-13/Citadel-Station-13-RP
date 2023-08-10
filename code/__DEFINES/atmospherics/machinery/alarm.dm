//* air alarm mode
/// Everything off
#define AIR_ALARM_MODE_OFF "off"
/// vents on, scrubbers scrub
#define AIR_ALARM_MODE_SCRUB "scrub"
/// vents on, scrubbers siphon
#define AIR_ALARM_MODE_REPLACE "replace"
/// vents off, scrubbers siphon
#define AIR_ALARM_MODE_SIPHON "siphon"
/// siphon and then switch to scrub
#define AIR_ALARM_MODE_CYCLE "cycle"
/// panic siphon - rapidly siphon all air out of room
#define AIR_ALARM_MODE_PANIC "panic"
/// contaminated - high power scrub
#define AIR_ALARM_MODE_CONTAMINATED "contaminated"
/// vents on, scrubbers off
#define AIR_ALARM_MODE_FILL "fill"

//* air alarm danger state
#define AIR_ALARM_RAISE_OKAY 0
#define AIR_ALARM_RAISE_WARNING 1
#define AIR_ALARM_RAISE_DANGER 2

//* air alarm TLV operatoins
#define AIR_ALARM_TLV_DANGER_LOW 1
#define AIR_ALARM_TLV_WARNING_LOW 2
#define AIR_ALARM_TLV_WARNING_HIGH 3
#define AIR_ALARM_TLV_DANGER_HIGH 4
#define AIR_ALARM_MAKE_TLV(mindanger, minwarning, maxwarning, maxdanger) list(mindanger, minwarning, maxwarning, maxdanger)
#define AIR_ALARM_TEST_TLV(val, list) ( \
	((val < list[AIR_ALARM_TLV_DANGER_LOW]) || (val > list[AIR_ALARM_TLV_DANGER_HIGH]))? \
	AIR_ALARM_RAISE_DANGER : ((val < list[AIR_ALARM_TLV_WARNING_LOW] || val > list[AIR_ALARM_TLV_WARNING_HIHG])? \
	AIR_ALARM_RAISE_WARNING : AIR_ALARM_RAISE_OKAY) \
	)
