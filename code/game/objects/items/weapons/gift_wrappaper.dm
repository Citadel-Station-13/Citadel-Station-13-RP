/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/a_gift/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < ITEMSIZE_LARGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"

/obj/item/gift/attack_self(mob/user as mob)
	user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, "<span class='warning'>The gift was empty!</span>")

/obj/item/a_gift/legacy_ex_act()
	qdel(src)

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	to_chat(user, "<span class='warning'>You can't move.</span>")

/obj/effect/spresent/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (!W.is_wirecutter())
		to_chat(user, "<span class='warning'>I need wirecutters for that.</span>")
		return

	to_chat(user, "<span class='notice'>You cut open the present.</span>")

	for(var/mob/M in src) //Should only be one but whatever.
		M.forceMove(loc)
		M.update_perspective()

	qdel(src)

/obj/item/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/belt/champion,
		/obj/item/soap/deluxe,
		/obj/item/pickaxe/silver,
		/obj/item/pen/invisible,
		/obj/item/lipstick/random,
		/obj/item/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/contraband/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/beach_ball,
		/obj/item/beach_ball/holoball,
		/obj/item/toy/balloon,
		/obj/item/toy/blink,
		/obj/item/toy/crossbow,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/paicard,
		/obj/item/instrument/violin,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/accessory/tie/horrible)

	if(!ispath(gift_type,/obj/item))
		return
	M.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
	var/obj/item/I = new gift_type(M)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)

/obj/item/b_gift
	name = "gift"
	desc = "It's slimy inside!"
	icon = 'icons/obj/flora/pumpkins.dmi'
	icon_state = "decor-pumpkin"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/b_gift/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)

/obj/item/gift/attack_self(mob/user as mob)
	user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
	if(gift)
		user.put_in_active_hand(gift)
		gift.add_fingerprint(user)
	else
		to_chat(user, "<span class='warning'>The pumpkin was empty!</span>")
	qdel(src)

/obj/item/b_gift/legacy_ex_act()
	qdel(src)

/obj/item/b_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/reagent_containers/hard_candy/lollipop,
		/obj/item/reagent_containers/hard_candy/lollipop/bicard,
		/obj/item/reagent_containers/hard_candy/lollipop/citalopram,
		/obj/item/reagent_containers/hard_candy/lollipop/dexalin,
		/obj/item/reagent_containers/hard_candy/lollipop/dylovene,
		/obj/item/reagent_containers/hard_candy/lollipop/kelotane,
		/obj/item/reagent_containers/hard_candy/lollipop/tricord,
		/obj/item/reagent_containers/food/snacks/candy,
		/obj/item/reagent_containers/food/snacks/candy_corn,
		/obj/item/reagent_containers/food/snacks/cookie,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/organ,
		/obj/item/reagent_containers/food/snacks/donkpocket,
		/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket,
		/obj/item/reagent_containers/food/snacks/ghostburger,
		/obj/item/reagent_containers/food/snacks/brainburger,
		/obj/item/reagent_containers/food/snacks/no_raisin,
		/obj/item/clothing/mask/gas/plaguedoctor,
		/obj/item/clothing/mask/gas/guy,
		/obj/item/clothing/mask/gas/goblin,
		/obj/item/clothing/mask/gas/demon,
		/obj/item/clothing/mask/gas/monkeymask,
		/obj/item/clothing/mask/gas/owl_mask,
		/obj/item/clothing/mask/gas/pig,
		/obj/item/clothing/mask/gas/shark,
		/obj/item/clothing/mask/gas/dolphin,
		/obj/item/clothing/mask/gas/horsehead,
		/obj/item/clothing/mask/gas/frog,
		/obj/item/clothing/mask/gas/rat,
		/obj/item/clothing/mask/gas/fox,
		/obj/item/clothing/mask/gas/bee,
		/obj/item/clothing/mask/gas/bear,
		/obj/item/clothing/mask/gas/bat,
		/obj/item/clothing/mask/gas/raven,
		/obj/item/clothing/mask/gas/jackal,
		/obj/item/clothing/mask/gas/bumba,
		/obj/item/clothing/mask/gas/scarecrow,
		/obj/item/clothing/mask/gas/mummy,
		/obj/item/clothing/mask/gas/skeleton,
		/obj/fiftyspawner/bananium,
		/obj/item/storage/backpack/holding,
		/obj/item/grenade/smokebomb,
		/obj/item/toy/crossbow,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/toy/katana,
		/obj/item/toy/sword,
		/obj/item/storage/belt/utility/full)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)

/*
 * Wrapping Paper
 */
/obj/item/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 20.0
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

/obj/item/wrapping_paper/attackby(obj/item/W as obj, mob/living/user as mob)
	..()
	if (!( locate(/obj/structure/table, loc) ))
		to_chat(user, "<span class='warning'>You must put the paper on a table first!</span>")
	if (W.w_class < ITEMSIZE_LARGE)
		var/obj/item/I = user.get_inactive_held_item()
		if(I.is_wirecutter())
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				to_chat(user, "<span class='warning'>You need more paper!</span>")
				return
			else
				if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/gift)) //No gift wrapping gifts!
					return
				if(!user.attempt_void_item_for_installation(W))
					return

				amount -= a_used
				var/obj/item/gift/G = new /obj/item/gift( src.loc )
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = text("gift[]", G.size)
				G.gift = W
				W.forceMove(G)
				G.add_fingerprint(user)
				W.add_fingerprint(user)
			if (src.amount <= 0)
				new /obj/item/c_tube( src.loc )
				qdel(src)
				return
		else
			to_chat(user, "<span class='warning'>You need scissors!</span>")
	else
		to_chat(user, "<span class='warning'>The object is FAR too large!</span>")
	return


/obj/item/wrapping_paper/examine(mob/user)
	. = ..()
	. += "There is about [src.amount] square units of paper left!"

/obj/item/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			H.forceMove(present)
			H.update_perspective()

			add_attack_logs(user,H,"Wrapped with [src]")
		else
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")
