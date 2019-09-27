/obj/item/weapon/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"

	var/starting_material = "composite"
	var/list/rod_quantitites



	var/material_name

	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type = "composite"
	var/fuel_colour
	var/radioactivity = 0
	var/const/initial_amount = 300

/obj/item/weapon/fuel_assembly/Initialize(mapload, _material, _colour)
	fuel_colour = _colour
	var/primary_material = _material || starting_material
	rod_quantitites = list()
	var/datum/material/M = get_material_by_name(primary_material)
	if(istype(M))
		name = "[M.use_name] fuel rod assembly"
		name = "[material.use_name] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [M.use_name]."
		fuel_colour = material.icon_colour
		fuel_type = material.id
		if(M.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			processing_objects += src
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.icon_colour)
	else
		name = "[M] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [fuel_type]."

	icon_state = "blank"
	var/image/I = image(icon, "fuel_assembly")
	I.color = fuel_colour
	overlays += list(I, image(icon, "fuel_assembly_bracket"))
	rod_quantities[fuel_type] = initial_amount

/obj/item/weapon/fuel_assembly/process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		radiation_repository.radiate(src, max(1,CEILING(radioactivity/30, 1)))

/obj/item/weapon/fuel_assembly/Destroy()
	processing_objects -= src
	return ..()

// Mapper shorthand.
/obj/item/weapon/fuel_assembly/deuterium
	starting_material = MATERIAL_ID_DEUTERIUM

/obj/item/weapon/fuel_assembly/tritium
	starting_material = MATERIAL_ID_TRITIUM

/obj/item/weapon/fuel_assembly/phoron
	starting_material = MATERIAL_ID_PHORON

/obj/item/weapon/fuel_assembly/supermatter
	starting_material = MATERIAL_ID_SUPERMATTER
