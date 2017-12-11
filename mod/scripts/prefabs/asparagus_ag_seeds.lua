-- In a prefab file, you need to list all the assets it requires.
-- These can be either standard assets, or custom ones in your mod
-- folder.
local Assets =
{
	Asset("ANIM", "anim/seeds.zip"), -- a standard asset
	Asset("ATLAS", "images/inventoryimages/asparagus_ag_seeds.xml"),    -- a custom asset, found in the mod folder
}

-- Write a local function that creates, customizes, and returns an instance of the prefab.
-- Copied from DST/data/scripts/prefabs/veggies.lua
local function fn()
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("seeds")
  inst.AnimState:SetBuild("seeds")
  inst.AnimState:SetRayTestOnBB(true)

  --cookable (from cookable component) added to pristine state for optimization
  inst:AddTag("cookable")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
      return inst
  end

  inst:AddComponent("edible")
  inst.components.edible.foodtype = FOODTYPE.SEEDS

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

  inst:AddComponent("tradable")
  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/asparagus_ag_seeds.xml"

  inst.AnimState:PlayAnimation("idle")
  inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
  inst.components.edible.hungervalue = TUNING.CALORIES_TINY

  inst:AddComponent("perishable")
  inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "spoiled_food"

  inst:AddComponent("cookable")
  inst.components.cookable.product = "seeds_cooked"

  inst:AddComponent("bait")
  inst:AddComponent("plantable")
  inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
  inst.components.plantable.product = "asparagus_ag"

  MakeHauntableLaunchAndPerish(inst)

  return inst
end

-- Add some strings for this item
STRINGS.NAMES.ASPARAGUS_AG_SEEDS = "Asparagus Seeds"

--Strings courtesy of The Silent Dapper Darkness
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ASPARAGUS_AG_SEEDS = "It's an asparagus seed."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.ASPARAGUS_AG_SEEDS = "It's so shiny. Almost as pretty as a fire."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ASPARAGUS_AG_SEEDS = "Wolfgang does not wear jewellery. Could help Wolfgang, however?"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.ASPARAGUS_AG_SEEDS = "I can use this to return to the one person who understands my pain."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.ASPARAGUS_AG_SEEDS = "RELOCATION DEVICE. THE POWER SOURCE IS A MYSTERY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ASPARAGUS_AG_SEEDS = "I've not done any research to back this up, but I have a hunch about this ring."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.ASPARAGUS_AG_SEEDS = "It's like one of those tree rings, eh? But shinier. I bet Lucy would have loved this."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ASPARAGUS_AG_SEEDS = "Now if only this ring would get me out of here."

-- Finally, return a new prefab with the construction function and assets.
return Prefab( "common/inventory/asparagus_ag_seeds", fn, Assets)
