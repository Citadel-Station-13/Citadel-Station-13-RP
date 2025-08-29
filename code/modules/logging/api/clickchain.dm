//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/log_clickchain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/list/data = list(
		"performer" = key_name(clickchain.performer),
		"target" = ismob(clickchain.target) ? key_name(clickchain.target) : "[clickchain.target || "null"]",
		"intent" = clickchain.using_intent,
		"hand" = clickchain.using_hand_index,
		"zone" = clickchain.target_zone,
		"data" = clickchain.data,
		"params" = clickchain.click_params,
		"flags" = clickchain_flags,
	)
	if(clickchain.performer != clickchain.initiator)
		data["initiator"] = key_name(clickchain.initiator)
	WRITE_LOG(GLOB.click_log , json_encode(data))
	// global.event_logger.log__clickchain(clickchain, clickchain_flags)
