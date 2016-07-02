function GottaGoFast.UpdateCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.UpdateCMTimer();
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

  --@Auro: If you want to add an option for allowing the timer to pick up MS precision or not, change this line to pull from db.
  --This only picks up MS precision if TrueTimer is already enabled, so if truetimer is disabled the resync code does literally nothing.
  GottaGoFast.CurrentCM["ResyncAllowed"]=true;


  for i = 1, steps do
    local name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
    GottaGoFast.CurrentCM["CurrentValues"][i] = curValue;
    GottaGoFast.CurrentCM["FinalValues"][i] = finalValue;
    GottaGoFast.CurrentCM["Bosses"][i] = name;
  end

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
          if (curValue == finalValue) then
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
    GottaGoFast.CurrentCM["ResyncAllowed"]=false;
  end
end

function GottaGoFast.StartCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM["StartTime"] = GetTime();
    GottaGoFast.CurrentCM["ResyncAllowed"]=false;
  end
end

function GottaGoFast.CompleteCM()
  if (GottaGoFast.CurrentCM) then
    GottaGoFast.CurrentCM["Completed"] = true;
    GottaGoFast.CMFinalParse();
    GottaGoFast.CurrentCM["ResyncAllowed"]=false;
  end
end

function GottaGoFast.UpdateCMTimer()
  if (GottaGoFast.CurrentCM) then
    if (GottaGoFast.CurrentCM["Completed"] == false) then
      local time = "";
      local startMin, startSec, goldMin, goldSec;

      if (GottaGoFast.CurrentCM["StartTime"] == nil and GottaGoFast.db.profile.TrueTimer and GottaGoFast.CurrentCM and GottaGoFast.CurrentCM["ResyncAllowed"]) then
        local _,worldTime,timerType = GetWorldElapsedTime(1);
        
        --There is a bug with how instance time gets reset, this check prevents the timer from incrementing inappropriately after the instance is reset.
        if (worldTime > 0 and timerType == 2) then
          print(GetWorldElapsedTime(1));
          local localTime = GetTime();
          --This is likely overkill for what will ever happen, but logically the else requires it all to be true so I'm just going to check for it, just in case.
          if (GottaGoFast.CurrentCM["ResyncTimeDisplayed"] == nil or  GottaGoFast.CurrentCM["ResyncTimeLocal"] == nil or GottaGoFast.CurrentCM["ResyncTimeDisplayed"] == worldTime) then
            GottaGoFast.CurrentCM["ResyncTimeDisplayed"] = worldTime;
            GottaGoFast.CurrentCM["ResyncTimeLocal"] = localTime;
          else
            local expectedTime = (localTime + GottaGoFast.CurrentCM["ResyncTimeLocal"])/2;
            GottaGoFast.CurrentCM["StartTime"] = expectedTime - worldTime;
            GottaGoFast.CurrentCM["ResyncTimeDisplayed"] = nil;
            GottaGoFast.CurrentCM["ResyncTimeLocal"] = nil;
          end
        end
      end

      if (GottaGoFast.CurrentCM["StartTime"] and GottaGoFast.db.profile.TrueTimer) then
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
      time = startMin .. ":" .. startSec .. " ";
      GottaGoFast.CurrentCM["Time"] = time;

      goldMin, goldSec = GottaGoFast.SecondsToTime(GottaGoFast.CurrentCM["GoldTimer"]);
      goldMin = GottaGoFast.FormatTimeNoMS(goldMin);
      goldSec = GottaGoFast.FormatTimeNoMS(goldSec);

      if (GottaGoFast.db.profile.GoldTimer) then
        time = time .. "/ " .. goldMin .. ":" .. goldSec;
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
    for i = 1, GottaGoFast.CurrentCM["Steps"] do
      objectiveString = objectiveString .. GottaGoFast.ObjectiveString(GottaGoFast.CurrentCM["Bosses"][i], GottaGoFast.CurrentCM["CurrentValues"][i], GottaGoFast.CurrentCM["FinalValues"][i]);
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
