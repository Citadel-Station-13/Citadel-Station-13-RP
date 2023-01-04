/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/weaponsounds_rifleshot.ogg'
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	check_armour = "bullet"
	embed_chance = 20	//Modified in the actual embed process, but this should keep embed chance about the same
	sharp = 1
	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/muzzle/bullet
	miss_sounds = list('sound/weapons/guns/miss1.ogg','sound/weapons/guns/miss2.ogg','sound/weapons/guns/miss3.ogg','sound/weapons/guns/miss4.ogg')
	ricochet_sounds = list('sound/weapons/guns/ricochet1.ogg', 'sound/weapons/guns/ricochet2.ogg',
							'sound/weapons/guns/ricochet3.ogg', 'sound/weapons/guns/ricochet4.ogg')
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if (..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/projectile_attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	return ..()

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return 1 //mecha have their own penetration handling

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		if(iscarbon(A))
			damage *= 0.7 //squishy mobs absorb KE
		return 1

	var/chance = damage
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(damage/W.material.integrity*180)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(damage/D.maxhealth*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/item/projectile/bullet/pistol // 9mm pistols and most SMGs. Sacrifice power for capacity.
	fire_sound = 'sound/weapons/weaponsounds_smallpistolshot.ogg'
	damage = 20

/obj/item/projectile/bullet/pistol/lap //Light Armor Piercing
	damage = 20
	armor_penetration = 10

/obj/item/projectile/bullet/pistol/ap
	damage = 15
	armor_penetration = 30

/obj/item/projectile/bullet/pistol/hp
	damage = 25
	armor_penetration = -50

/obj/item/projectile/bullet/pistol/hunter
	damage = 15
	SA_bonus_damage = 25 // 40 total against animals
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1

/obj/item/projectile/bullet/pistol/silver
	damage = 15
	SA_bonus_damage = 25 // 40 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC
	embed_chance = -1
	holy = TRUE

/obj/item/projectile/bullet/pistol/medium // .45 (and maybe .40 if it ever gets added) caliber security pistols. Balance between capacity and power.
	fire_sound = 'sound/weapons/weaponsounds_pistolshot.ogg' // Snappier sound.
	damage = 25

/obj/item/projectile/bullet/pistol/medium/ap
	damage = 20
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/medium/hp
	damage = 30
	armor_penetration = -50

/obj/item/projectile/bullet/pistol/medium/hunter
	damage = 15
	SA_bonus_damage = 45 // 60 total against animals
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1

/obj/item/projectile/bullet/pistol/medium/silver
	damage = 15
	SA_bonus_damage = 45 // 60 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/item/projectile/bullet/pistol/medium/ap/suppressor // adminspawn only
	name = "suppressor bullet" // this guy is Important and also Hates You
	fire_sound = 'sound/weapons/doompistol.ogg' // converted from .wavs extracted from doom 2
	damage = 10 // high rof kinda fucked up lets be real
	agony = 10 // brute easily heals, agony not so much
	armor_penetration = 30 // reduces shield blockchance
	accuracy = -20 // he do miss actually
	speed = 0.4 // if the pathfinder gets a funny burst rifle, they deserve a rival
	// that's 2x projectile speed btw

/obj/item/projectile/bullet/pistol/medium/ap/suppressor/turbo // spicy boys
	speed = 0.2 // this is 4x projectile speed

/obj/item/projectile/bullet/pistol/strong // .357 and .44 caliber stuff. High power pistols like the Mateba or Desert Eagle. Sacrifice capacity for power.
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'
	damage = 60

/obj/item/projectile/bullet/pistol/strong/silver //Because all Demons need to die
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'
	damage = 40
	SA_bonus_damage = 80 // 120 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/item/projectile/bullet/pistol/rubber/strong // "Rubber" bullets for high power pistols.
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg' // Rubber shots have less powder, but these still have more punch than normal rubber shot.
	damage = 10
	agony = 60
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/obj/item/projectile/bullet/pistol/rubber // "Rubber" bullets for all other pistols.
	name = "rubber bullet"
	damage = 5
	agony = 40
	embed_chance = 0
	sharp = 0
	check_armour = "melee"
	fire_sound ='sound/weapons/weaponsounds_smallpistolshot.ogg' // It may be rubber shots but it's still a gun homie it shouldn't be as pathetic as it was

/obj/item/projectile/bullet/pistol/spin // Special weak ammo for Service Spin mode.
	fire_sound = 'sound/weapons/weaponsounds_smallpistolshot.ogg'
	damage = 5
	SA_bonus_damage = 10 // 15 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage = 50
	armor_penetration = 15

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damage = 20
	agony = 60
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage = 13
	pellets = 6
	range_step = 1
	spread_step = 10

/obj/item/projectile/bullet/pellet/shotgun_improvised
	name = "shrapnel"
	damage = 1
	pellets = 10
	range_step = 1
	spread_step = 10

/obj/item/projectile/bullet/pellet/shotgun/flak
	damage = 2 //The main weapon using these fires four at a time, usually with different destinations. Usually.
	range_step = 2
	spread_step = 30
	armor_penetration = 10

// This is my boomstick,
/obj/item/projectile/bullet/pellet/shotgun/silver
	name = "shrapnel"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage = 10
	SA_bonus_damage = 16 // Potential 156 Damage against demons at point blank.
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	pellets = 6
	range_step = 1
	spread_step = 20
	holy = TRUE

/obj/item/projectile/bullet/shotgun/stake
	name = "stake"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage = 50
	armor_penetration = 15
	SA_bonus_damage = 16 // Potential 156 Damage against demons at point blank.
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

//EMP shotgun 'slug', it's basically a beanbag that pops a tiny emp when it hits. //Not currently used
/obj/item/projectile/bullet/shotgun/ion
	name = "ion slug"
	fire_sound = 'sound/weapons/Laser.ogg' // Really? We got nothing better than this?
	damage = 15
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

	combustion = FALSE

/obj/item/projectile/bullet/shotgun/ion/on_hit(var/atom/target, var/blocked = 0)
	..()
	empulse(target, 0, 0, 2, 0)	//Only affects what it hits
	return 1

//Frag shot
/obj/item/projectile/bullet/shotgun/frag12
	name ="frag12 slug"
	damage = 25

/obj/item/projectile/bullet/shotgun/frag12/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 0, 1)
	return 1

/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	armor_penetration = 15
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	damage = 35

/obj/item/projectile/bullet/rifle/a762/sniper // Hitscan specifically for sniper ammo; to be implimented at a later date, probably for the SVD. -Ace
	fire_sound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	hitscan = 1 //so the ammo isn't useless as a sniper weapon

/obj/item/projectile/bullet/rifle/a762/ap
	damage = 30
	armor_penetration = 50 // At 30 or more armor, this will do more damage than standard rounds.

/obj/item/projectile/bullet/rifle/a762/ap/silver
	damage = 30
	armor_penetration = 50 // At 30 or more armor, this will do more damage than standard rounds.
	SA_bonus_damage = 30 // 60 total against demons
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/item/projectile/bullet/rifle/a762/hp
	damage = 40
	armor_penetration = -50
	penetrating = 0

/obj/item/projectile/bullet/rifle/a762/hunter // Optimized for killing simple animals and not people, because Balance(tm)
	damage = 25
	SA_bonus_damage = 45 // 70 total on animals.
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1

/obj/item/projectile/bullet/rifle/a762/sniperhunter
	damage = 25
	SA_bonus_damage = 45 // 70 total on animals.
	SA_vulnerability = MOB_CLASS_ANIMAL
	embed_chance = -1
	speed = 0.4

/obj/item/projectile/bullet/rifle/a762/silver // Hunting Demons with bolt action rifles.
	damage = 20
	SA_bonus_damage = 50 // 70 total on animals.
	SA_vulnerability = MOB_CLASS_DEMONIC
	holy = TRUE

/obj/item/projectile/bullet/rifle/a545
	fire_sound = 'sound/weapons/weaponsounds_rifleshot.ogg'
	damage = 25

/obj/item/projectile/bullet/rifle/a545/ap
	damage = 20
	armor_penetration = 50 // At 40 or more armor, this will do more damage than standard rounds.

/obj/item/projectile/bullet/rifle/a545/hp
	damage = 35
	armor_penetration = -50
	penetrating = 0

/obj/item/projectile/bullet/rifle/a545/hunter
	damage = 15
	SA_bonus_damage = 35 // 50 total on animals.
	SA_vulnerability = MOB_CLASS_ANIMAL

/obj/item/projectile/bullet/rifle/a145 // 14.5×114mm is bigger than a .50 BMG round.
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg' // This is literally an anti-tank rifle caliber. It better sound like a fucking cannon.
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 80
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

/* Miscellaneous */

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX

/obj/item/projectile/bullet/cyanideround/jezzail
	name = "toxic penetrator shard"
	damage = 25
	armor_penetration = 20
	agony = 5
	embed_chance = 1
	damage_type = TOX

/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	fire_sound = 'sound/soundbytes/effects/explosion/explosion1.ogg'
	damage = 20
	embed_chance = 0
	edge = 1

/obj/item/projectile/bullet/burstbullet/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()

/obj/item/projectile/bullet/burstbullet/service
	name = "charge bullet"
	fire_sound = 'sound/soundbytes/effects/explosion/explosion1.ogg'
	damage = 20
	embed_chance = 0
	edge = 1
	SA_bonus_damage = 40 // 60 total damage against demons.
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

/obj/item/projectile/bullet/burstbullet/service/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, 0, 1, 2)
	..()

/* Black Powder */

/obj/item/projectile/bullet/musket // Big Slow and bad against armor.
	fire_sound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'
	damage = 60
	speed = 1.2
	armor_penetration = -50

/obj/item/projectile/bullet/musket/silver // What its a classic
	damage = 25
	SA_bonus_damage = 75
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

/obj/item/projectile/bullet/pellet/blunderbuss //More Damage at close range greater falloff
	damage = 10
	pellets = 8
	range_step = 0.5 //Very quick falloff
	spread_step = 30

/obj/item/projectile/bullet/pellet/blunderbuss/silver
	damage = 5
	SA_bonus_damage = 15
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	embed_chance = -1
	holy = TRUE

//10 Gauge Shot
/obj/item/projectile/bullet/heavy_shotgun
	name = "heavy slug"
	fire_sound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	damage = 60
	armor_penetration = 25

/obj/item/projectile/bullet/pellet/heavy_shotgun //I want this to use similar calcuations to blunderbuss shot for falloff.
	damage = 3 //Fires five pellets at a time.
	range_step = 0.75
	spread_step = 30
	armor_penetration = 10

/obj/item/projectile/bullet/pellet/heavy_shotgun/silver
	damage = 3
	SA_bonus_damage = 3
	SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION
	holy = TRUE

//Special 10g rounds for Grit, since I don't want ALL 10g to do this:
/obj/item/projectile/bullet/heavy_shotgun/grit
	name = "custom heavy slug"

/obj/item/projectile/bullet/heavy_shotgun/grit/on_hit(var/atom/movable/target, var/blocked = 0)
	if(isliving(target))
		var/mob/living/L = target
		var/throwdir = get_dir(firer,L)
		if(prob(10) && !blocked)
			L.Stun(1)
			L.Confuse(1)
		L.throw_at_old(get_edge_target_turf(L, throwdir), rand(3,6), 10)

		return 1

/obj/item/projectile/bullet/pellet/heavy_shotgun/grit
	name = "heavy buckshot"
	range_step = 1

/obj/item/projectile/bullet/pellet/heavy_shotgun/grit/on_hit(var/atom/movable/target, var/blocked = 0)
	if(isliving(target))
		var/mob/living/L = target
		var/throwdir = get_dir(firer,L)
		if(prob(10) && !blocked)
			L.Stun(1)
			L.Confuse(1)
		L.throw_at_old(get_edge_target_turf(L, throwdir), rand(3,6), 10)

		return 1

/* Incendiary */

/obj/item/projectile/bullet/incendiary
	name = "incendiary bullet"
	icon_state = "bullet_alt"
	damage = 15
	damage_type = BURN
	incendiary = 1
	flammability = 2

/obj/item/projectile/bullet/incendiary/shotgun
	name = "dragonsbreath pellet"
	icon_state = "bullet_alt"
	damage = 10
	damage_type = BURN
	incendiary = 1
	flammability = 2

/obj/item/projectile/bullet/incendiary/flamethrower
	name = "ball of fire"
	desc = "Don't stand in the fire."
	icon_state = "fireball"
	damage = 10
	embed_chance = 0
	incendiary = 2
	flammability = 4
	agony = 30
	range = 4
	vacuum_traversal = 0

/obj/item/projectile/bullet/incendiary/flamethrower/large
	damage = 15
	range = 6

/* Practice rounds and blanks */

/obj/item/projectile/bullet/practice
	damage = 5

/obj/item/projectile/bullet/pistol/cap // Just the primer, such as a cap gun.
	name = "cap"
	damage_type = HALLOSS
	fire_sound = 'sound/effects/snap.ogg'
	damage = 0
	nodamage = 1
	embed_chance = 0
	sharp = 0

	combustion = FALSE

/obj/item/projectile/bullet/pistol/cap/process(delta_time)
	loc = null
	qdel(src)

/obj/item/projectile/bullet/blank
	name = "blank"
	damage_type = HALLOSS
	fire_sound = 'sound/weapons/weaponsounds_rifleshot.ogg' // Blanks still make loud noises.
	damage = 0
	nodamage = 1
	embed_chance = 0
	sharp = 0

/obj/item/projectile/bullet/blank/cap/process(delta_time)
	loc = null
	qdel(src)
