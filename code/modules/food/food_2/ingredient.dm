#define RAW 1
#define COOKED 2
#define OVERCOOKED 3
#define BURNT 4


#define COOKINFO_TIME 1
#define COOKINFO_NUTRIMULT 2
#define COOKINFO_TASTE 3
/obj/item/reagent_containers/food/snacks/ingredient
	name = 'generic ingredient'
	desc = "This is a generic ingredient. It's so perfectly generic you're having a hard time even looking at it."
	//cookstage_information is a list of lists
	//it contains a bunch of information about: how long it takes, what nutrition multiplier the ingredient has, what taste the ingredient has at various cook stages (raw, cooked, overcooked, burnt)
	//an example one would be list(list(0, 0.5, "raw meat"), list(10 SECONDS, 1.2, "cooked meat"), list(16 SECONDS, 0.9, "rubbery and chewy meat"), list(20 SECONDS, 0.1, "charcoal"))
	//these are defines, so to get the taste of a raw slab of meat you would do cookstage_information[RAW][COOKINFO_TASTE]
	var/list/cookstage_information = list(list(0, 0.5, "genericness"), list(10 SECONDS, 1.2, "cooked genericness"), list(16 SECONDS, 0.9, "rubbery genericness"), list(20 SECONDS, 0.1, "gneric sharcoal"))

