#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define TO_WORLD(message) to_chat(world, message)

#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)
#define close_browser(target, browser_name)                 target << browse(null, browser_name)

#define CanInteract(user, state) (CanUseTopic(user, state) == UI_INTERACTIVE)

#define CanDefaultInteract(user) (CanUseTopic(user, DefaultTopicState()) == UI_INTERACTIVE)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

#define JOINTEXT(X) jointext(X, null)

#define BITSHIFT_LEFT(X, N) (X << (N))

#define BITSHIFT_RIGHT(X, N) (X >> (N))

#define BITFLAG(X) BITSHIFT_LEFT(1, X)
