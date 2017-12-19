-- In a prefab file, you need to list all the assets it requires.
-- These can be either standard assets, or custom ones in your mod
-- folder.
local Assets =
{
	Asset("ANIM", "anim/asparagus_ag_build.zip"), -- a standard asset
	Asset("ATLAS", "images/inventoryimages/asparagus_ag.xml"),    -- a custom asset, found in the mod folder
}

-- Append a record to the VEGGIES table (veggies.lua) so normal seeds will pick us
VEGGIES["asparagus_ag"] = {
    seed_weight = 1,
    health = TUNING.HEALING_TINY,
    hunger = TUNING.CALORIES_SMALL,
    sanity = TUNING.SANITY_SUPERTINY,
    perishtime = TUNING.PERISH_MED,
    cooked_health = TUNING.HEALING_SMALL+1,
    cooked_hunger = TUNING.CALORIES_SMALL,
    cooked_sanity = TUNING.SANITY_TINY,
    cooked_perishtime = TUNING.PERISH_FAST,
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
	  inst.AnimState:PlayAnimation("idle")

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = VEGGIES["asparagus_ag"].health
    inst.components.edible.hungervalue = VEGGIES["asparagus_ag"].hunger
    inst.components.edible.sanityvalue = VEGGIES["asparagus_ag"].sanity or 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(VEGGIES["asparagus_ag"].perishtime)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	  inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/asparagus_ag.xml"

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    ---------------------

    inst:AddComponent("bait")

    ------------------------------------------------

    inst:AddComponent("tradable")

    ------------------------------------------------

    inst:AddComponent("cookable")
    inst.components.cookable.product = "asparagus_ag_cooked"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

-- Add some strings for this item
STRINGS.NAMES.ASPARAGUS_AG = "Asparagus"

--Strings courtesy of The Silent Dapper Darkness
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ASPARAGUS_AG = "Succulent asparagus spears."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.ASPARAGUS_AG = "It's so shiny. Almost as pretty as a fire."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ASPARAGUS_AG = "Wolfgang does not wear jewellery. Could help Wolfgang, however?"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.ASPARAGUS_AG = "I can use this to return to the one person who understands my pain."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.ASPARAGUS_AG = "RELOCATION DEVICE. THE POWER SOURCE IS A MYSTERY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ASPARAGUS_AG = "I've not done any research to back this up, but I have a hunch about this ring."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.ASPARAGUS_AG = "It's like one of those tree rings, eh? But shinier. I bet Lucy would have loved this."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ASPARAGUS_AG = "Now if only this ring would get me out of here."

-- Finally, return a new prefab with the construction function and assets.
return Prefab( "common/inventory/asparagus_ag", fn, Assets)
