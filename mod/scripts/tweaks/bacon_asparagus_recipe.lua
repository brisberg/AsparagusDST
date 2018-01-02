local FOODTYPE = GLOBAL.FOODTYPE

local bacon_asparagus_recipe = {
	name = "bacon_asparagus_ag",
	test = function(cooker, names, tags) return (names.asparagus_ag or names.asparagus_ag_cooked) and names.twigs and (tags.meat and tags.meat >= 1) end,
	priority = 10,
	weight = 1,
	foodtype = FOODTYPE.MEAT,
	health = TUNING.HEALING_HUGE,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_FAST,
	sanity = TUNING.SANITY_TINY,
	cooktime = .5,
}

AddCookerRecipe("cookpot", bacon_asparagus_recipe)

-- Make asparagus a vegetable in the crockpot
AddIngredientValues({"asparagus_ag"}, {veggie=1}, true)

return bacon_asparagus_recipe
