//////////////////////////////////////////
// Democratic Republic of Adhomai (DRA) Firearms
///////////////////////////////////////////
/* Notes on DRA Firearms:
The Democratic Republic of Adhomai was formed from a coalition of revolutionary guerilla movements who successfully liberated
their cities from People's Republic of Adhomai rule during the civil war. Since then military juntas have slowly been giving
way to liberal democracy however the military remains extremely influential and a balance must remain maintained less there
be a coup de'tat. Aesthetically they share a lot with the 20th century latin America guerillas such as Che Guevara and
 */

///////////////////
//One Handed
///////////////////

/obj/item/gun/projectile/ballistic/automatic/mini_uzi/taj
	name = "\improper Adhomai Uzi"
	desc = "The Hotak's Arms machine pistol has developed a fierce reputation for its use by guerillas of the Democratic Republic of Adhomai. \
	Its top loading magazine allows one to go completely prone in the deep snow banks of Adhomai while maintaining good weapon stability."
	icon = 'icons/content/factions/tajara/items/guns/taj_uzi.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_uzi.dmi'
	icon_state = "mini-uzi"
	item_state = "mini-uzi"
	render_use_legacy_by_default = FALSE

///////////////////
//Two Handed
///////////////////

/obj/item/gun/projectile/ballistic/SVD/taj
	name = "Adhomai sniper rifle"
	desc = "The Hotaki Marksman rifle, in stark contrast to the usual products of Hotak's arms, is an elegant and precise rifle that has taken the lives of \
	many high value targets in the name of defending the Democratic Republic of Adhomai."
	icon = 'icons/content/factions/tajara/items/guns/taj_svd.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_svd.dmi'
	wielded_item_state = "SVD-wielded"
	render_use_legacy_by_default = FALSE

/obj/item/gun/projectile/ballistic/SVD/taj/scope()
	toggle_scope(2.0)

/obj/item/gun/projectile/ballistic/automatic/fal/taj
	name = "Adhomai battle rifle"
	desc = "When faced with creating a modern battle rifle for the Democratic Republic of Adhomai, Hotak's Arms simply scaled up their machine pistol design \
	to a rifle capable of chambering 7.62mm a round already in use by DRA marksmen. The new rifle proved itself a match for its peers and DRA propaganda recieved \
	a noticeable boost showing off its Adhomai original design."
	icon = 'icons/content/factions/tajara/items/guns/taj_fal.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_fal.dmi'
	icon_state = "fal"
	item_state = "fal"
	wielded_item_state = "fal-wielded"
	render_use_legacy_by_default = FALSE

