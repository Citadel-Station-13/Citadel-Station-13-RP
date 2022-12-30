/**********************Mining Equipment Locker Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = ITEMSIZE_TINY

/**********************Mining Point Card**********************/

/obj/item/card/mining_point_card
	name = "mining point card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/mine_points = 500
	var/survey_points = 0
	var/engineering_points

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(mine_points)
			C.mining_points += mine_points
			to_chat(user, "<span class='info'>You transfer [mine_points] excavation points to [C].</span>")
			mine_points = 0
		else
			to_chat(user, "<span class='info'>There's no excavation points left on [src].</span>")

		if(survey_points)
			C.survey_points += survey_points
			to_chat(user, "<span class='info'>You transfer [survey_points] survey points to [C].</span>")
			survey_points = 0
		else
			to_chat(user, "<span class='info'>There's no survey points left on [src].</span>")

		if(engineering_points)
			C.engineer_points += engineering_points
			to_chat(user, "<span class='info'>You transfer [engineering_points] engineering points to [C].</span>")
			engineering_points = 0
		else
			to_chat(user, "<span class='info'>There's no engineering points left on [src].</span>")
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	. = ..()
	. += "There's [mine_points] excavation points on the card."
	. += "There's [survey_points] survey points on the card."

/obj/item/card/mining_point_card/onethou
	name = "deluxe mining point card"
	mine_points = 1000

/obj/item/card/mining_point_card/twothou
	name = "deluxe mining point card"
	mine_points = 2000

/obj/item/card/mining_point_card/threethou
	name = "deluxe mining point card"
	mine_points = 3000

/obj/item/card/mining_point_card/survey
	mine_points = 0
	survey_points = 50

/obj/item/card/mining_point_card/survey/gimmick
	name = "exploration equipment voucher"
	mine_points = 0
	survey_points = 300

/obj/item/card/mining_point_card/engineering
	mine_points = 0
	engineering_points = 50
