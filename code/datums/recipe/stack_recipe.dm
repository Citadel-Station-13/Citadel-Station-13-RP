#warn audit

/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	/// Amount of material needed for this recipe.
	var/req_amount = 1
	/// Amount of stuff that is produced in one batch (e.g. 4 for floor tiles).
	var/res_amount = 1
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material
	var/pass_color

/datum/stack_recipe/New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null, pass_stack_color)
	if(!isnull(title))
		src.title = title
	if(!isnull(result_type))
		src.result_type = result_type
	if(!isnull(req_amount))
		src.req_amount = req_amount
	if(!isnull(res_amount))
		src.res_amount = res_amount
	if(!isnull(max_res_amount))
		src.max_res_amount = max_res_amount
	if(!isnull(time))
		src.time = time
	if(!isnull(one_per_turf))
		src.one_per_turf = one_per_turf
	if(!isnull(on_floor))
		src.on_floor = on_floor
	if(!isnull(supplied_material))
		src.use_material = supplied_material
	if(!isnull(pass_stack_color))
		src.pass_color = pass_stack_color

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null

/datum/stack_recipe_list/New(title, list/recipes)
	if(!isnull(title))
		src.title = title
	if(!isnull(recipes))
		src.recipes = recipes
