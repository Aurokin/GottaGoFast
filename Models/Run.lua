-- Define Objects
-- Run
local Run = {}
Run.__index = Run

setmetatable(Run, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Run.New(startTime, endTime, totalTime, level, objectiveTimes, affixes, players)
  local self = setmetatable({}, Run)
  self.active = true;
  self.startTime = startTime;
  self.endTime = endTime;
  self.totalTime = totalTime;
  self.level = level;
  self.objectiveTimes = objectiveTimes;
  self.affixes = affixes;
  self.players = players;
  return self
end

function Run:GetActive()
  return self.active
end

function Run:SetActive(active)
  self.active = active
end

function Run:GetStartTime()
  return self.startTime
end

function Run:SetStartTime(startTime)
  self.startTime = startTime
end

function Run:GetEndTime()
  return self.endTime
end

function Run:SetEndTime(endTime)
  self.endTime = endTime
end

function Run:GetTotalTime()
  return self.totalTime
end

function Run:SetTotalTime(totalTime)
  self.totalTime = totalTime
end

function Run:GetLevel()
  return self.level
end

function Run:SetLevel(level)
  self.level = level
end

function Run:GetObjectiveTimes()
  return self.objectiveTimes
end

function Run:SetObjectiveTimes(objectiveTimes)
  self.objectiveTimes = objectiveTimes
end

function Run:GetAffixes()
  return self.affixes
end

function Run:SetAffixes(affixes)
  self.affixes = affixes
end

function Run:GetPlayers()
  return self.players
end

function Run:SetPlayers(players)
  self.players = players
end



GottaGoFast.Models.Run = Run;
