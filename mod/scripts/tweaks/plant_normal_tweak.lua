-- PostInit for plant_normal to swap the sprite of asparagus when it is grown in a farm
-- Have to do it inline so the function is run after world init (and we can access TheWorld)
AddPrefabPostInit("plant_normal", function(prefab)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end

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
end)
