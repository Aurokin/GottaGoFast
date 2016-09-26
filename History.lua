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
