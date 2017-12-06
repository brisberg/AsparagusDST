-- In a prefab file, you need to list all the assets it requires.
-- These can be either standard assets, or custom ones in your mod
-- folder.
local Assets =
{
	Asset("ANIM", "anim/asparagus_ag_build.zip"), -- a standard asset
	Asset("ATLAS", "images/inventoryimages/asparagus_ag.xml"),    -- a custom asset, found in the mod folder
}

-- Write a local function that creates, customizes, and returns an instance of the prefab.
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("sprites")
  inst.AnimState:SetBuild("asparagus_ag_build")
  inst.AnimState:PlayAnimation("idle", true)

	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/asparagus_ag.xml"

  return inst
end


-- Add some strings for this item
STRINGS.NAMES.BINDINGRING = "Asparagus"

--Strings courtesy of The Silent Dapper Darkness
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BINDINGRING = "I can use this to join my friend."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BINDINGRING = "It's so shiny. Almost as pretty as a fire."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BINDINGRING = "Wolfgang does not wear jewellery. Could help Wolfgang, however?"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BINDINGRING = "I can use this to return to the one person who understands my pain."
STRINGS.CHARACTERS.WX78.DESCRIBE.BINDINGRING = "RELOCATION DEVICE. THE POWER SOURCE IS A MYSTERY."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BINDINGRING = "I've not done any research to back this up, but I have a hunch about this ring."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BINDINGRING = "It's like one of those tree rings, eh? But shinier. I bet Lucy would have loved this."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BINDINGRING = "Now if only this ring would get me out of here."

STRINGS.RECIPE_DESC.BINDINGRING = "Binds to your soul."

-- Finally, return a new prefab with the construction function and assets.
return Prefab( "common/inventory/asparagus_ag", fn, Assets)
