/obj/item/spacecash
	name = "0 Thaler"
	desc = "It's worth 0 Thalers."
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	gender = PLURAL
	damage_force = 1
	throw_force = 1
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	/// Amount of money this is.
	var/worth = 0

/obj/item/spacecash/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/spacecash))

		var/obj/item/spacecash/SC = W

		SC.adjust_worth(src.worth)
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user

			h_user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
			h_user.temporarily_remove_from_inventory(SC, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
			h_user.put_in_hands(SC)
		to_chat(user, "<span class='notice'>You combine the Thalers to a bundle of [SC.worth] Thalers.</span>")
		qdel(src)

/obj/item/spacecash/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()

	name = "[worth] Thaler\s"
	if(worth in list(1000,500,200,100,50,20,10,1))
		icon_state = "spacecash[worth]"
		desc = "It's worth [worth] Thalers."
		return

	var/sum = worth
	var/num = 0
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			overlays_to_add += banknote

	if(num == 0) // Less than one thaler, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items.dmi', "spacecash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		overlays_to_add += banknote

	desc = "They are worth [worth] Thalers."

	add_overlay(overlays_to_add)

/obj/item/spacecash/proc/adjust_worth(var/adjust_worth = 0, var/update = 1)
	worth += adjust_worth
	if(worth > 0)
		if(update)
			update_icon()
		return worth
	else
		qdel(src)
		return 0

/obj/item/spacecash/proc/set_worth(var/new_worth = 0, var/update = 1)
	worth = max(0, new_worth)
	if(update)
		update_icon()
	return worth

/obj/item/spacecash/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/amount = input(usr, "How many Thalers do you want to take? (0 to [src.worth])", "Take Money", 20) as num
	if(!src || QDELETED(src))
		return
	amount = round(clamp(amount, 0, src.worth))

	if(!amount)
		return

	adjust_worth(-amount)
	var/obj/item/spacecash/SC = new (usr.loc)
	SC.set_worth(amount)
	usr.put_in_hands(SC)

//* Economy *//

/obj/item/spacecash/economy_is_payment()
	return TRUE

/obj/item/spacecash/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, atom/movable/accepting_entity, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)
	if((payment.payment_types_allowed & PAYMENT_TYPE_CASH))
		actor?.chat_feedback(
			SPAN_WARNING("[accepting_entity] doesn't accept cash."),
			target = accepting_entity,
		)
		return TRUE

	var/paying_amount

	if(worth < payment.amount)
		if(payment.allow_partial)
			paying_amount = worth
		else
			actor?.chat_feedback(
				SPAN_WARNING("[src] isn't enough to pay [accepting_entity] with."),
				target = src,
			)
			// don't actually execute payment as this isn't a card swipe and we're
			// not inserting the cash.
			// todo: should we have a system to allow logical insertion and rejection?
			//       this system currently doesn't support the machine itself throwing an error
			//       as from its perspective the cash was never inserted.
			return TRUE
	else
		paying_amount = payment.amount

	if(!(payment_op_flags & PAYMENT_OP_SUPPRESSED))
		actor?.visible_feedback(
			target = accepting_entity,
			range = MESSAGE_RANGE_ITEM_HARD,
			visible = SPAN_NOTICE("[actor.performer] inserts some cash into [accepting_entity]."),
			otherwise_self = SPAN_NOTICE("You insert some cash into [accepting_entity]."),
		)
	// todo: sound

	worth -= paying_amount
	ASSERT(worth >= 0)

	payment.out_payment_result = PAYMENT_RESULT_SUCCESS
	payment.out_amount_paid = paying_amount

	if(!worth)
		qdel(src)
	else
		update_appearance()
	return TRUE

//* Supply *//

/obj/item/spacecash/supply_export_enumerate(datum/supply_export/export)
	export.earned_direct_cash += worth
	export.earned += worth

/obj/item/spacecash/c1
	name = "1 Thaler"
	icon_state = "spacecash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/spacecash/c10
	name = "10 Thaler"
	icon_state = "spacecash10"
	desc = "It's worth 10 Thalers."
	worth = 10

/obj/item/spacecash/c20
	name = "20 Thaler"
	icon_state = "spacecash20"
	desc = "It's worth 20 Thalers."
	worth = 20

/obj/item/spacecash/c50
	name = "50 Thaler"
	icon_state = "spacecash50"
	desc = "It's worth 50 Thalers."
	worth = 50

/obj/item/spacecash/c100
	name = "100 Thaler"
	icon_state = "spacecash100"
	desc = "It's worth 100 Thalers."
	worth = 100

/obj/item/spacecash/c200
	name = "200 Thaler"
	icon_state = "spacecash200"
	desc = "It's worth 200 Thalers."
	worth = 200

/obj/item/spacecash/c500
	name = "500 Thaler"
	icon_state = "spacecash500"
	desc = "It's worth 500 Thalers."
	worth = 500

/obj/item/spacecash/c1000
	name = "1000 Thaler"
	icon_state = "spacecash1000"
	desc = "It's worth 1000 Thalers."
	worth = 1000

/proc/spawn_money(sum, spawnloc, mob/living/carbon/human/human_user)
	var/obj/item/spacecash/SC = new (spawnloc)

	SC.set_worth(sum)
	if (ishuman(human_user) && !human_user.get_active_held_item())
		human_user.put_in_hands(SC)

