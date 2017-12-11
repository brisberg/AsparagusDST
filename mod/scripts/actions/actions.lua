----- TEMP ACTIONS ---
local ACTIONS = _G.ACTIONS
-- require('actions')
ACTIONS.AG_SHARE = {
    priority = 1,
    strfn = nil,
    testfn = nil,
    instant = true,
    rmb = true,
    distance = 1,
}
-- ACTION(1, nil, true, 3)

ACTIONS.AG_SHARE.fn = function(act)
  print("calling AG_SHARE function")
  if act.target ~= nil and
      act.target:IsValid() and
      act.target.sg:HasStateTag("idle") and
      not (act.target.sg:HasStateTag("busy") or
          act.target.sg:HasStateTag("attacking") or
          act.target.sg:HasStateTag("sleeping") or
          act.target:HasTag("playerghost")) and
      act.target.components.eater ~= nil and
      act.invobject.components.edible ~= nil and
      act.target.components.eater:CanEat(act.invobject) and
      (TheNet:GetPVPEnabled() or
      not (act.invobject:HasTag("badfood") or
          act.invobject:HasTag("spoiled"))) then

      if act.target.components.eater:PrefersToEat(act.invobject) then
          local food = act.invobject.components.inventoryitem:RemoveFromOwner()
          if food ~= nil then
              act.target:AddChild(food)
              food:RemoveFromScene()
              food.components.inventoryitem:HibernateLivingItem()
              food.persists = false
              act.target.sg:GoToState(
                  (act.target:HasTag("beaver") and "beavereat") or
                  (food.components.edible.foodtype == FOODTYPE.MEAT and "eat") or
                  "quickeat",
                  {feed=food,feeder=act.doer}
              )
              return true
          end
      else
          act.target:PushEvent("wonteatfood", { food = act.invobject })
          return true -- the action still "succeeded", there's just no result on this end
      end
  end
end

ACTIONS.AG_SHARE.id = "AG_SHARE"
