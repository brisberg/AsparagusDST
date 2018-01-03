PrefabFiles = {
	"asparagus_ag",
	"asparagus_ag_cooked",
	"asparagus_ag_seeds",
	"bacon_asparagus_ag",
}

-- debug speed
-- GLOBAL.TUNING.SEEDS_GROW_TIME = 5

-- Tweaks
modimport "scripts/tweaks/plant_normal_tweak"

local bacon_asparagus_recipe = GLOBAL.require("tweaks/bacon_asparagus_recipe")
AddCookerRecipe("cookpot", bacon_asparagus_recipe)
AddIngredientValues({"asparagus_ag"}, {veggie=1}, true)

-- Actions
modimport "scripts/actions/actions"

-- States
modimport "scripts/stategraphs/share_states"
