//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/proc/eldritch_rust_inflict(amount)
	AddComponent(/datum/component/eldritch_rust, amount)

/obj/proc/eldritch_rust_clear()
	DelCompnoent(/datum/component/eldritch_rust)
