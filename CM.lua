function GottaGoFast.UpdateCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.UpdateCMTimer();
    -- Hopefully use SCENARIO_POI_UPDATE to update objectives
  end
end

function GottaGoFast.BuildCMTooltip()
  local newTooltip;
  local cmLevel, affixes, empowered = C_ChallengeMode.GetActiveKeystoneInfo();
  if (cmLevel) then
    newTooltip = "Level " .. cmLevel .. "\n\n";
    for i, affixID in ipairs(affixes) do
      local affixName, affixDesc, affixNum = C_ChallengeMode.GetAffixInfo(affixID);
      newTooltip = newTooltip .. affixName .. "\n";
    end
    if (empowered) then
      newTooltip = newTooltip .. "\nEmpowered!";
    else
      newTooltip = newTooltip .. "\nDepleated";
    end
    GottaGoFast.tooltip = newTooltip;
  else
    GottaGoFast.tooltip = GottaGoFast.defaultTooltip;
  end
end

function GottaGoFast.SetupCM(currentZoneID)
  local _, _, steps = C_Scenario.GetStepInfo();
  local cmLevel, affixes, empowered = C_ChallengeMode.GetActiveKeystoneInfo();
  GottaGoFast.CurrentCM = {};
  GottaGoFast.CurrentCM["StartTime"] = nil;
  GottaGoFast.CurrentCM["Time"] = nil;
  GottaGoFast.CurrentCM["String"] = nil;
  GottaGoFast.CurrentCM["Name"], GottaGoFast.CurrentCM["ZoneID"], GottaGoFast.CurrentCM["GoldTimer"] = C_ChallengeMode.GetMapInfo(currentZoneID);
  GottaGoFast.CurrentCM["Steps"] = steps;
  GottaGoFast.CurrentCM["Level"] = cmLevel;
  GottaGoFast.CurrentCM["Bonus"] = "?";
  GottaGoFast.CurrentCM["Completed"] = false;
  GottaGoFast.CurrentCM["Affixes"] = {};
  GottaGoFast.CurrentCM["CurrentValues"] = {};
  GottaGoFast.CurrentCM["FinalValues"] = {};
  GottaGoFast.CurrentCM["ObjectiveTimes"] = {};
  GottaGoFast.CurrentCM["Bosses"] = {};

  if (cmLevel) then
    GottaGoFast.CurrentCM["Bonus"] = C_ChallengeMode.GetPowerLevelDamageHealthMod(cmLevel);
  end

  for i, affixID in ipairs(affixes) do
    local affixName, affixDesc, affixNum = C_ChallengeMode.GetAffixInfo(affixID);
    GottaGoFast.CurrentCM["Affixes"][affixID] = affixName;
  end

  for i = 1, steps do
    local name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
    GottaGoFast.CurrentCM["CurrentValues"][i] = curValue;
    GottaGoFast.CurrentCM["FinalValues"][i] = finalValue;
    GottaGoFast.CurrentCM["Bosses"][i] = name;
    if (i == steps) then
      GottaGoFast.CurrentCM["FinalValues"][i] = 100;
    end
  end

  GottaGoFast.BuildCMTooltip();
  GottaGoFast.HideObjectiveTracker();
end

function GottaGoFast.UpdateCMInformation()
  if (GottaGoFast.CurrentCM) then
    if (GottaGoFast.CurrentCM["Completed"] == false) then
      for i = 1, GottaGoFast.CurrentCM["Steps"] do
        local name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
        if (finalValue == 0 or not finalValue) then
          -- Final Value = 0 Means CM Complete
          GottaGoFast.CompleteCM();
          return false;
        end
        if (GottaGoFast.CurrentCM["CurrentValues"][i] ~= curValue) then
          -- Update Value
          GottaGoFast.CurrentCM["CurrentValues"][i] = curValue;
          if (curValue == finalValue or ((i == GottaGoFast.CurrentCM["Steps"]) and (curValue == GottaGoFast.CurrentCM["FinalValues"][i]))) then
            -- Add Objective Time
            GottaGoFast.CurrentCM["ObjectiveTimes"][i] = GottaGoFast.ObjectiveCompleteString(GottaGoFast.CurrentCM["Time"]);
          end
        elseif (GottaGoFast.CurrentCM["CurrentValues"][i] == GottaGoFast.CurrentCM["FinalValues"][i] and not GottaGoFast.CurrentCM["ObjectiveTimes"][i]) then
          -- Objective Already Complete But No Time Filled Out (Re-Log / Re-Zone)
          GottaGoFast.CurrentCM["ObjectiveTimes"][i] = "?";
        end
      end
    end
  end
end

function GottaGoFast.CMFinalParse()
  if (GottaGoFast.CurrentCM) then
    for i = 1, GottaGoFast.CurrentCM["Steps"] do
      GottaGoFast.CurrentCM["CurrentValues"][i] = GottaGoFast.CurrentCM["FinalValues"][i];
      if (not GottaGoFast.CurrentCM["ObjectiveTimes"][i]) then
        GottaGoFast.CurrentCM["ObjectiveTimes"][i] = GottaGoFast.ObjectiveCompleteString(GottaGoFast.CurrentCM["Time"]);
      end
    end
  end
end

function GottaGoFast.WipeCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM = table.wipe(GottaGoFast.CurrentCM);
  end
end

function GottaGoFast.StartCM(offset)
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM["StartTime"] = GetTime() + offset;
    GottaGoFast.BuildCMTooltip();
  end
end

function GottaGoFast.CompleteCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM["Completed"] = true;
    GottaGoFast.CMFinalParse();
  end
end

function GottaGoFast.UpdateCMTimer()
  if (GottaGoFast.CurrentCM) then
    if (GottaGoFast.CurrentCM["Completed"] == false) then
      local time = "";
      local startMin, startSec, goldMin, goldSec;
      if (GottaGoFast.CurrentCM["StartTime"] and GottaGoFast.db.profile.TrueTimer) then
        local currentTime = GetTime();
        local secs = currentTime - GottaGoFast.CurrentCM["StartTime"];
        if (secs < 0) then
          startMin = "-00";
          startSec = GottaGoFast.FormatTimeMS(math.abs(secs));
        else
          startMin, startSec = GottaGoFast.SecondsToTime(secs);
          startMin = GottaGoFast.FormatTimeNoMS(startMin);
          startSec = GottaGoFast.FormatTimeMS(startSec);
        end
      else
        _, timeCM = GetWorldElapsedTime(1);
        startMin, startSec = GottaGoFast.SecondsToTime(timeCM);
        startMin = GottaGoFast.FormatTimeNoMS(startMin);
        startSec = GottaGoFast.FormatTimeNoMS(startSec);
      end
      time = startMin .. ":" .. startSec .. " ";
      GottaGoFast.CurrentCM["Time"] = time;

      goldMin, goldSec = GottaGoFast.SecondsToTime(GottaGoFast.CurrentCM["GoldTimer"]);
      goldMin = GottaGoFast.FormatTimeNoMS(goldMin);
      goldSec = GottaGoFast.FormatTimeNoMS(goldSec);

      if (GottaGoFast.db.profile.GoldTimer) then
        time = time .. "/ " .. goldMin .. ":" .. goldSec;
      end

      if (GottaGoFast.db.profile.LevelInTimer and GottaGoFast.CurrentCM["Level"]) then
        time = "[" .. GottaGoFast.CurrentCM["Level"] .. "] " .. time;
      end

      -- Update Frame
      GottaGoFastTimerFrame.font:SetText(GottaGoFast.ColorTimer(time));
      GottaGoFast.ResizeFrame();
    end
  end
end

function GottaGoFast.UpdateCMObjectives()
  if (GottaGoFast.CurrentCM) then
    local objectiveString = "";
    if (GottaGoFast.db.profile.LevelInObjectives and GottaGoFast.CurrentCM["Level"]) then
      objectiveString = objectiveString .. GottaGoFast.ObjectiveExtraString("Level " .. GottaGoFast.CurrentCM["Level"] .. " - (+" .. GottaGoFast.CurrentCM["Bonus"] .. "%)\n");
    end
    if (GottaGoFast.db.profile.AffixesInObjectives and next(GottaGoFast.CurrentCM["Affixes"])) then
      local affixString = "";
      for k, v in pairs(GottaGoFast.CurrentCM["Affixes"]) do
        affixString = affixString .. v .. " - ";
      end
      objectiveString = objectiveString .. GottaGoFast.ObjectiveExtraString(string.sub(affixString, 1, string.len(affixString) - 3) .. "\n");
    end
    for i = 1, GottaGoFast.CurrentCM["Steps"] do
      if (i == GottaGoFast.CurrentCM["Steps"]) then
        -- Last Step Should Be Enemies
        objectiveString = objectiveString .. GottaGoFast.ObjectiveEnemyString(GottaGoFast.CurrentCM["Bosses"][i], GottaGoFast.CurrentCM["CurrentValues"][i]);
      else
        objectiveString = objectiveString .. GottaGoFast.ObjectiveString(GottaGoFast.CurrentCM["Bosses"][i], GottaGoFast.CurrentCM["CurrentValues"][i], GottaGoFast.CurrentCM["FinalValues"][i]);
      end
      if (GottaGoFast.CurrentCM["ObjectiveTimes"][i]) then
        -- Completed Objective
        objectiveString = objectiveString .. GottaGoFast.ObjectiveCompletedString(GottaGoFast.CurrentCM["ObjectiveTimes"][i]);
      end
      objectiveString = objectiveString .. "\n";
    end
    GottaGoFastObjectiveFrame.font:SetText(objectiveString);
    GottaGoFast.ResizeFrame();
  end
end
