//This will likely drive me insane, but fuck it. Let's give it a shot. -k22
//This was heavily assisted by MoondancerPony

//no wonder moondancer got gitbanned lmao

/obj/item/gun/energy/modular
	name = "modular weapon"
	desc = "This object should never exist. Contact your God, the Maker has made a mistake."
	icon_state = "mod_pistol"
	cell_type = /obj/item/cell/device/weapon
	charge_cost = 120
	var/cores = 1//How many lasing cores can we support?
	var/assembled = 1 //Are we open?
	var/obj/item/modularlaser/lasermedium/primarycore //Lasing medium core.
	var/obj/item/modularlaser/lasermedium/secondarycore //Lasing medium core.
	var/obj/item/modularlaser/lasermedium/tertiarycore //Lasing medium core.
	var/obj/item/modularlaser/lens/laserlens //Lens. Dictates accuracy. Certain lenses change the projectiles to ENERGY SHOTGUN.
	var/obj/item/modularlaser/capacitor/lasercap
	var/obj/item/modularlaser/cooling/lasercooler
	var/obj/item/modularlaser/controller/circuit

	var/emp_vuln = TRUE

/obj/item/gun/energy/modular/proc/updategun() //Accepts no args. Checks the gun's current components and generates projectile types, firemode costs and max burst. Should be called after changing parts or part values.
	if(!circuit || !primarycore || !laserlens || !lasercap || !laserceooler)
		return FALSE //cannot work
	var/burstmode = circuit.burstmax //Max burst controlled by the laser control circuit.
	var/beammode = primarycore.beamtype //Primary mode fire type.
	var/chargecost = primarycore.beamcost * lasercap.costmod //Cost for primary fire.
	chargecost += lasercooler.costadd //Cooler adds a flat amount post capacitor based on firedelay mod. Can be negative.
	var/scatter = laserlens.scatter //Does it scatter the beams?
	fire_delay = lasercap.firedelay * lasercooler.delaymod //Firedelay caculated by the capacitor and the laser cooler.
	burst_delay = circuit.burst_delay * lasercooler.delaymod //Ditto but with burst delay.
	if(secondarycore) //Secondary firemode
		var/beammode_lethal = secondarycore.beamtype
		var/chargecost_lethal = secondarycore.beamcost * lasercap.costmod
		chargecost_lethal += lasercooler.costadd
	if(teriarycore) //Tertiary firemode
		var/beammode_special = teriarycore.beamtype
		var/chargecost_special = tertiarycore.beamcost * lasercap.costmod
		chargecost_special += lasercooler.costadd
	var/maxburst = circuit.maxburst //Max burst.
	emp_vuln = circuit.robust //is the circuit strong enough to dissipate EMPs?
	switch(cores)
		if("1") //this makes me sick but ill ask if there's a better way to do this
			if(scatter)
				beammode = primarycore.scatterbeam
			if(maxburst > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list("mode_name=[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst))
					)
				return TRUE
			firemodes = list(
					new /datum/firemode(src, list(mode_name="stun", projectile_type=beammode, charge_cost = chargecost))
					)
			return TRUE
		if("2")
			if(scatter)
				beammode = primarycore.scatterbeam
				beammode_lethal = secondarycore.scatterbeam
			if(maxburst > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost*maxburst, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal*maxburst, burst = maxburst))
					)
				return TRUE
			firemodes = list(
					new /datum/firemode(src, list(mode_name="stun", projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal))
					)
			return TRUE
		if("3")
			if(scatter)
				beammode = primarycore.scatterbeam
				beammode_lethal = secondarycore.scatterbeam
				beammode_special = tertiarycore.scatterbeam

			if(maxburst > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
					new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost*maxburst, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal*maxburst, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [tertiarycore.firename]", projectile_type=beammode_special, charge_cost = chargecost_special*maxburst, burst = maxburst))
					)
				return TRUE
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
				new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special)),
				)
			return TRUE

/obj/item/gun/energy/modular/emp_act(severity)
	if(!emp_vuln)
		return FALSE
	return ..()
