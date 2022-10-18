/datum/asset/simple/namespaced/chem_master
	keep_local_name = TRUE

/datum/asset/simple/namespaced/chem_master/register()
	for(var/i = 1 to 24)
		assets["pill[i].png"] = icon('icons/obj/chemical.dmi', "pill[i]")

	for(var/i = 1 to 4)
		assets["bottle-[i].png"] = icon('icons/obj/chemical.dmi', "bottle-[i]")

	return ..()

/*
/datum/asset/spritesheet/simple/pills
	name = "pills"
	assets = list(
		"pill1" = 'icons/ui/pills/pill1.png',
		"pill2" = 'icons/ui/pills/pill2.png',
		"pill3" = 'icons/ui/pills/pill3.png',
		"pill4" = 'icons/ui/pills/pill4.png',
		"pill5" = 'icons/ui/pills/pill5.png',
		"pill6" = 'icons/ui/pills/pill6.png',
		"pill7" = 'icons/ui/pills/pill7.png',
		"pill8" = 'icons/ui/pills/pill8.png',
		"pill9" = 'icons/ui/pills/pill9.png',
		"pill10" = 'icons/ui/pills/pill10.png',
		"pill11" = 'icons/ui/pills/pill11.png',
		"pill12" = 'icons/ui/pills/pill12.png',
		"pill13" = 'icons/ui/pills/pill13.png',
		"pill14" = 'icons/ui/pills/pill14.png',
		"pill15" = 'icons/ui/pills/pill15.png',
		"pill16" = 'icons/ui/pills/pill16.png',
		"pill17" = 'icons/ui/pills/pill17.png',
		"pill18" = 'icons/ui/pills/pill18.png',
		"pill19" = 'icons/ui/pills/pill19.png',
		"pill20" = 'icons/ui/pills/pill20.png',
		"pill21" = 'icons/ui/pills/pill21.png',
		"pill22" = 'icons/ui/pills/pill22.png',
	)
*/
