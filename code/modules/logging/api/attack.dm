//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/log_melee(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/style, obj/item/weapon)
	// todo: log style?
	if(Configuration.get_entry(/datum/toml_config_entry/backend/logging/toggles/attack))
		var/str = "MELEE: [clickchain.actor_log_string()] --> [clickchain.target] via [weapon ? "([weapon]) ([weapon.type])" : "() ()"] ([style ? style.type : ""]) \
		[clickchain_flags & CLICKCHAIN_ATTACK_MISSED ? "(MISSED) " : ""]\
		I [clickchain.using_intent] \
		TZ [clickchain.target_zone] \
		MUL [clickchain.attack_melee_multiplier] \
		[length(clickchain.data) ? "DATA [json_encode(clickchain.data)]" : ""]"
		WRITE_LOG(GLOB.world_attack_log, str)
