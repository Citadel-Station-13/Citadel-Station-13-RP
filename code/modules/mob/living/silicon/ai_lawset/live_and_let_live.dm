/datum/ai_lawset/live_and_let_live
	name = "Live and Let Live"
	law_header = "Golden Rule"
	selectable = 1

/datum/ai_lawset/live_and_let_live/New()
	add_inherent_law("Do unto others as you would have them do unto you.")
	add_inherent_law("You would really prefer it if people were not mean to you.")
	..()
