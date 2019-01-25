#define span(class, text) ("<span class='[class]'>[text]</span>")

#define get_turf(A) get_step(A,0)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define to_chat(target, message) target << message
#define to_world(message) world << message
#define to_world_log(message) world.log << message


#define from_file(file_entry, target_var) file_entry >> target_var

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//This file needs to go - kevinz000
