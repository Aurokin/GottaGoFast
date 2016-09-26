function GottaGoFast.InitModels()
  GottaGoFast.InitModelPlayer();
  GottaGoFast.InitModelDungeon();
  GottaGoFast.InitModelRun();
end

function GottaGoFast.InitDungeon(name, zoneID, objectives)
  if (GottaGoFast.FindDungeonByZoneID(zoneID) == nil and name ~= nil and zoneID ~= nil and next(objectives) ~= nil) then
    table.insert(GottaGoFast.db.profile.History, GottaGoFast.Models.Dungeon.New(name, zoneID, objectives));
  end
end

function GottaGoFast.StoreRun()
  if (GottaGoFast.CurrentCM and next(GottaGoFast.CurrentCM) ~= nil) then
    local cCM = GottaGoFast.CurrentCM;
    local k, d = GottaGoFast.FindDungeonByZoneID(GottaGoFast.zoneID);
    if (GottaGoFast.Completed == true and d ~= nil) then
      local deaths = cCM["Deaths"];
      local startTime = cCM["StartTime"];
      local endTime = GetTime();
      local totalTime = endTime - (startTime - (deaths * 5));
      local level = cCM["Level"];
      local objectiveTimes = cCM["ObjectiveTimes"];
      local affixes = cCM["Affixes"];
      local players = GottaGoFast.GetPlayersFromGroup();
      if (startTime ~= nil and endTime ~= nil and totalTime ~= nil and deaths ~= nil and level ~= nil and next(objectiveTimes) ~= nil and next(affixes) ~= nil and next(players) ~= nil) then  
        local run = GottaGoFast.Models.Run.New(startTime, endTime, totalTime, deaths, level, objectiveTimes, affixes, players);
        GottaGoFast.Models.Dungeon.AddRun(d, run);
      end
    end
  end
end
