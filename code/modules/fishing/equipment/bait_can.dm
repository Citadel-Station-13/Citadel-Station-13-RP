/obj/item/bait_can
	abstract_type = /obj/item/bait_can
	name = "can o bait"
	desc = "there's a lot of them in there, getting them out takes a while though"
	icon = 'icons/modules/fishing/storage.dmi'
	icon_state = "bait_can"
	w_class = WEIGHT_CLASS_SMALL
	/// Tracking until we can take out another bait item
	COOLDOWN_DECLARE(bait_removal_cooldown)
	/// What bait item it produces
	var/bait_type
	/// Time between bait retrievals
	var/cooldown_time = 10 SECONDS
	/// how much it has left; null for infinite
	var/bait_left = 50

/obj/item/bait_can/attack_self(mob/user, modifiers)
	. = ..()
	var/fresh_bait = retrieve_bait(user)
	if(fresh_bait)
		user.put_in_hands(fresh_bait)

/obj/item/bait_can/proc/retrieve_bait(mob/user)
	if(!isnull(bait_left) && (bait_left <= 0))
		user.bubble_action_feedback("it's empty", src)
		return
	if(!COOLDOWN_FINISHED(src, bait_removal_cooldown))
		user.bubble_action_feedback("wait a bit", src)
		return
	if(!isnull(bait_left))
		--bait_left
	COOLDOWN_START(src, bait_removal_cooldown, cooldown_time)
	return new bait_type(src)

/obj/item/bait_can/worm
	name = "can o' worm"
	desc = "A can of worms. Useful for fishing."
	bait_type = /obj/item/reagent_containers/food/snacks/bait/worm

/obj/item/bait_can/worm/premium
	name = "can o' worm deluxe"
	desc = "A can of fancy worms. Useful for fishing, even more so."
	bait_type = /obj/item/reagent_containers/food/snacks/bait/worm/premium
