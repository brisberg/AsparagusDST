
PrefabFiles = {
	"asparagus_ag",
}

-- debug speed
GLOBAL.TUNING.SEEDS_GROW_TIME = 5

local function plant_normal_postinit(prefab)
	-- table.insert(prefab.assets, Asset("ANIM", "anim/asparagus_ag_build.zip"))

	local old_onmatured = prefab.components.crop.onmatured
	function onmatured_override(inst)
		print("plant_normal matured override")
		if inst.components.crop.product_prefab == "asparagus_ag" then
			print("we are asparagus")
	    inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
	    inst.AnimState:OverrideSymbol("swap_grown", "asparagus_ag_build", "asparagus_ag_sym")
	  else
			old_onmatured(inst)
		end
	end

	prefab.components.crop:SetOnMatureFn(onmatured_override)
end
AddPrefabPostInit("plant_normal", plant_normal_postinit)
