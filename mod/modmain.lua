PrefabFiles = {
	"asparagus_ag",
	"asparagus_ag_cooked",
	"asparagus_ag_seeds",
}

-- debug speed
GLOBAL.TUNING.SEEDS_GROW_TIME = 5

-- PostInit for plant_normal to swap the sprite of asparagus when it is grown in a farm
-- Have to do it this way so the function is run after world init (and we can access TheWorld)
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


local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
local SHARE = AddAction("SHARE", "Share", function(act)
	-- local targ = act.invobject or act.target
	-- if targ.components.watch then
	-- 	return act.doer.components.predictor:Predict(targ)
	-- end
	if not GLOBAL.TheWorld.ismastersim then
		return true
	end

	local shareditem = act.invobject
	local halffood = GLOBAL.SpawnPrefab(shareditem.prefab)
	halffood.components.edible.healthvalue = halffood.components.edible.healthvalue/2
	halffood.components.edible.hungervalue = halffood.components.edible.hungervalue/2
	halffood.components.edible.sanityvalue = halffood.components.edible.sanityvalue/2 + 5

	act.target.sg:GoToState("quickeat", {feed=halffood, feeder=act.doer})
	print("SHARE action")
	return true
end)
SHARE.priority = 4
AddStategraphActionHandler("wilson", ActionHandler(SHARE, "share"))
AddStategraphActionHandler("wilson_client", ActionHandler(SHARE, "share"))

local function share_item(inst, doer, target, actions, right)
	-- print("checking share_item")
  -- Do logic here to check if we should enable the actions
	-- Use doer.replica and doer:HasTag("foo") for testing, not the
	-- components directly
	if right and target:HasTag("player") then
		table.insert(actions, GLOBAL.ACTIONS.SHARE)
	end
end
AddComponentAction("USEITEM", "sharable", share_item)

-- States
local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES

local share_sg = State({
  name = "share",
  tags = { "sharing" },

  onenter = function(inst)
    inst.components.locomotor:Stop()
		inst.sg.statemem.shareitem = inst:GetBufferedAction().invobject
		inst.sg.statemem.action = inst:GetBufferedAction()
    inst.AnimState:PlayAnimation("give")
    inst.AnimState:PushAnimation("give_pst", false)
  end,

  timeline =
  {
    TimeEvent(13 * FRAMES, function(inst)
    	inst:PerformBufferedAction()
    end),
  },

  events =
  {
    EventHandler("animqueueover", function(inst)
      if inst.AnimState:AnimDone() then
				local shareditem = inst.sg.statemem.shareitem
				local halffood = GLOBAL.SpawnPrefab(shareditem.prefab)
				halffood.components.edible.healthvalue = halffood.components.edible.healthvalue/2
				halffood.components.edible.hungervalue = halffood.components.edible.hungervalue/2
				halffood.components.edible.sanityvalue = halffood.components.edible.sanityvalue/2 + 5
				local eataction = GLOBAL.BufferedAction(
					inst,
					nil,
					GLOBAL.ACTIONS.EAT,
					halffood
				)
				inst:PushBufferedAction(eataction)
				if shareditem.components.stackable ~= nil then
					print("removing original item")
					shareditem.components.stackable:Get():Remove()
				else
					shareditem:Remove()
				end
        inst.sg:GoToState("quickeat")
				-- inst.sg:GoToState(
				-- 	"quickeat",
				-- 	{feed=inst.sg.statemem.shareitem, feeder=inst}
				-- )
      end
    end),
  },
})
AddStategraphState("wilson", share_sg)

local share_sg_client = State({
  name = "share",
  tags = { "sharing" },

  onenter = function(inst)
    inst.components.locomotor:Stop()
    if not inst:HasTag("sharing") then
      inst.AnimState:PlayAnimation("give")
    end

    inst:PerformPreviewBufferedAction()
    inst.sg:SetTimeout(2)
  end,

  onupdate = function(inst)
    if inst:HasTag("sharing") then
      if inst.entity:FlattenMovementPrediction() then
        inst.sg:GoToState("idle", "noanim")
      end
    elseif inst.bufferedaction == nil then
      inst.AnimState:PlayAnimation("give_pst")
      inst.sg:GoToState("idle", true)
    end
  end,

  ontimeout = function(inst)
    inst:ClearBufferedAction()
    inst.AnimState:PlayAnimation("give_pst")
    inst.sg:GoToState("idle", true)
  end,
})
AddStategraphState("wilson_client", share_sg_client)
