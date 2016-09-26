-- Define Objects
-- Run
local Run = {}

function Run.New(startTime, endTime, totalTime, deaths, level, objectiveTimes, affixes, players)
  local self = {};
  self.active = false;
  self.startTime = startTime;
  self.endTime = endTime;
  self.totalTime = totalTime;
  self.deaths = deaths;
  self.level = level;
  self.objectiveTimes = objectiveTimes;
  self.affixes = affixes;
  self.players = players;
  return self
end

function Run.GetActive(self)
  return self.active
end

function Run.SetActive(self, active)
  self.active = active
end

function Run.GetStartTime(self)
  return self.startTime
end

function Run.SetStartTime(self, startTime)
  self.startTime = startTime
end

function Run.GetEndTime(self)
  return self.endTime
end

function Run.SetEndTime(self, endTime)
  self.endTime = endTime
end

function Run.GetTotalTime(self)
  return self.totalTime
end

function Run.SetTotalTime(self, totalTime)
  self.totalTime = totalTime
end

function Run.GetDeaths(self)
  return self.deaths
end

function Run.SetDeaths(self, deaths)
  self.deaths = deaths
end

function Run.GetLevel(self)
  return self.level
end

function Run.SetLevel(self, level)
  self.level = level
end

function Run.GetObjectiveTimes(self)
  return self.objectiveTimes
end

function Run.SetObjectiveTimes(self, objectiveTimes)
  self.objectiveTimes = objectiveTimes
end

function Run.GetAffixes(self)
  return self.affixes
end

function Run.SetAffixes(self, affixes)
  self.affixes = affixes
end

function Run.GetPlayers(self)
  return self.players
end

function Run.SetPlayers(self, players)
  self.players = players
end

function GottaGoFast.InitModelRun()
  GottaGoFast.Models.Run = Run;
end
