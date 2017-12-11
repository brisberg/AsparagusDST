-- In a prefab file, you need to list all the assets it requires.
-- These can be either standard assets, or custom ones in your mod
-- folder.
local Assets =
{
	Asset("ANIM", "anim/asparagus_ag_build.zip"), -- a standard asset
	Asset("ATLAS", "images/inventoryimages/asparagus_ag_cooked.xml"),    -- a custom asset, found in the mod folder
}

-- Write a local function that creates, customizes, and returns an instance of the prefab.
-- Copied from DST/data/scripts/prefabs/veggies.lua
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

  	inst.AnimState:SetBuild("asparagus_ag_build")
    inst.AnimState:SetBank("asparagus_ag_anim")
    inst.AnimState:PlayAnimation("cooked")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(VEGGIES["asparagus_ag"].cooked_perishtime)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = VEGGIES["asparagus_ag"].cooked_health
    inst.components.edible.hungervalue = VEGGIES["asparagus_ag"].cooked_hunger
    inst.components.edible.sanityvalue = VEGGIES["asparagus_ag"].cooked_sanity or 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
  	inst.components.inventoryitem.atlasname = "images/inventoryimages/asparagus_ag_cooked.xml"

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    ---------------------

    inst:AddComponent("bait")

    ------------------------------------------------
    inst:AddComponent("tradable")

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

-- Add some strings for this item
STRINGS.NAMES.ASPARAGUS_AG_COOKED = "Grilled Asparagus"

--Strings courtesy of The Silent Dapper Darkness
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ASPARAGUS_AG_COOKED = "Grilled asparagus spears."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.ASPARAGUS_AG_COOKED = "It's so shiny. Almost as pretty as a fire."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ASPARAGUS_AG_COOKED = "Wolfgang does not wear jewellery. Could help Wolfgang, however?"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.ASPARAGUS_AG_COOKED = "I can use this to return to the one person who understands my pain."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.ASPARAGUS_AG_COOKED = "RELOCATION DEVICE. THE POWER SOURCE IS A MYSTERY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ASPARAGUS_AG_COOKED = "I've not done any research to back this up, but I have a hunch about this ring."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.ASPARAGUS_AG_COOKED = "It's like one of those tree rings, eh? But shinier. I bet Lucy would have loved this."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ASPARAGUS_AG_COOKED = "Now if only this ring would get me out of here."

-- Finally, return a new prefab with the construction function and assets.
return Prefab( "common/inventory/asparagus_ag_cooked", fn, Assets)
