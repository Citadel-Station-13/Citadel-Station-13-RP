//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * locomotion modules that provide space / frictionless movement
 */
/obj/item/rig_module/locomotion/jetpack

#warn impl

/**
 * no more free lunches; 'electric' jetpacks no longer exist,
 * just insanely high efficiency ion thrusters that really should
 * cook whoever's standing behind you but i'm not *that* mean...
 * * i did consider making this actually calculate impulse, but the results
 *   even with my limited knowledge of mechanics is that it would require more power
 *   than even the in-game tech level of 10-20x power storage capacity as modern-day,
 *   and would also result in the exhaust stream being very, very unhealthy to be standing
 *   next to.
 */
/obj/item/rig_module/locomotion/jetpack/gas
	/// gas key to pull from
	var/gas_route = "jetpack"
w
	/// grams of gas needed to move one tile
	/// * pressure-cramming is punished by [jet_minimum_release_volume]
	/// * the value here is to let you go ~1920 tiles on ~31 mols of nitrogen at 273.15K,
	///   which is the 'recommended settings' for jetpacks.
	/// * this does mean phoron is the best gas for jetpacks but you might want to
	///   think twice about using explosive + mutagenic gas as a jetpack fuel.
	var/jet_ideal_mass = 0.5
	/// joules of energy needed to move one tile when ejecting ideal mass grams
	/// * assuming 10k cell (rigs will be bumped to 30k but for now..) have 5kj
	///   (bit low for future-tech but whatever lol) this should be ~1.3J per tile at
	///   1 gram ejection
	var/jet_ideal_energy = 1.3

	/// minimum liters released per tile
	/// * releasing more moles of gas than required to thrust lowers power consumption
	///   but still is using a lot more gas.
	/// * this is explicitly to punish people freezing the tank to the point
	///   the tank should honestly act more like a bomb than an actual tank when indoors.
	///   seriously, i really should add equalization so absolute-zero tanks are just
	///   fused explosives. stop it, people.
	///
	/// calc:
	/// at 70 L you have ~33mol-ish (?)
	/// we need 0.5 g which is 0.022 of a mol
	/// 0.471 mol per liter --> 0.0467 L per tile
	/// (this is kinda wildly off but it's close enough for an anti-cramming measure lol)
	/// multiply by 2 to let them powergame a *little*.
	var/jet_minimum_release_volume = 0.0467 / 2

/obj/item/rig_module/locomotion/jetpack/gas/Initialize()

/**
 * @return grams pulled
 */
/obj/item/rig_module/locomotion/jetpack/gas/proc/attempt_pull_mass(grams)
	var/datum/gas_mixture/mixture = host.resources.gas_mixture_ref(src, gas_route)
	if(!mixture)
		return 0



#warn impl
