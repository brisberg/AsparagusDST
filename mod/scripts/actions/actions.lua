local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler

-- Component Action for "sharable"
local function share_item(inst, doer, target, actions, right)
  -- Do logic here to check if we should enable the actions
	-- Use doer.replica and doer:HasTag("foo") for testing, not the
	-- components directly
	if right and target:HasTag("player") then
		table.insert(actions, GLOBAL.ACTIONS.SHARE)
	end
end
AddComponentAction("USEITEM", "sharable", share_item)

-- Action method and SG Action Handlers
local SHARE = AddAction("SHARE", "Share", function(act)

	if not GLOBAL.TheWorld.ismastersim then
		return true
	end

	local shareditem = act.invobject
	if act.invobject and act.invobject.components.sharable then
		local halffood = act.invobject.components.sharable:SpawnHalfItemToken()
		act.target.sg:GoToState("quickeat", {feed=halffood, feeder=act.doer})
	end
	return true
end)
SHARE.priority = 4
AddStategraphActionHandler("wilson", ActionHandler(SHARE, "share"))
AddStategraphActionHandler("wilson_client", ActionHandler(SHARE, "share"))
