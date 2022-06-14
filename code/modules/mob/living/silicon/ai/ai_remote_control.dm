/mob/living/silicon/ai
	var/mob/living/silicon/robot/deployed_shell = null //For shell control

/mob/living/silicon/ai/proc/deploy_to_shell(var/mob/living/silicon/robot/target)
	if(!config_legacy.allow_ai_shells)
		to_chat(src, SPAN_WARNING( "AI Shells are not allowed on this server. You shouldn't have this verb because of it, so consider making a bug report."))
		return

	if(incapacitated())
		to_chat(src, SPAN_WARNING( "You are incapacitated!"))
		return

	if(lacks_power())
		to_chat(src, SPAN_WARNING( "Your core lacks power, wireless is disabled."))
		return

	if(control_disabled)
		to_chat(src, SPAN_WARNING( "Wireless networking module is offline."))
		return

	var/list/possible = list()

	for(var/borgie in GLOB.available_ai_shells)
		var/mob/living/silicon/robot/R = borgie
		var/turf/T = get_turf(R)
		if(R.shell && !R.deployed && (R.stat != DEAD) && (!R.connected_ai || (R.connected_ai == src) )  && !(GLOB.using_map.ai_shell_restricted && !(T.z in GLOB.using_map.ai_shell_allowed_levels)) )
			possible += R

	if(!LAZYLEN(possible))
		to_chat(src, SPAN_WARNING( "No usable AI shell beacons detected."))

	if(!target || !(target in possible)) //If the AI is looking for a new shell, or its pre-selected shell is no longer valid
		target = input(src, "Which body to control?") as null|anything in possible

	if(!target || target.stat == DEAD || target.deployed || !(!target.connected_ai || (target.connected_ai == src) ) )
		if(target)
			to_chat(src, SPAN_WARNING( "It is no longer possible to deploy to \the [target]."))
		else
			to_chat(src, SPAN_NOTICE("Deployment aborted."))
		return

	else if(mind)
		soul_link(/datum/soul_link/shared_body, src, target)
		deployed_shell = target
		target.deploy_init(src)
		mind.transfer_to(target)
		teleop = target // So the AI 'hears' messages near its core.
		target.post_deploy()

/mob/living/silicon/ai/proc/deploy_to_shell_act()
	set category = "AI Commands"
	set name = "Deploy to Shell"
	deploy_to_shell() // This is so the AI is not prompted with a list of all mobs when using the 'real' proc.

/mob/living/silicon/ai/proc/disconnect_shell(message = "Your remote connection has been reset!")
	if(deployed_shell) // Forcibly call back AI in event of things such as damage, EMP or power loss.
		message = SPAN_DANGER(message)
		deployed_shell.undeploy(message)
