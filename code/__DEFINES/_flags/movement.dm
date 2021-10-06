// /atom/movable movement_type
/// Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.
#define UNSTOPPABLE				(1<<0)
/// Ground movement
#define GROUND					(1<<1)
/// Flying movement
#define FLYING					(1<<2)
/// Phasing movement (phazons, shadekins, etc)
#define PHASING					(1<<3)
/// Floating movement like no gravity etc etc
#define FLOATING				(1<<4)
/// Ventcrawling
#define VENTCRAWLING			(1<<5)
