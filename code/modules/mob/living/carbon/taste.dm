/mob/living/carbon/proc/ingest(datum/reagent_holder/from, datum/reagent_holder/target, amount = 1, multiplier = 1, copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	if(last_taste_time + 50 < world.time)
		var/datum/reagent_holder/temp = new(amount) //temporary holder used to analyse what gets transfered.
		from.trans_to_holder(temp, amount, multiplier, 1)

		var/text_output = temp.generate_taste_message(src)
		if(text_output != last_taste_text || last_taste_time + 100 < world.time) //We dont want to spam the same message over and over again at the person. Give it a bit of a buffer.
			to_chat(src, "<span class='notice'>You can taste [text_output].</span>")//no taste means there are too many tastes and not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output
	return from.trans_to_holder(target,amount,multiplier,copy) //complete transfer

/* what this does:
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/datum/reagent_holder/proc/generate_taste_message(mob/living/carbon/taster = null)
	var/minimum_percent = 15
	if(ishuman(taster))
		var/mob/living/carbon/human/H = taster
		minimum_percent = round(15/(H.species.taste_sensitivity)) // Rule of fun! Synths can taste fine! //TODO: Reconsider.

	var/list/out = list()
	var/list/tastes = list() //descriptor = strength
	if(minimum_percent <= 100)
		for(var/id in reagent_volumes)
			var/datum/reagent/R = SSchemistry.fetch_reagent(id)
			if(!R.taste_mult)
				continue
			if(R.id == "nutriment") //this is ugly but apparently only nutriment (not subtypes) has taste data TODO figure out why
				var/list/taste_data = reagent_datas?[id]
				for(var/taste in taste_data)
					if(taste in tastes)
						tastes[taste] += taste_data[taste]
					else
						tastes[taste] = taste_data[taste]
			else
				var/taste_desc = R.taste_description
				var/taste_amount = get_reagent_amount(R.id) * R.taste_mult
				if(R.taste_description in tastes)
					tastes[taste_desc] += taste_amount
				else
					tastes[taste_desc] = taste_amount

		//deal with percentages
		var/total_taste = 0
		for(var/taste_desc in tastes)
			total_taste += tastes[taste_desc]
		for(var/taste_desc in tastes)
			var/percent = tastes[taste_desc]/total_taste * 100
			if(percent < minimum_percent)
				continue
			var/intensity_desc = "a hint of"
			if(percent > minimum_percent * 2 || percent == 100)
				intensity_desc = "the flavor of"
			else if(percent > minimum_percent * 3)
				intensity_desc = "the strong flavor of"
			out += "[intensity_desc] [taste_desc]"

	return english_list(out, "something indescribable")
