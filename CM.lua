function GottaGoFast.UpdateCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.UpdateTimer();
    -- Hopefully use SCENARIO_POI_UPDATE to update objectives
  end
end

function GottaGoFast.SetupCM(currentZoneID)
  local _, _, steps = C_Scenario.GetStepInfo();
  GottaGoFast.CurrentCM = {};
  GottaGoFast.CurrentCM["StartTime"] = nil;
  GottaGoFast.CurrentCM["Time"] = nil;
  GottaGoFast.CurrentCM["String"] = nil;
  GottaGoFast.CurrentCM["GoldTimer"] = GottaGoFastInstanceInfo[currentZoneID]["GoldTimer"];
  GottaGoFast.CurrentCM["Steps"] = steps;
  GottaGoFast.CurrentCM["Completed"] = false;
  GottaGoFast.CurrentCM["CurrentValues"] = {};
  GottaGoFast.CurrentCM["FinalValues"] = {};
  GottaGoFast.CurrentCM["ObjectiveTimes"] = {};
  GottaGoFast.CurrentCM["Bosses"] = {};

  for i = 1, steps do
    local name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
    GottaGoFast.CurrentCM["CurrentValues"][i] = curValue;
    GottaGoFast.CurrentCM["FinalValues"][i] = finalValue;
    GottaGoFast.CurrentCM["Bosses"][i] = name;
  end

  ObjectiveTrackerFrame:SetScript("OnEvent", nil);
  ObjectiveTrackerFrame:Hide();

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
          if (curValue == finalValue) then
            -- Add Objective Time
            GottaGoFast.CurrentCM["ObjectiveTimes"][i] = string.format("|c%s%s|r", "000ff000", GottaGoFast.CurrentCM["Time"]);
          end
        elseif (GottaGoFast.CurrentCM["CurrentValues"][i] == GottaGoFast.CurrentCM["FinalValues"][i] and not GottaGoFast.CurrentCM["ObjectiveTimes"][i]) then
          -- Objective Already Complete But No Time Filled Out (Re-Log / Re-Zone)
          GottaGoFast.CurrentCM["ObjectiveTimes"][i] = "?";
        end
      end
    end
  end
end

function GottaGoFast.FinalParse()
  if (GottaGoFast.CurrentCM) then
    for i = 1, GottaGoFast.CurrentCM["Steps"] do
      GottaGoFast.CurrentCM["CurrentValues"][i] = GottaGoFast.CurrentCM["FinalValues"][i];
      if (not GottaGoFast.CurrentCM["ObjectiveTimes"][i]) then
        GottaGoFast.CurrentCM["ObjectiveTimes"][i] = string.format("|c%s%s|r", "000ff000", GottaGoFast.CurrentCM["Time"]);
      end
    end
  end
end

function GottaGoFast.WipeCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM = table.wipe(GottaGoFast.CurrentCM);
  end
end

function GottaGoFast.StartCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM["StartTime"] = GetTime();
  end
end

function GottaGoFast.CompleteCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM["Completed"] = true;
    GottaGoFast.FinalParse();
  end
end

function GottaGoFast.UpdateTimer()
  if (GottaGoFast.CurrentCM) then
    if (GottaGoFast.CurrentCM["Completed"] == false) then
      local time = "";
      local startMin, startSec, goldMin, goldSec;
      if (GottaGoFast.CurrentCM["StartTime"]) then
        local currentTime = GetTime();
        local secs = currentTime - GottaGoFast.CurrentCM["StartTime"];
        startMin, startSec = GottaGoFast.SecondsToTime(secs);
        startMin = GottaGoFast.FormatTimeNoMS(startMin);
        startSec = GottaGoFast.FormatTimeMS(startSec);
      else
        _, timeCM = GetWorldElapsedTime(1);
        startMin, startSec = GottaGoFast.SecondsToTime(timeCM);
        startMin = GottaGoFast.FormatTimeNoMS(startMin);
        startSec = GottaGoFast.FormatTimeNoMS(startSec);
      end
      time = startMin .. ":" .. startSec;
      GottaGoFast.CurrentCM["Time"] = time;

      goldMin, goldSec = GottaGoFast.SecondsToTime(GottaGoFast.CurrentCM["GoldTimer"]);
      goldMin = GottaGoFast.FormatTimeNoMS(goldMin);
      goldSec = GottaGoFast.FormatTimeNoMS(goldSec);

      time = time .. " / " .. goldMin .. ":" .. goldSec;

      -- Update Frame
      GottaGoFastTimerFrame.font:SetText(time);
      GottaGoFast.ResizeFrame();
    end
  end
end

function GottaGoFast.UpdateObjectives()
  if (GottaGoFast.CurrentCM) then
    local objectiveString = "";
    for i = 1, GottaGoFast.CurrentCM["Steps"] do
      objectiveString = objectiveString .. string.format("%s - %d/%d", GottaGoFast.CurrentCM["Bosses"][i], GottaGoFast.CurrentCM["CurrentValues"][i], GottaGoFast.CurrentCM["FinalValues"][i]);
      if (GottaGoFast.CurrentCM["ObjectiveTimes"][i]) then
        -- Completed Objective
        objectiveString = objectiveString .. string.format(" - %s", GottaGoFast.CurrentCM["ObjectiveTimes"][i]);
      end
      objectiveString = objectiveString .. "\n";
    end
    GottaGoFastObjectiveFrame.font:SetText(objectiveString);
    GottaGoFast.ResizeFrame();
  end
end
