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
				local halffood = shareditem.components.sharable:SpawnHalfItemToken()
        if halffood then
  				local eataction = GLOBAL.BufferedAction(
  					inst,
  					nil,
  					GLOBAL.ACTIONS.EAT,
  					halffood
  				)
  				inst:PushBufferedAction(eataction)
  				if shareditem.components.stackable ~= nil then
  					shareditem.components.stackable:Get():Remove()
  				else
  					shareditem:Remove()
  				end
        end
        inst.sg:GoToState("quickeat")
      else
        -- Food wasn't actually sharable
        inst.sg:GoToState("idle")
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
