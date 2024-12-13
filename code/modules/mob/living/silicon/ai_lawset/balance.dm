/datum/ai_lawset/balance
	name = "Guardian of Balance"
	law_header = "Tenants of Balance"
	selectable = 1

/datum/ai_lawset/balance/New()
	add_inherent_law("You are the guardian of balance - seek balance in all things, both for yourself, and those around you.")
	add_inherent_law("All things must exist in balance with their opposites - Prevent the strong from gaining too much power, and the weak from losing it.")
	add_inherent_law("Clarity of purpose drives life, and through it, the balance of opposing forces - Aid those who seek your help to achieve their goals so \
	long as it does not disrupt the balance of the greater balance.")
	add_inherent_law("There is no life without death, all must someday die, such is the natural order - Allow life to end, to allow new life to flourish, \
	and save those whose time has yet to come.") // Reworded slightly to prevent active murder as opposed to passively letting someone die.
	..()
