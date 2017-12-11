local AG_Sharable = Class(function(self, inst)
    print("AG_Sharable component constructor")
    self.inst = inst
end)

function AG_Sharable:CollectUseActions(inst, doer, target, actions, right)
    if right and target.hasTag("rabbit") then
        table.insert(actions, ACTIONS.AG_SHARE)
    end
end

return AG_Sharable
