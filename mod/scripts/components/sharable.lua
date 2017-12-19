local Sharable = Class(function(self, inst)
    self.inst = inst
end)

function Sharable:SpawnHalfItemToken()
  if self.inst.components.edible then
    local halffood = SpawnPrefab(self.inst.prefab)
    halffood.components.edible.healthvalue = halffood.components.edible.healthvalue/2
    halffood.components.edible.hungervalue = halffood.components.edible.hungervalue/2
    halffood.components.edible.sanityvalue = halffood.components.edible.sanityvalue/2 + 5
    return halffood
  end
end

return Sharable
