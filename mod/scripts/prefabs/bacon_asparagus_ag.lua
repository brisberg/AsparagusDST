local recipe = require("tweaks/bacon_asparagus_recipe")

local Assets =
{
	Asset("ANIM", "anim/bacon_asparagus_ag.zip"), -- a standard asset
	Asset("ATLAS", "images/inventoryimages/bacon_asparagus_ag.xml"),    -- a custom asset, found in the mod folder
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

		inst.AnimState:SetBuild("bacon_asparagus_ag")
	  inst.AnimState:SetBank("bacon_asparagus_ag_anim")
	  inst.AnimState:PlayAnimation("idle")

    inst:AddTag("preparedfood")
    -- if data.tags then
    --     for i,v in pairs(data.tags) do
    --         inst:AddTag(v)
    --     end
    -- end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = recipe.health
    inst.components.edible.hungervalue = recipe.hunger
    inst.components.edible.foodtype = recipe.foodtype or FOODTYPE.GENERIC
    inst.components.edible.sanityvalue = recipe.sanity or 0
    inst.components.edible.temperaturedelta = recipe.temperature or 0
    inst.components.edible.temperatureduration = recipe.temperatureduration or 0
    inst.components.edible:SetOnEatenFn(recipe.oneatenfn)

    inst:AddComponent("inspectable")
    inst.wet_prefix = recipe.wet_prefix

    inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/bacon_asparagus_ag.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    if recipe.perishtime ~= nil and recipe.perishtime > 0 then
    	inst:AddComponent("perishable")
    	inst.components.perishable:SetPerishTime(recipe.perishtime)
    	inst.components.perishable:StartPerishing()
    	inst.components.perishable.onperishreplacement = "spoiled_food"
    end

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("bait")

		inst:AddComponent("sharable")

    ------------------------------------------------
    inst:AddComponent("tradable")

    ------------------------------------------------

    return inst
end

-- Add some strings for this item
STRINGS.NAMES.BACON_ASPARAGUS_AG = "Bacon-wrapped Asparagus"

--Strings courtesy of The Silent Dapper Darkness
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BACON_ASPARAGUS_AG = "Juicy bacon asparagus skewers."

return Prefab("common/inventory/bacon_asparagus_ag", fn, Assets)
