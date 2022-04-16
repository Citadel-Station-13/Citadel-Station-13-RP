/mob/living/carbon/human/proc/adjust_nutrition(amount)
	nutrition = clamp(nutrition + amount, 0, species.max_nutrition)
