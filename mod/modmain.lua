PrefabFiles = {
	"asparagus_ag",
	"asparagus_ag_cooked",
	"asparagus_ag_seeds",
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


local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
local SHARE = Action(3)
SHARE.str = "Share"
SHARE.id = "SHARE"
SHARE.fn = function(act)
	-- local targ = act.invobject or act.target
	-- if targ.components.watch then
	-- 	return act.doer.components.predictor:Predict(targ)
	-- end
	-- act.doer.sg:GoToState("quickeat", {feed=act.invobject, feeder=act.doer})
	print("SHARE action")
end
AddAction(SHARE)
AddStategraphActionHandler("wilson", ActionHandler(SHARE, "share"))

local function share_item(inst, doer, target, actions, right)
	print("checking share_item")
  -- Do logic here to check if we should enable the actions
	-- Use doer.replica and doer:HasTag("foo") for testing, not the
	-- components directly
	if right then
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
  tags = { "giving" },

  onenter = function(inst)
    inst.components.locomotor:Stop()
		inst.sg.statemem.shareitem = inst:GetBufferedAction().invobject
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
        inst.sg:GoToState(
					"quickeat",
					{feed=inst.sg.statemem.shareitem, feeder=inst}
				)
      end
    end),
  },
})
AddStategraphState("wilson", share_sg)
