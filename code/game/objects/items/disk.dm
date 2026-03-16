/**
 * Common type for disks of all type. You're probably looking for a subtype.
 */
/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound =  'sound/items/pickup/disk.ogg'

/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL

///Disk stuff.
///The return of data disks?? Just for transferring between genetics machine/cloning machine.
///TODO: Make the genetics machine accept them.
/obj/item/disk/data
	name = "Cloning Data Disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL

	var/datum/dna2/record/buf = null
	var/read_only = 0 //Well,it's still a floppy disk

/obj/item/disk/data/Initialize(mapload)
	. = ..()
	var/diskcolor = pick(0,1,2)
	icon_state = "datadisk[diskcolor]"

/obj/item/disk/data/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	read_only = !read_only
	to_chat(user, "You flip the write-protect tab to [read_only ? "protected" : "unprotected"].")

/obj/item/disk/data/examine(mob/user, dist)
	. = ..()
	. += "<span class = 'notice'>The write-protect tab is set to [read_only ? "protected" : "unprotected"].</span>"

/obj/item/disk/data/proc/initializeDisk()
	buf = new
	buf.dna=new

/obj/item/disk/data/demo
	name = "data disk - 'God Emperor of Mankind'"
	read_only = 1

/obj/item/disk/data/demo/Initialize(mapload)
	. = ..()
	initializeDisk()
	buf.types=DNA2_BUF_UE|DNA2_BUF_UI
	//data = "066000033000000000AF00330660FF4DB002690"
	//data = "0C80C80C80C80C80C8000000000000161FBDDEF" - Farmer Jeff
	buf.dna.real_name="God Emperor of Mankind"
	buf.dna.unique_enzymes = md5(buf.dna.real_name)
	buf.dna.UI=list(0x066,0x000,0x033,0x000,0x000,0x000,0xAF0,0x033,0x066,0x0FF,0x4DB,0x002,0x690)
	//buf.dna.UI=list(0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x000,0x000,0x000,0x000,0x161,0xFBD,0xDEF) // Farmer Jeff
	buf.dna.UpdateUI()

/obj/item/disk/data/monkey
	name = "data disk - 'Mr. Muggles'"
	read_only = 1

/obj/item/disk/data/monkey/Initialize(mapload)
	. = ..()
	buf.types=DNA2_BUF_SE
	var/list/new_SE=list(0x098,0x3E8,0x403,0x44C,0x39F,0x4B0,0x59D,0x514,0x5FC,0x578,0x5DC,0x640,0x6A4)
	for(var/i=new_SE.len;i<=DNA_SE_LENGTH;i++)
		new_SE += rand(1,1024)
	buf.dna.SE=new_SE
	buf.dna.SetSEValueRange(DNABLOCK_MONKEY,0xDAC, 0xFFF)
