-- Define Objects
-- Dungeon
local Dungeon = {}
Dungeon.__index = Dungeon

setmetatable(Dungeon, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Dungeon.New(name, zoneID, objectives)
  local self = setmetatable({}, Dungeon)
  self.name = name;
  self.zoneID = zoneID;
  self.objectives = objectives;
  self.runs = {};
  return self
end

function Dungeon:GetName()
  return self.name
end

function Dungeon:SetName(name)
  self.name = name
end

function Dungeon:GetZoneID()
  return self.zoneID
end

function Dungeon:SetZoneID(zoneID)
  self.zoneID = zoneID
end

function Dungeon:GetObjectives()
  return self.objectives
end

function Dungeon:SetObjectives(objectives)
  self.objectives = objectives
end

function Dungeon:GetRuns()
  return self.runs
end

function Dungeon:SetRuns(runs)
  self.runs = runs
end

GottaGoFast.Models.Dungeon = Dungeon;
