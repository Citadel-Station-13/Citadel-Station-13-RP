
#define span(class, text) ("<span class='[class]'>[text]</span>")

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

// #define to_chat(target, message) target << message Not anymore!
#define to_chat to_chat_filename=__FILE__;to_chat_line=__LINE__;to_chat_src=src;__to_chat
#define to_world(message) to_chat(world, messaget)
#define to_file(file_entry, source_var) file_entry << source_var
#define from_file(file_entry, target_var) file_entry >> target_var

#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)


#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }
