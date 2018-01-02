local Assets =
{
	Asset("ANIM", "anim/cook_pot_food.zip"), -- a standard asset
	-- Asset("ATLAS", "images/inventoryimages/asparagus_ag.xml"),    -- a custom asset, found in the mod folder
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("cook_pot_food")
    inst.AnimState:SetBank("food")
    inst.AnimState:PlayAnimation("waffles", false)

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
    inst.components.edible.healthvalue = data.health
    inst.components.edible.hungervalue = data.hunger
    inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
    inst.components.edible.sanityvalue = data.sanity or 0
    inst.components.edible.temperaturedelta = data.temperature or 0
    inst.components.edible.temperatureduration = data.temperatureduration or 0
    inst.components.edible:SetOnEatenFn(data.oneatenfn)

    inst:AddComponent("inspectable")
    inst.wet_prefix = data.wet_prefix

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    if data.perishtime ~= nil and data.perishtime > 0 then
    	inst:AddComponent("perishable")
    	inst.components.perishable:SetPerishTime(data.perishtime)
    	inst.components.perishable:StartPerishing()
    	inst.components.perishable.onperishreplacement = "spoiled_food"
    end

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("bait")

    ------------------------------------------------
    inst:AddComponent("tradable")

    ------------------------------------------------

    return inst
end

return Prefab("common/inventory/bacon_asparagus_ag", fn, Assets)
