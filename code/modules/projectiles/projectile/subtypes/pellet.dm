// For projectiles that actually represent clouds of projectiles
// todo: message handling for this type is all over the place
// todo: target still makes message of being hit even if they weren't
// todo: just handle message in this file lmao
// todo: better description; this type does have an excuse to have special behavior.
/obj/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'

	damage_force = 20

	/// number of pelelts
	var/pellets = 4
	/// distance before pellets start falling off
	var/pellet_loss_start = WORLD_ICON_SIZE * 2
	/// pellets lost per pixel moved
	var/pellet_loss = 0.5 / WORLD_ICON_SIZE
	/// last distance travelled
	var/pellet_loss_last_distance = 0
	/// base spread chance to not hit center mass / the target limb
	///
	/// * in 0 to 100 prob() value
	var/pellet_zone_spread = 10
	/// min distance before spread
	var/pellet_zone_spread_gain_threshold = 2 * WORLD_ICON_SIZE
	/// spread chance per pixel to not hit center mass / target limb
	///
	/// * in 0 to 100 prob() value
	var/pellet_zone_spread_gain = 9 / WORLD_ICON_SIZE // complete spread after 2+10 tiles

/obj/projectile/bullet/pellet/scan_moved_turf(turf/tile)
	..()
	if(QDELETED(src))
		return
	for(var/mob/victim in tile)
		if(victim.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
			continue
		if(impacted[victim])
			continue
		impact(victim)

/obj/projectile/bullet/pellet/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	var/travelled = distance_travelled - pellet_loss_last_distance
	pellet_loss_last_distance = distance_travelled
	if(pellet_loss_start > 0)
		var/reduction = min(pellet_loss_start, travelled)
		travelled -= reduction
		pellet_loss_start -= reduction
	if(travelled <= 0)
		return
	pellets -= pellet_loss * travelled

/obj/projectile/bullet/pellet/process_accuracy(atom/target, target_opinion, distance, impact_check)
	if(impact_check)
		return 100
	return ..()

/obj/projectile/bullet/pellet/process_zone_miss(atom/target, target_opinion, distance, impact_check)
	if(impact_check)
		// if being hit, always direct to our def_zone
		return def_zone
	return ..()

// todo: "you are hit by [number of] pellets in the chest" support.
/obj/projectile/bullet/pellet/inflict_impact_damage(atom/target, efficiency, impact_flags, hit_zone)
	/**
	 * What's going on here:
	 *
	 * It's too expensive to simulate too many bullet_act()'s for no reason, but pellets
	 * aren't meant to hit one body part or even do one instance to every body part hit.
	 *
	 * Thus, we force process_damage_instance to do your dirty work as it's cheaper to run
	 * lower level shieldcalls/armorcalls than to simulate high level bullet hits.
	 */
	var/original_hit_zone = hit_zone
	var/distance_penalty = distance_travelled > pellet_zone_spread_gain_threshold ? (distance_travelled * pellet_zone_spread_gain) : 0
	var/zone_true_chance = 100 - (pellet_zone_spread + distance_penalty)
	var/pellet_hit_chance = 100
	. = impact_flags
	if(isliving(target))
		var/mob/living/living_target = target
		pellet_hit_chance = living_target.process_baymiss(src, impact_check = FALSE)
	if(!target.density && (target != original_target))
		pellet_hit_chance *= 0.2
	var/hit_pellets = 0
	for(var/i in 1 to ceil(pellets))
		if(!prob(pellet_hit_chance))
			continue
		// args is just a list ref, so we can do this (directly modify args)
		hit_zone = ran_zone(def_zone, zone_true_chance)
		. |= ..()
		++hit_pellets
	pellets -= hit_pellets
	hit_zone = original_hit_zone
	if(pellets <= 0)
		. |= PROJECTILE_IMPACT_DELETE
	else
		. |= PROJECTILE_IMPACT_PIERCE

// todo: this is only needed because process_damage_instance isn't used for structured right now!
/obj/projectile/bullet/pellet/get_structure_damage()
	return ..() * pellets

//Explosive grenade projectile, borrowed from fragmentation grenade code.
/obj/projectile/bullet/pellet/fragment
	damage_force = 10
	damage_tier = 3.5

	silenced = 1 //embedding messages are still produced so it's kind of weird when enabled.
	legacy_muzzle_type = null

/obj/projectile/bullet/pellet/fragment/strong
	damage_force = 10
	damage_tier = 4.5

/obj/projectile/bullet/pellet/fragment/weak
	damage_force = 7.5
	damage_tier = 2.25

/obj/projectile/bullet/pellet/fragment/rubber
	name = "stingball shrapnel"
	damage_force = 3
	damage_tier = 2
	damage_inflict_agony = 7
	damage_mode = NONE
	damage_flag = ARMOR_MELEE

/obj/projectile/bullet/pellet/fragment/rubber/strong
	damage_force = 8
	damage_inflict_agony = 16

// Tank rupture fragments
/obj/projectile/bullet/pellet/fragment/tank
	name = "metal fragment"
	damage_force = 7
	damage_tier = 4.5

	silenced = 1
	legacy_muzzle_type = null
	pellets = 3

/obj/projectile/bullet/pellet/fragment/tank/small
	name = "small metal fragment"
	damage_force = 6
	damage_tier = 3.25
	pellets = 5

/obj/projectile/bullet/pellet/fragment/tank/big
	name = "large metal fragment"
	damage_force = 17
	damage_tier = 2.7
	pellet_loss = 0.2 / WORLD_ICON_SIZE
	pellets = 1
