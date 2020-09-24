//////////////////////////////////////////////////
//Lenses
///////////////////////////////////////////////////

/obj/item/modularlaser/lens
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/scatter = FALSE
	var/accuracy = 0

/obj/item/modularlaser/lens/basic
	name = "basic modular lens"
	desc = "A basic lens with no drawbacks or upsides."

/obj/item/modularlaser/lens/lame
	name = "weaksauce modular lens"
	desc = "A shitty lens with drawbacks."
	accuracy = -5

/obj/item/modularlaser/lens/lame/integral
	name = "weaksauce integral modular lens"
	removable = FALSE

/obj/item/modularlaser/lens/advanced
	name = "advanced modular lens"
	desc = "An advanced metamaterial lens that focuses beams more accurately."
	accuracy = 15 //1 tile closer
	scatter = FALSE

/obj/item/modularlaser/lens/super
	name = "metamaterial modular lens"
	desc = "An advanced metamaterial lens that focuses beams extremely accurately."
	accuracy = 30 //2 tiles closer

/obj/item/modularlaser/lens/admin //badmin only
	name = "nanomachined modular lens"
	desc = "A swarm of transparent nanites that causes your beams to hit always, 100% of time time or your money back."
	accuracy = 225 //you shouldn't miss

/obj/item/modularlaser/lens/scatter
	name = "refracting modular lens"
	desc = "A simple glass lens that splits beams on contact. Very hard to aim with."
	scatter = TRUE
	accuracy = -60 //4 tiles further

/obj/item/modularlaser/lens/scatter/adv
	name = "advanced refracting modular lens"
	desc = "A well-machined glass lens that splits beams on contact. Hard to aim with."
	accuracy = -45 //3 tiles further

/obj/item/modularlaser/lens/scatter/super
	name = "metamaterial refracting modular lens"
	desc = "An advanced metamaterial lens that splits beams. Somewhat hard to aim with."
	accuracy = -15 //1 tile further

/obj/item/modularlaser/lens/scatter/hyper //VERY expensive. Precursor tech only.
	name = "supermaterial refracting modular lens"
	desc = "A bleeding-edge metamaterial lens that splits beams."
	accuracy = 0

/obj/item/modularlaser/lens/scatter/hyper/integral
	removable = FALSE

/obj/item/modularlaser/lens/scatter/admin
	name = "nanomachined refracting modular lens"
	desc = "An advanced nanomachined lens that splits beams."
	accuracy = 225 //100% of shots should land.
