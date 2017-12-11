PrefabFiles = {
	"asparagus_ag",
	"asparagus_ag_cooked",
}

-- debug speed
GLOBAL.TUNING.SEEDS_GROW_TIME = 5

-- PortInit for plant_normal to swap the sprite of asparagus when it is grown in a farm
local function plant_normal_postinit(prefab)

	local onmatured_base = prefab.components.crop.onmatured
	function onmatured_override(inst)
		if inst.components.crop.product_prefab == "asparagus_ag" then
	    inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
	    inst.AnimState:OverrideSymbol("swap_grown", "asparagus_ag_build", "asparagus_ag_sym")
	  else
			onmatured_base(inst)
		end
	end

	prefab.components.crop:SetOnMatureFn(onmatured_override)
end
AddPrefabPostInit("plant_normal", plant_normal_postinit)
