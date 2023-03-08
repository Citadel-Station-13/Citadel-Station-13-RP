/obj/item/clothing/head/centhat
	name = "\improper CentCom. hat"
	icon_state = "centcom"
	desc = "It's good to be emperor."
	siemens_coefficient = 0.9
	body_cover_flags = 0

/obj/item/clothing/head/centhat/customs
	name = "Customs Hat"
	desc = "A formal hat for OriCon Customs Officers."
	icon_state = "customshat"

/obj/item/clothing/head/pin
	icon_state = "pin"
	addblends = "pin_a"
	name = "hair pin"
	desc = "A nice hair pin."
	slot_flags = SLOT_HEAD | SLOT_EARS
	body_cover_flags = 0
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/head/pin/pink
	icon_state = "pinkpin"
	addblends = null
	name = "pink hair hat"

/obj/item/clothing/head/pin/clover
	icon_state = "cloverpin"
	name = "clover pin"
	addblends = null
	desc = "A hair pin in the shape of a clover leaf."

/obj/item/clothing/head/pin/butterfly
	icon_state = "butterflypin"
	name = "butterfly pin"
	addblends = null
	desc = "A hair pin in the shape of a bright blue butterfly."

/obj/item/clothing/head/pin/magnetic
	icon_state = "magnetpin"
	name = "magnetic 'pin'"
	addblends = null
	desc = "Finally, a hair pin even a Morpheus chassis can use."
	matter = list(MAT_STEEL = 10)

/obj/item/clothing/head/pin/flower
	name = "red flower pin"
	icon_state = "hairflower"
	addblends = null
	desc = "Smells nice."

/obj/item/clothing/head/pin/flower/blue
	icon_state = "hairflower_blue"
	name = "blue flower pin"

/obj/item/clothing/head/pin/flower/pink
	icon_state = "hairflower_pink"
	name = "pink flower pin"

/obj/item/clothing/head/pin/flower/yellow
	icon_state = "hairflower_yellow"
	name = "yellow flower pin"

/obj/item/clothing/head/pin/flower/violet
	icon_state = "hairflower_violet"
	name = "violet flower pin"

/obj/item/clothing/head/pin/flower/orange
	icon_state = "hairflower_orange"
	name = "orange flower pin"

/obj/item/clothing/head/pin/flower/white
	icon_state = "hairflower_white"
	addblends = "hairflower_white_a"
	name = "flower pin"

/obj/item/clothing/head/pin/bow
	icon_state = "bow"
	addblends = "bow_a"
	name = "hair bow"
	desc = "A ribbon tied into a bow with a clip on the back to attach to hair."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "pill", SLOT_ID_LEFT_HAND = "pill")

/obj/item/clothing/head/pin/bow/big
	icon_state = "whiteribbon"
	name = "ribbon"
	addblends = null

/obj/item/clothing/head/pin/bow/big/red
	icon_state = "redribbon"
	name = "red ribbon"
	addblends = null

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig."
	icon_state = "pwig"

/obj/item/clothing/head/that
	name = "top-hat"
	desc = "It's an amish looking hat."
	icon_state = "tophat"
	siemens_coefficient = 0.9
	body_cover_flags = 0

/obj/item/clothing/head/redcoat
	name = "redcoat's hat"
	icon_state = "redcoat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "pirate", SLOT_ID_LEFT_HAND = "pirate")
	desc = "<i>'I guess it's a redhead.'</i>"
	body_cover_flags = 0

/obj/item/clothing/head/mailman
	name = "station cap"
	icon_state = "mailman"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "hopcap", SLOT_ID_LEFT_HAND = "hopcap")
	desc = "<i>Choo-choo</i>!"
	body_cover_flags = 0

/obj/item/clothing/head/plaguedoctorhat
	name = "plague doctor's hat"
	desc = "These were once used by Plague doctors. They're pretty much useless."
	icon_state = "plaguedoctor"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tophat", SLOT_ID_LEFT_HAND = "tophat")
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	body_cover_flags = 0

/obj/item/clothing/head/hasturhood
	name = "hastur's hood"
	desc = "It's unspeakably stylish"
	icon_state = "hasturhood"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "enginering_beret", SLOT_ID_LEFT_HAND = "enginering_beret")
	inv_hide_flags = BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/nursehat
	name = "nurse's hat"
	desc = "It allows quick identification of trained medical personnel."
	icon_state = "nursehat"
	siemens_coefficient = 0.9
	body_cover_flags = 0

/obj/item/clothing/head/syndicatefake
	name = "red space-helmet replica"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-black-red", SLOT_ID_LEFT_HAND = "syndicate-helm-black-red")
	icon_state = "syndicate"
	desc = "A plastic replica of a bloodthirsty mercenary's space helmet, you'll look just like a real murderous criminal operative in this! This is a toy, it is not made for use in space!"
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/hevhelm
	name = "Hazardous Environments Helmet"
	desc = "Don't get Kleiner'd, wear the Helmet."
	icon_state = "hevhelm"
	inv_hide_flags = BLOCKHAIR|HIDEEARS|HIDEMASK
	body_cover_flags = HEAD|FACE

/obj/item/clothing/head/cueball
	name = "cueball helmet"
	desc = "A large, featureless white orb mean to be worn on your head. How do you even see out of this thing?"
	icon_state = "cueball"
	inv_hide_flags = BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/greenbandana
	name = "green bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon_state = "greenbandana"
	inv_hide_flags = 0
	body_cover_flags = 0

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	body_cover_flags = HEAD|FACE|EYES
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/clothing/head/justice
	name = "justice hat"
	desc = "fight for what's righteous!"
	icon_state = "justicered" //Does this even exist?
	inv_hide_flags = BLOCKHAIR
	body_cover_flags = HEAD|EYES

/obj/item/clothing/head/justice/blue
	icon_state = "justiceblue"

/obj/item/clothing/head/justice/yellow
	icon_state = "justiceyellow"

/obj/item/clothing/head/justice/green
	icon_state = "justicegreen"

/obj/item/clothing/head/justice/pink
	icon_state = "justicepink"

/obj/item/clothing/head/rabbitears
	name = "rabbit ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon_state = "bunny"
	body_cover_flags = 0

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flat_cap"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "detective", SLOT_ID_LEFT_HAND = "detective")
	siemens_coefficient = 0.9 //...what?

/obj/item/clothing/head/flatcap/grey
	icon_state = "flat_capw"
	addblends = "flat_capw_a"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greysoft", SLOT_ID_LEFT_HAND = "greysoft")

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	body_cover_flags = 0

/obj/item/clothing/head/hgpiratecap
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "hgpiratecap"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "hoscap", SLOT_ID_LEFT_HAND = "hoscap")
	body_cover_flags = 0

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "redbandana", SLOT_ID_LEFT_HAND = "redbandana")

/obj/item/clothing/head/bowler
	name = "bowler-hat"
	desc = "Gentleman, elite aboard!"
	icon_state = "bowler"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tophat", SLOT_ID_LEFT_HAND = "tophat")
	body_cover_flags = 0

//stylish bs12 hats

/obj/item/clothing/head/bowlerhat
	name = "bowler hat"
	icon_state = "bowler_hat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tophat", SLOT_ID_LEFT_HAND = "tophat")
	desc = "For the gentleman of distinction."
	body_cover_flags = 0

/obj/item/clothing/head/beaverhat
	name = "beaver hat"
	icon_state = "beaver_hat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tophat", SLOT_ID_LEFT_HAND = "tophat")
	desc = "Soft felt makes this hat both comfortable and elegant."

/obj/item/clothing/head/boaterhat
	name = "boater hat"
	icon_state = "boater_hat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "tophat", SLOT_ID_LEFT_HAND = "tophat")
	desc = "The ultimate in summer fashion."

/obj/item/clothing/head/fedora
	name = "fedora"
	icon_state = "fedora"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "detective", SLOT_ID_LEFT_HAND = "detective")
	desc = "A sharp, stylish hat."

/obj/item/clothing/head/fedora/brown
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a reporter's style or a poor attempt at looking cool, depending on the person wearing it."
	icon_state = "detective"
	allowed = list(/obj/item/reagent_containers/food/snacks/candy_corn, /obj/item/pen)

/obj/item/clothing/head/fedora/grey
	icon_state = "detective2"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "detective", SLOT_ID_LEFT_HAND = "detective")
	desc = "A grey fedora - either the cornerstone of a reporter's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/fedora/floppy
	name = "wide brimmed hat"
	desc = "A dark fedora with an incredibly wide brim. It's very avant garde."
	icon_state = "floppy"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "witch", SLOT_ID_LEFT_HAND = "witch")

/obj/item/clothing/head/feathertrilby
	name = "feather trilby"
	icon_state = "feather_trilby"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "detective", SLOT_ID_LEFT_HAND = "detective")
	desc = "A sharp, stylish hat with a feather."

/obj/item/clothing/head/fez
	name = "fez"
	icon_state = "fez"
	desc = "You should wear a fez. Fezzes are cool."

/obj/item/clothing/head/cowboy_hat
	name = "cowboy hat"
	desc = "For those that have spurs that go jingle jangle jingle."
	icon_state = "cowboyhat"
	body_cover_flags = 0

/obj/item/clothing/head/cowboy_hat/black
	name = "black cowboy hat"
	desc = "You can almost hear the old western music."
	icon_state = "cowboy_black"

/obj/item/clothing/head/cowboy_hat/wide
	name = "wide-brimmed cowboy hat"
	desc = "Because justice isn't going to dispense itself."
	icon_state = "cowboy_wide"

/obj/item/clothing/head/cowboy_hat/small
	name = "small cowboy hat"
	desc = "For the tiniest of cowboys."
	icon_state = "cowboy_small"

/obj/item/clothing/head/cowboy_hat/pink
	name = "pink cowboy hat"
	desc = "Did you know pink used to be a masculine color?"
	icon_state = "cowboyhat_pink"

/obj/item/clothing/head/witchwig
	name = "witch costume wig"
	desc = "Eeeee~heheheheheheh!"
	icon_state = "witch"
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 2.0

/obj/item/clothing/head/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chickenhead"
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 0.7
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon_state = "bearpelt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_black", SLOT_ID_LEFT_HAND = "beret_black")
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 0.7

/obj/item/clothing/head/xenos
	name = "xenos helmet"
	icon_state = "xenos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "xenos_helm", SLOT_ID_LEFT_HAND = "xenos_helm")
	desc = "A helmet made out of chitinous alien hide."
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/philosopher_wig
	name = "natural philosopher's wig"
	desc = "A stylish monstrosity unearthed from Earth's Renaissance period. With this most distinguish'd wig, you'll be ready for your next soiree!"
	icon_state = "philosopher_wig"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "pwig", SLOT_ID_LEFT_HAND = "pwig")
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 2.0 //why is it so conductive?!
	body_cover_flags = 0

/obj/item/clothing/head/orangebandana //themij: Taryn Kifer
	name = "orange bandana"
	desc = "An orange piece of cloth, worn on the head."
	icon_state = "orange_bandana"
	body_cover_flags = 0

/obj/item/clothing/head/hijab
	name = "hijab"
	desc = "A veil that is wrapped to cover the head and chest"
	icon_state = "hijab"
	addblends = "hijab_a"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = 0
	inv_hide_flags = BLOCKHAIR

/obj/item/clothing/head/kippa
	name = "kippa"
	desc = "A small, brimless cap."
	icon_state = "kippa"
	addblends = "kippa_a"
	body_cover_flags = 0

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A cloth used to wind around the head"
	icon_state = "turban"
	addblends = "turban_a"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = 0
	inv_hide_flags = BLOCKHEADHAIR

/obj/item/clothing/head/taqiyah
	name = "taqiyah"
	desc = "A short, rounded skullcap usually worn for religious purposes."
	icon_state = "taqiyah"
	addblends = "taqiyah_a"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "taq", SLOT_ID_LEFT_HAND = "taq")

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A head-hugging brimless winter cap. This one is tight."
	icon_state = "beanie"
	body_cover_flags = 0
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/beanie_loose
	name = "loose beanie"
	desc = "A head-hugging brimless winter cap. This one is loose."
	icon_state = "beanie_hang"
	addblends = "beanie_hang_a"
	body_cover_flags = 0
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/beretg
	name = "beret"
	desc = "A beret, an artists favorite headwear."
	icon_state = "beret_g"
	addblends = "beret_g_a"
	body_cover_flags = 0

/obj/item/clothing/head/sombrero
	name = "sombrero"
	desc = "A wide-brimmed hat popularly worn in Mexico."
	icon_state = "sombrero"
	body_cover_flags = 0

/obj/item/clothing/head/headband/maid
	name = "maid headband"
	desc = "Keeps hair out of the way for important... jobs."
	icon_state = "maid"
	body_cover_flags = 0

/obj/item/clothing/head/maangtikka
	name = "maang tikka"
	desc = "A jeweled headpiece originating in India."
	icon_state = "maangtikka"
	body_cover_flags = 0

/obj/item/clothing/head/jingasa
	name = "jingasa"
	desc = "A wide, flat rain hat originally from Japan."
	icon_state = "jingasa"
	body_cover_flags = 0
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "taq", SLOT_ID_LEFT_HAND = "taq")

/obj/item/clothing/head/cowl
	name = "black cowl"
	desc = "A gold-lined black cowl. It gives off uncomfortable cult vibes, but fancy."
	icon_state = "cowl"
	body_cover_flags = 0

/obj/item/clothing/head/cowl
	name = "white cowl"
	desc = "A gold-lined white cowl. It gives off uncomfortable cult vibes, but fancy."
	icon_state = "whitecowl"
	body_cover_flags = 0

/obj/item/clothing/head/bohat
	name = "bridge officer hat"
	desc = "For a person with no authority who takes themselves very seriously."
	icon_state = "bridgeofficersoft"

/obj/item/clothing/head/parahat
	name = "paramedic cap"
	desc = "For a person who really needs a raise."
	icon_state = "paramedicsoft"

/obj/item/clothing/head/bocap
	name = "bridge officer cap"
	desc = "For a person with no authority who takes themselves very VERY seriously."
	icon_state = "bridgeofficerhard"

/obj/item/clothing/head/operations
	name = "Operations Command Staff Cap"
	desc = "A white cap distributed to Command staff aboard NT vessels."
	icon_state = "operations_cap_command"

/obj/item/clothing/head/operations/medsci
	name = "Operations Medical/Science Staff Cap"
	desc = "A faded-blue cap distributed to both Medical and Science staff aboard NT vessels."
	icon_state = "operations_cap_medsci"

/obj/item/clothing/head/operations/engineering
	name = "Operations Engineering Staff Cap"
	desc = "An orange/yellow cap distributed to Engineering staff aboard NT vessels."
	icon_state = "operations_cap_engineering"

/obj/item/clothing/head/operations/security
	name = "Operations Security Staff Cap"
	desc = "A red cap distributed to Security staff aboard NT vessels."
	icon_state = "operations_cap_sec"

/obj/item/clothing/head/rice
	name = "rice hat"
	desc = "A conical hat originating from old Earth Asia. Useful for keeping the sun and moisture out of your face when working in a humid environment."
	icon_state = "rice_hat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = 0
	inv_hide_flags = BLOCKHAIR

/obj/item/clothing/head/lobster
	name = "lobster costume head"
	desc = "Remember: Lobsters don't scream."
	icon_state = "lobster_hat"
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 0.7
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/nemes
	name = "nemes headdress"
	desc = "A flowing cloth cap worn by the ruling class of Egypt, an old Earth country in Africa. Usually found on dessicated corpses or fetish cosplayers."
	icon_state = "nemes_headdress"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_blue", SLOT_ID_LEFT_HAND = "beret_blue")
	body_cover_flags = 0
	inv_hide_flags = BLOCKHAIR

/obj/item/clothing/head/pharaoh
	name = "pharaoh cap"
	desc = "An alternate headdress worn by ancient Egyptian Pharaohs. Studies have concluded that wearing this does not, in fact, make you an Egyptian."
	icon_state = "pharaoh_hat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_blue", SLOT_ID_LEFT_HAND = "beret_blue")
	body_cover_flags = 0
	inv_hide_flags = BLOCKHAIR

/obj/item/clothing/head/skull
	name = "totemic skull hat"
	desc = "This bleached skull has been fitted with a band allowing it to be worn. Whether the foe was yours, or anothers, you do feel a little more intimidating with this on."
	icon_state = "skull"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = 0
	inv_hide_flags = 0

/obj/item/clothing/head/bunny
	name = "bunny costume head"
	desc = "Popular with both mascots and heartbroken Japanese highschool girls."
	icon_state = "bunnyhead"
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 0.7
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/pith
	name = "pith hat"
	desc = "A peaked helmet once popular among Old Earth militaries and expeditionary forces."
	icon_state = "pith"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")

/obj/item/clothing/head/reindeer
	name = "reindeer antlers"
	desc = "A set of costume antlers with a glowing red nose, an Old Earth favorite."
	icon_state = "reindeer0"
	action_button_name = "Toggle Nose"

/obj/item/clothing/head/reindeer/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_on"
		to_chat(user, "You turn the glowing nose on.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You turn the glowing nose off.")
	update_worn_icon()	//so our mob-overlays update

/obj/item/clothing/head/crown
	name = "banded crown"
	desc = "A simple crown, fashioned out of gold."
	icon_state = "crown"
	body_cover_flags = HEAD

/obj/item/clothing/head/crown/fancy
	name = "coronation crown"
	desc = "An opulent crown, crafted for ceremonial purposes."
	icon_state = "fancycrown"

/obj/item/clothing/head/scarecrow
	name = "field hat"
	desc = "A ragged burlap hat, bleached and worn by years of exposure to blistering sunlight."
	icon_state = "scarecrow_hat"
	body_cover_flags = HEAD

/obj/item/clothing/head/holiday
	name = "red holiday hat"
	desc = "A floppy, fur lined cap. Made famous by an Old Earth mythical figure."
	icon_state = "christmashat"
	body_cover_flags = HEAD

/obj/item/clothing/head/holiday/green
	name = "green holiday hat"
	desc = "A floppy, fur lined cap. Made famous by a cabal of toy crafting elves."
	icon_state = "christmashatg"
	body_cover_flags = HEAD

/obj/item/clothing/head/telegram
	name = "telegram cap"
	desc = "A red box hat, affixed with an elastic strap."
	icon_state = "telegram"

/obj/item/clothing/head/widehat_red
	name = "broad red hat"
	desc = "A wide brimmed velvet hat with a feather affixed to the band."
	icon_state = "widehat_red"

/obj/item/clothing/head/snowman
	name = "snowman head"
	desc = "A chilly pile of reinforced ice, fashioned to look like a snowman's head."
	icon_state = "snowman"
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 0.7
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/head/traveller
	name = "traveller's hat"
	desc = "A wide brimmed hat made of sturdy material. Its floppy, pointed top is similar to those worn by Old Earth bards or sorcerors."
	icon_state = "traveller"
	//addblends = "traveller_a"

/obj/item/clothing/head/samurai_replica
	name = "replica kabuto"
	desc = "An authentic antique, this helmet from old Earth belongs to an ancient martial tradition. The advent of firearms made this style of protection obsolete. Unfortunately, this remains the case. This version appears less sturdy."
	icon_state = "kabuto_colorable"

/obj/item/clothing/head/ankh
	name = "aegyptian circlet"
	desc = "Perfect for when you want to deliver a stern look from on high."
	icon_state = "ankh"
	body_cover_flags = 0

/obj/item/clothing/head/roman_replica
	name = "Roman Galea"
	desc = "A reproduction helmet fashioned to look like an ancient Roman Galea. The material is too flimsy to provide protection."
	icon_state = "roman"

/obj/item/clothing/head/romancent_replica
	name = "Roman Crested Galea"
	desc = "A reproduction helmet fashioned to look like an ancient Roman Galea. The material is too flimsy to provide protection."
	icon_state = "roman_c"

/obj/item/clothing/head/imperial_replica
	name = "imperial soldier helmet"
	desc = "Reproduction headgear fashioned after the standard helmet of the ill fated Neo Macedonian Empire. The material is too flimsy to provide protection."
	icon_state = "ge_helm"
	icon = 'icons/obj/clothing/hats.dmi'

/obj/item/clothing/head/imperial_officer_replica
	name = "imperial officer helmet"
	desc = "Reproduction headgear fashioned after the officer's helmet of the ill fated Neo Macedonian Empire. The material is too flimsy to provide protection."
	icon_state = "ge_helmcent"
	icon = 'icons/obj/clothing/hats.dmi'

/obj/item/clothing/head/papersack
	name = "paper sack hat"
	desc = "A paper sack with crude holes cut out for eyes. Useful for hiding one's identity or ugliness."
	icon_state = "paperbag_None"
	inv_hide_flags = BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/papersack/smiley
	name = "paper sack hat"
	desc = "A paper sack with crude holes cut out for eyes and a sketchy smile drawn on the front. Not creepy at all."
	icon_state = "paperbag_SmileyFace"
	inv_hide_flags = BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/ghost_sheet
	name = "ghost sheet"
	desc = "The hands float by themselves, so it's extra spooky."
	icon_state = "ghost_sheet"
	item_state = "ghost_sheet"
	throw_force = 0
	throw_speed = 1
	throw_range = 2
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|HEAD|FACE
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR|HIDEGLOVES|HIDETIE|HIDEHOLSTER

/obj/item/clothing/head/half_pint	//Note, this headband is basically designed to only work on one hairstyle. YMMV
	name = "Half-Pint Headband"
	desc = "A simple metal headband with cosmetic lights. It seems like it's meant to accompany an outfit."
	icon_state = "half_pint"
	body_cover_flags = 0

/obj/item/clothing/head/bard
	name = "audacious wide brimmed hat"
	desc = "A bold leather hat with a brim so wide that it droops. The bright feather of an unknown bird has been stuck into the brim."
	icon = 'icons/clothing/head/bard.dmi'
	icon_state = "bardhat"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
