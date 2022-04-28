//
/// sent upon a mob being added:				(mob)
#define COMSIG_PERSPECTIVE_MOB_ADD				"perspective_add_mob"
/// sent upon a mob beiing removed:				(mob, switching)
#define COMSIG_PERSPECTIVE_MOB_REMOVE			"perspective_del_mob"
/// sent upon a client switching to us:			(client)
#define COMSIG_PERSPECTIVE_CLIENT_REGISTER		"perspective_add_client"
/// sent upon a client switching away from us:	(client, switching)
#define COMSIG_PERSPECTIVE_CLIENT_UNREGISTER	"perspective_del_client"
/// sent upon calling Update()
#define COMSIG_PERSPECTIVE_CLIENT_UPDATE		"perspective_update_client"
