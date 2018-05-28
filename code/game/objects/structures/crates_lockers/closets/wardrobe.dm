<<<<<<< HEAD
/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/red/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/sec(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security2(src)
	new /obj/item/clothing/under/rank/security2(src)
	new /obj/item/clothing/under/rank/security2(src)
	new /obj/item/clothing/under/rank/security/skirt(src)
	new /obj/item/clothing/under/rank/security/skirt(src)
	new /obj/item/clothing/shoes/boots/jackboots(src)
	new /obj/item/clothing/shoes/boots/jackboots(src)
	new /obj/item/clothing/shoes/boots/jackboots(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/security(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/security(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/security(src)
	new /obj/item/clothing/accessory/armband(src)
	new /obj/item/clothing/accessory/armband(src)
	new /obj/item/clothing/accessory/armband(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	return


/obj/structure/closet/wardrobe/detective
	name = "detective wardrobe"
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/structure/closet/wardrobe/detective/New()
	..()
	new /obj/item/clothing/head/det(src)
	new /obj/item/clothing/head/det(src)
	new /obj/item/clothing/head/det/grey(src)
	new /obj/item/clothing/head/det/grey(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/under/det(src)
	new /obj/item/clothing/under/det(src)
	new /obj/item/clothing/under/det/waistcoat(src)
	new /obj/item/clothing/under/det/waistcoat(src)
	new /obj/item/clothing/under/det/grey(src)
	new /obj/item/clothing/under/det/grey(src)
	new /obj/item/clothing/under/det/grey/waistcoat(src)
	new /obj/item/clothing/under/det/grey/waistcoat(src)
	new /obj/item/clothing/under/det/black(src)
	new /obj/item/clothing/under/det/black(src)
	new /obj/item/clothing/under/det/skirt(src)
	new /obj/item/clothing/under/det/corporate(src)
	new /obj/item/clothing/under/det/corporate(src)
	new /obj/item/clothing/suit/storage/det_trench(src)
	new /obj/item/clothing/suit/storage/det_trench(src)
	new /obj/item/clothing/suit/storage/det_trench/grey(src)
	new /obj/item/clothing/suit/storage/det_trench/grey(src)
	new /obj/item/clothing/suit/storage/forensics/blue(src)
	new /obj/item/clothing/suit/storage/forensics/blue(src)
	new /obj/item/clothing/suit/storage/forensics/red(src)
	new /obj/item/clothing/suit/storage/forensics/red(src)
	return

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

/obj/structure/closet/wardrobe/pink/New()
	..()
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	return

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/black/New()
	..()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/mask/bandana(src)
	new /obj/item/clothing/mask/bandana(src)
	new /obj/item/clothing/mask/bandana(src)
	new /obj/item/weapon/storage/backpack/messenger/black(src)
	return


/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/chaplain_black/New()
	..()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/storage/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/clothing/under/wedding/bride_white(src)
	new /obj/item/weapon/storage/backpack/cultpack (src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/deck/tarot(src)
	return


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/green/New()
	..()
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/shoes/green(src)
	new /obj/item/clothing/shoes/green(src)
	new /obj/item/clothing/shoes/green(src)
	new /obj/item/clothing/head/soft/green(src)
	new /obj/item/clothing/head/soft/green(src)
	new /obj/item/clothing/head/soft/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	return

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/xenos/New()
	..()
	new /obj/item/clothing/suit/unathi/mantle(src)
	new /obj/item/clothing/suit/unathi/robe(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/footwraps(src)
	new /obj/item/clothing/shoes/footwraps(src)
	new /obj/item/clothing/shoes/boots/winter(src)
	new /obj/item/clothing/shoes/boots/winter(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat(src)
	return


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/wardrobe/orange/New()
	..()
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	return


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/yellow/New()
	..()
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/shoes/yellow(src)
	new /obj/item/clothing/shoes/yellow(src)
	new /obj/item/clothing/shoes/yellow(src)
	new /obj/item/clothing/head/soft/yellow(src)
	new /obj/item/clothing/head/soft/yellow(src)
	new /obj/item/clothing/head/soft/yellow(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	return


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow/New()
	..()
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician/skirt(src)
	new /obj/item/clothing/under/rank/atmospheric_technician/skirt(src)
	new /obj/item/clothing/under/rank/atmospheric_technician/skirt(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos(src)
	new /obj/item/clothing/shoes/boots/winter/atmos(src)
	new /obj/item/clothing/shoes/boots/winter/atmos(src)
	new /obj/item/clothing/shoes/boots/winter/atmos(src)
	return

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/New()
	..()
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer/skirt(src)
	new /obj/item/clothing/under/rank/engineer/skirt(src)
	new /obj/item/clothing/under/rank/engineer/skirt(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering(src)
	new /obj/item/clothing/shoes/boots/winter/engineering(src)
	new /obj/item/clothing/shoes/boots/winter/engineering(src)
	new /obj/item/clothing/shoes/boots/winter/engineering(src)
	new /obj/item/clothing/shoes/boots/workboots(src)
	new /obj/item/clothing/shoes/boots/workboots(src)
	new /obj/item/clothing/shoes/boots/workboots(src)
	return


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/white/New()
	..()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/clothing/head/soft/mime(src)
	return


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/pjs/New()
	..()
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	return


/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/science_white/New()
	..()
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist/skirt(src)
	new /obj/item/clothing/under/rank/scientist/skirt(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/science(src)
	new /obj/item/clothing/shoes/boots/winter/science(src)
	new /obj/item/weapon/storage/backpack/toxins(src)
	new /obj/item/weapon/storage/backpack/satchel/tox(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sci(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/tox(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sci(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/tox(src)
/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/robotics_black/New()
	..()
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/weapon/storage/backpack/toxins(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sci(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/tox(src)
	new /obj/item/weapon/storage/backpack/satchel/tox(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sci(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/tox(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/chemistry_white/New()
	..()
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/under/rank/chemist/skirt(src)
	new /obj/item/clothing/under/rank/chemist/skirt(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(src)
	new /obj/item/weapon/storage/backpack/chemistry(src)
	new /obj/item/weapon/storage/backpack/chemistry(src)
	new /obj/item/weapon/storage/backpack/satchel/chem(src)
	new /obj/item/weapon/storage/backpack/satchel/chem(src)
	new /obj/item/weapon/storage/bag/chemistry(src)
	new /obj/item/weapon/storage/bag/chemistry(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white/New()
	..()
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist/skirt(src)
	new /obj/item/clothing/under/rank/geneticist/skirt(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)
	new /obj/item/weapon/storage/backpack/genetics(src)
	new /obj/item/weapon/storage/backpack/genetics(src)
	new /obj/item/weapon/storage/backpack/satchel/gen(src)
	new /obj/item/weapon/storage/backpack/satchel/gen(src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/virology_white/New()
	..()
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist/skirt(src)
	new /obj/item/clothing/under/rank/virologist/skirt(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/weapon/storage/backpack/virology(src)
	new /obj/item/weapon/storage/backpack/virology(src)
	new /obj/item/weapon/storage/backpack/satchel/vir(src)
	new /obj/item/weapon/storage/backpack/satchel/vir(src)
	return


/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medic_white/New()
	..()
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical/skirt(src)
	new /obj/item/clothing/under/rank/medical/skirt(src)
	new /obj/item/clothing/under/rank/medical/scrubs(src)
	new /obj/item/clothing/under/rank/medical/scrubs/green(src)
	new /obj/item/clothing/under/rank/medical/scrubs/purple(src)
	new /obj/item/clothing/under/rank/medical/scrubs/black(src)
	new /obj/item/clothing/under/rank/medical/scrubs/navyblue(src)
	new /obj/item/clothing/head/surgery/navyblue(src)
	new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/head/surgery/blue(src)
	new /obj/item/clothing/head/surgery/green(src)
	new /obj/item/clothing/head/surgery/black(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/medical(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/medical(src)
	new /obj/item/clothing/shoes/boots/winter/medical(src)
	new /obj/item/clothing/shoes/boots/winter/medical(src)
	return


/obj/structure/closet/wardrobe/medic_gown
	name = "cloning wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medic_gown/New()
	..()
	new /obj/item/clothing/under/medigown(src)
	new /obj/item/clothing/under/medigown(src)
	new /obj/item/clothing/under/medigown(src)
	new /obj/item/clothing/under/medigown(src)
	return


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/grey/New()
	..()
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	return


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/mixed/New()
	..()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/skirt/outfit/plaid_blue(src)
	new /obj/item/clothing/under/skirt/outfit/plaid_red(src)
	new /obj/item/clothing/under/skirt/outfit/plaid_purple(src)
	new /obj/item/clothing/shoes/blue(src)
	new /obj/item/clothing/shoes/yellow(src)
	new /obj/item/clothing/shoes/green(src)
	new /obj/item/clothing/shoes/purple(src)
	new /obj/item/clothing/shoes/red(src)
	new /obj/item/clothing/shoes/leather(src)
	new /obj/item/clothing/under/pants/classicjeans(src)
	new /obj/item/clothing/under/pants/mustangjeans(src)
	new /obj/item/clothing/under/pants/blackjeans(src)
	new /obj/item/clothing/under/pants/youngfolksjeans(src)
	new /obj/item/clothing/under/pants/white(src)
	new /obj/item/clothing/under/pants/red(src)
	new /obj/item/clothing/under/pants/black(src)
	new /obj/item/clothing/under/pants/tan(src)
	new /obj/item/clothing/under/pants/track(src)
	new /obj/item/clothing/suit/storage/toggle/track(src)
	new /obj/item/clothing/under/pants(src)
	new /obj/item/clothing/under/pants/khaki(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/accessory/hawaii(src)
	new /obj/item/clothing/accessory/hawaii/random(src)
	return

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/wardrobe/tactical/New()
	..()
	new /obj/item/clothing/under/tactical(src)
	new /obj/item/clothing/suit/armor/tactical(src)
	new /obj/item/clothing/head/helmet/tactical(src)
	new /obj/item/clothing/mask/balaclava/tactical(src)
	new /obj/item/clothing/mask/balaclava(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/tactical(src)
	if(prob(25))
		new /obj/item/weapon/storage/belt/security/tactical/bandolier(src)
	else
		new /obj/item/weapon/storage/belt/security/tactical(src)
	if(prob(10))
		new /obj/item/clothing/mask/bandana/skull(src)
	new /obj/item/clothing/shoes/boots/jackboots(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/under/pants/camo(src)
	return

/obj/structure/closet/wardrobe/ert
	name = "emergency response team equipment"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/wardrobe/ert/New()
	..()
	new /obj/item/clothing/under/rank/centcom(src)
	new /obj/item/clothing/under/ert(src)
	new /obj/item/clothing/under/syndicate/combat(src)
	new /obj/item/device/radio/headset/ert/alt(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/shoes/boots/swat(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/mask/balaclava/tactical(src)
	new /obj/item/clothing/mask/balaclava(src)
	new /obj/item/clothing/mask/bandana/skull(src)
	new /obj/item/clothing/mask/bandana/skull(src)
	return

/obj/structure/closet/wardrobe/suit
	name = "suit locker"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/suit/New()
	..()
	new /obj/item/clothing/under/assistantformal(src)
	new /obj/item/clothing/under/suit_jacket/charcoal(src)
	new /obj/item/clothing/under/suit_jacket/charcoal/skirt(src)
	new /obj/item/clothing/under/suit_jacket/navy(src)
	new /obj/item/clothing/under/suit_jacket/navy/skirt(src)
	new /obj/item/clothing/under/suit_jacket/burgundy(src)
	new /obj/item/clothing/under/suit_jacket/burgundy/skirt(src)
	new /obj/item/clothing/under/suit_jacket/checkered(src)
	new /obj/item/clothing/under/suit_jacket/checkered/skirt(src)
	new /obj/item/clothing/under/suit_jacket/tan(src)
	new /obj/item/clothing/under/suit_jacket/tan/skirt(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/suit_jacket(src)
	new /obj/item/clothing/under/suit_jacket/female(src)
	new /obj/item/clothing/under/suit_jacket/female/skirt(src)
	new /obj/item/clothing/under/suit_jacket/really_black(src)
	new /obj/item/clothing/under/suit_jacket/really_black/skirt(src)
	new /obj/item/clothing/under/suit_jacket/red(src)
	new /obj/item/clothing/under/suit_jacket/red/skirt(src)
	new /obj/item/clothing/under/scratch(src)
	new /obj/item/clothing/under/scratch/skirt(src)
	new /obj/item/weapon/storage/backpack/satchel(src)
	new /obj/item/weapon/storage/backpack/satchel(src)
	return

/obj/structure/closet/wardrobe/captain
	name = "colony director's wardrobe"
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/structure/closet/wardrobe/captain/New()
	..()
	new /obj/item/weapon/storage/backpack/captain(src)
	new /obj/item/clothing/suit/captunic(src)
	new /obj/item/clothing/suit/captunic/capjacket(src)
	new /obj/item/clothing/head/caphat/cap(src)
	new /obj/item/clothing/under/rank/captain(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/gloves/captain(src)
	new /obj/item/clothing/under/dress/dress_cap(src)
	new /obj/item/weapon/storage/backpack/satchel/cap(src)
	new /obj/item/clothing/head/caphat/formal(src)
	new /obj/item/clothing/under/captainformal(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/captain(src)
	new /obj/item/clothing/shoes/boots/winter/command(src)
	new /obj/item/clothing/head/beret/centcom/captain(src)
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src)
	new /obj/item/clothing/under/gimmick/rank/captain/suit/skirt(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/caphat(src)
	return
=======
/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "red"
	icon_closed = "red"

	starts_with = list(
		/obj/item/clothing/under/rank/security = 3,
		/obj/item/clothing/under/rank/security2 = 3,
		/obj/item/clothing/under/rank/security/skirt = 2,
		/obj/item/clothing/shoes/boots/jackboots = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/head/beret/sec/corporate/officer = 3,
		/obj/item/clothing/mask/bandana/red = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3,
		/obj/item/clothing/accessory/armband = 3,
		/obj/item/clothing/accessory/holster/waist = 3)

/obj/structure/closet/wardrobe/red/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/security
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/sec

	return ..()

/obj/structure/closet/wardrobe/detective
	name = "detective wardrobe"
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

	starts_with = list(
		/obj/item/clothing/head/det = 2,
		/obj/item/clothing/head/det/grey = 2,
		/obj/item/clothing/shoes/brown = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/under/det = 2,
		/obj/item/clothing/under/det/waistcoat = 2,
		/obj/item/clothing/under/det/grey = 2,
		/obj/item/clothing/under/det/grey/waistcoat = 2,
		/obj/item/clothing/under/det/black = 2,
		/obj/item/clothing/under/det/skirt,
		/obj/item/clothing/under/det/corporate = 2,
		/obj/item/clothing/suit/storage/det_trench = 2,
		/obj/item/clothing/suit/storage/det_trench/grey = 2,
		/obj/item/clothing/suit/storage/forensics/blue = 2,
		/obj/item/clothing/suit/storage/forensics/red = 2)

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

	starts_with = list(
		/obj/item/clothing/under/color/pink = 3,
		/obj/item/clothing/shoes/brown = 3)

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/color/black = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/that = 3,
		/obj/item/clothing/head/soft/black = 3,
		/obj/item/clothing/mask/bandana = 3,
		/obj/item/weapon/storage/backpack/messenger/black)


/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/nun,
		/obj/item/clothing/head/nun_hood,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/weapon/storage/backpack/cultpack,
		/obj/item/weapon/storage/fancy/candle_box = 2,
		/obj/item/weapon/deck/tarot)


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

	starts_with = list(
		/obj/item/clothing/under/color/green = 3,
		/obj/item/clothing/shoes/green = 3,
		/obj/item/clothing/head/soft/green = 3,
		/obj/item/clothing/mask/bandana/green = 3)

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	icon_state = "green"
	icon_closed = "green"

	starts_with = list(
		/obj/item/clothing/suit/unathi/mantle,
		/obj/item/clothing/suit/unathi/robe,
		/obj/item/clothing/shoes/sandal = 2,
		/obj/item/clothing/shoes/footwraps = 2,
		/obj/item/clothing/shoes/boots/winter = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat = 2)


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	icon_state = "orange"
	icon_closed = "orange"

	starts_with = list(
		/obj/item/clothing/under/color/orange = 3,
		/obj/item/clothing/shoes/orange = 3)


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

	starts_with = list(
		/obj/item/clothing/under/color/yellow = 3,
		/obj/item/clothing/shoes/yellow = 3,
		/obj/item/clothing/head/soft/yellow = 3,
		/obj/item/clothing/mask/bandana/gold = 3)


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

	starts_with = list(
		/obj/item/clothing/under/rank/atmospheric_technician = 3,
		/obj/item/clothing/under/rank/atmospheric_technician/skirt = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/hardhat/red = 3,
		/obj/item/clothing/head/beret/engineering = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/shoes/boots/winter/atmos = 3)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

	starts_with = list(
		/obj/item/clothing/under/rank/engineer = 3,
		/obj/item/clothing/under/rank/engineer/skirt = 3,
		/obj/item/clothing/shoes/orange = 3,
		/obj/item/clothing/head/hardhat = 3,
		/obj/item/clothing/head/beret/engineering = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering = 3,
		/obj/item/clothing/shoes/boots/winter/engineering = 3,
		/obj/item/clothing/shoes/boots/workboots = 3)


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"
	
	starts_with = list(
		/obj/item/clothing/under/color/white = 3,
		/obj/item/clothing/shoes/white = 3,
		/obj/item/clothing/head/soft/mime = 3)


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/pj/red = 2,
		/obj/item/clothing/under/pj/blue = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/shoes/slippers = 2)


/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/scientist = 3,
		/obj/item/clothing/under/rank/scientist/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 3,
		/obj/item/clothing/shoes/white = 3,
		/obj/item/clothing/shoes/slippers = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/shoes/boots/winter/science,
		/obj/item/weapon/storage/backpack/toxins,
		/obj/item/weapon/storage/backpack/satchel/tox)

/obj/structure/closet/wardrobe/science_white/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/tox
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/tox

	return ..()


/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/rank/roboticist = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/gloves/black = 2,
		/obj/item/weapon/storage/backpack/toxins,
		/obj/item/weapon/storage/backpack/satchel/tox)

/obj/structure/closet/wardrobe/robotics_black/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/tox
	
	return ..()


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/chemist = 2,
		/obj/item/clothing/under/rank/chemist/skirt = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist = 2,
		/obj/item/weapon/storage/backpack/chemistry = 2,
		/obj/item/weapon/storage/backpack/satchel/chem = 2,
		/obj/item/weapon/storage/bag/chemistry = 2,)


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/geneticist = 2,
		/obj/item/clothing/under/rank/geneticist/skirt = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/genetics = 2,
		/obj/item/weapon/storage/backpack/genetics = 2,
		/obj/item/weapon/storage/backpack/satchel/gen = 2)


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/virologist = 2,
		/obj/item/clothing/under/rank/virologist/skirt = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist = 2,
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/weapon/storage/backpack/virology = 2,
		/obj/item/weapon/storage/backpack/satchel/vir = 2)


/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/medical = 2,
		/obj/item/clothing/under/rank/medical/skirt = 2,
		/obj/item/clothing/under/rank/medical/scrubs,
		/obj/item/clothing/under/rank/medical/scrubs/green,
		/obj/item/clothing/under/rank/medical/scrubs/purple,
		/obj/item/clothing/under/rank/medical/scrubs/black,
		/obj/item/clothing/under/rank/medical/scrubs/navyblue,
		/obj/item/clothing/head/surgery/navyblue,
		/obj/item/clothing/head/surgery/purple,
		/obj/item/clothing/head/surgery/blue,
		/obj/item/clothing/head/surgery/green,
		/obj/item/clothing/head/surgery/black,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 2,
		/obj/item/clothing/shoes/boots/winter/medical = 2)


/obj/structure/closet/wardrobe/medic_gown
	name = "cloning wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/medigown = 4)


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"
	
	starts_with = list(
		/obj/item/clothing/under/color/grey = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/soft/grey = 3)
		

/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

	starts_with = list(
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/skirt/outfit/plaid_blue,
		/obj/item/clothing/under/skirt/outfit/plaid_red,
		/obj/item/clothing/under/skirt/outfit/plaid_purple,
		/obj/item/clothing/shoes/blue,
		/obj/item/clothing/shoes/yellow,
		/obj/item/clothing/shoes/green,
		/obj/item/clothing/shoes/purple,
		/obj/item/clothing/shoes/red,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/under/pants/classicjeans,
		/obj/item/clothing/under/pants/mustangjeans,
		/obj/item/clothing/under/pants/blackjeans,
		/obj/item/clothing/under/pants/youngfolksjeans,
		/obj/item/clothing/under/pants/white,
		/obj/item/clothing/under/pants/red,
		/obj/item/clothing/under/pants/black,
		/obj/item/clothing/under/pants/tan,
		/obj/item/clothing/under/pants/track,
		/obj/item/clothing/suit/storage/toggle/track,
		/obj/item/clothing/under/pants,
		/obj/item/clothing/under/pants/khaki,
		/obj/item/clothing/mask/bandana/blue,
		/obj/item/clothing/mask/bandana/blue,
		/obj/item/clothing/accessory/hawaii,
		/obj/item/clothing/accessory/hawaii/random)


/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/suit/armor/tactical,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/under/pants/camo)

/obj/structure/closet/wardrobe/tactical/initialize()
	if(prob(25))
		starts_with += /obj/item/weapon/storage/belt/security/tactical/bandolier
	else
		starts_with += /obj/item/weapon/storage/belt/security/tactical
	if(prob(10))
		starts_with += /obj/item/clothing/mask/bandana/skull

	return ..()

/obj/structure/closet/wardrobe/ert
	name = "emergency response team equipment"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/under/rank/centcom,
		/obj/item/clothing/under/ert,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/device/radio/headset/ert/alt,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/shoes/boots/swat,
		/obj/item/clothing/gloves/swat,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/mask/bandana/skull = 2)


/obj/structure/closet/wardrobe/suit
	name = "suit locker"
	icon_state = "mixed"
	icon_closed = "mixed"

	starts_with = list(
		/obj/item/clothing/under/assistantformal,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/charcoal/skirt,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/navy/skirt,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket/burgundy/skirt,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/checkered/skirt,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/suit_jacket/tan/skirt,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/female,
		/obj/item/clothing/under/suit_jacket/female/skirt,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/really_black/skirt,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/suit_jacket/red/skirt,
		/obj/item/clothing/under/scratch,
		/obj/item/clothing/under/scratch/skirt,
		/obj/item/weapon/storage/backpack/satchel = 2)

/obj/structure/closet/wardrobe/captain
	name = "colony director's wardrobe"
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

	starts_with = list(
		/obj/item/weapon/storage/backpack/captain,
		/obj/item/clothing/suit/captunic,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/head/caphat/cap,
		/obj/item/clothing/under/rank/captain,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/gloves/captain,
		/obj/item/clothing/under/dress/dress_cap,
		/obj/item/weapon/storage/backpack/satchel/cap,
		/obj/item/clothing/head/caphat/formal,
		/obj/item/clothing/under/captainformal,
		/obj/item/clothing/suit/storage/hooded/wintercoat/captain,
		/obj/item/clothing/shoes/boots/winter/command,
		/obj/item/clothing/head/beret/centcom/captain,
		/obj/item/clothing/under/gimmick/rank/captain/suit,
		/obj/item/clothing/under/gimmick/rank/captain/suit/skirt,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/head/caphat)
>>>>>>> 787102a... Merge pull request #3776 from VOREStation/aro-sync-05-27-2018
