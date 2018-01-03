-- local FOODTYPE = GLOBAL.FOODTYPE
-- local TUNING = GLOBAL.TUNING

local bacon_asparagus_recipe = {
	name = "bacon_asparagus_ag",
	test = function(cooker, names, tags) return (names.asparagus_ag or names.asparagus_ag_cooked) and names.twigs and (tags.meat and tags.meat >= 1) end,
	priority = 10,
	weight = 1,
	foodtype = FOODTYPE.MEAT,
	health = TUNING.HEALING_MEDSMALL,
	hunger = TUNING.CALORIES_LARGE,
	perishtime = TUNING.PERISH_SLOW,
	sanity = TUNING.SANITY_MEDLARGE,
	cooktime = 2,
}

return bacon_asparagus_recipe
