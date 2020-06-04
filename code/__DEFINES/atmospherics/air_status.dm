// /turf/var/air_status
/// Air will never, ever pass over this turf. Attempting to grab this turf's air will return its initial gas mix. This turf, however, will not participate in airflow or anything This turf is simply not part of atmospherics.
#define AIR_STATUS_BLOCK		0
/// This turf's air is a normal part of the atmospherics system, air can be modified.
#define AIR_STATUS_NORMAL		1
/// This turf is immutable like in AIR_STATUS_BLOCK but air will flow full-rate into the turf like unsimulated turfs are.
#define AIR_STATUS_IMMUTABLE	2
