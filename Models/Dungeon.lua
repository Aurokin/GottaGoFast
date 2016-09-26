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

function GottaGoFast.InitModelDungeon()
  GottaGoFast.Models.Dungeon = Dungeon;
end

function GottaGoFast.FindDungeonByZoneID(zoneID)
  if (next(GottaGoFast.db.profile.History) ~= nil) then
    for k, d in pairs(GottaGoFast.db.profile.History) do
      if (d:GetZoneID() == name) then
        return d;
      end
    end
  end
  return nil;
end
