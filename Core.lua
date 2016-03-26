GottaGoFast = LibStub("AceAddon-3.0"):NewAddon("GottaGoFast", "AceConsole-3.0", "AceEvent-3.0");

function GottaGoFast:OnInitialize()
    -- Called when the addon is loaded
    -- Register Frames
    GottaGoFastFrame = CreateFrame("Frame", "GottaGoFastFrame", UIParent);
    GottaGoFastTimerFrame = CreateFrame("Frame", "GottaGoFastTimerFrame", GottaGoFastFrame);
    GottaGoFastObjectiveFrame = CreateFrame("Frame", "GottaGoFastObjectiveFrame", GottaGoFastFrame);
end

function GottaGoFast:OnEnable()
    -- Called when the addon is enabled

    -- Register Events
    self:RegisterEvent("CHALLENGE_MODE_START");
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
    self:RegisterEvent("CHALLENGE_MODE_RESET");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("SCENARIO_POI_UPDATE");

    -- Setup AddOn
    GottaGoFast.InitState();
    GottaGoFast.InitFrame();

end

function GottaGoFast:OnDisable()
    -- Called when the addon is disabled
end

function GottaGoFast:CHALLENGE_MODE_START()
  self:Print("CM Start");
  GottaGoFast.StartCM();
end

function GottaGoFast:CHALLENGE_MODE_COMPLETED()
  self:Print("CM Complete");
  GottaGoFast.CompleteCM();
end

function GottaGoFast:CHALLENGE_MODE_RESET()
  self:Print("CM Reset");
  local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
  GottaGoFast.WipeCM();
  GottaGoFast.SetupCM(currentZoneID);
end

function GottaGoFast:PLAYER_ENTERING_WORLD()
  self:Print("Player Entered World");
  local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
  if (difficulty == 8 and GottaGoFastInstanceInfo[currentZoneID]) then
    self:Print("Player Entered Challenge Mode");
    GottaGoFast.WipeCM();
    GottaGoFast.SetupCM(currentZoneID);
    GottaGoFast.UpdateTimer();
    GottaGoFast.UpdateObjectives();
    GottaGoFast.inCM = true;
    GottaGoFast.inTW = false;
    GottaGoFastFrame:SetScript("OnUpdate", GottaGoFast.UpdateCM);
    GottaGoFast.ShowFrames();
  elseif (difficulty == 24) then
    self:Print("Player Entered Timewalking Dungeon");
    GottaGoFast.inCM = false;
    GottaGoFast.inTW = true;
    GottaGoFastFrame:SetScript("OnUpdate", GottaGoFast.UpdateTW);
    -- Hiding Frames For Now
    GottaGoFast.HideFrames();
  else
    GottaGoFast.WipeCM();
    GottaGoFast.inCM = false;
    GottaGoFast.inTW = false;
    GottaGoFastFrame:SetScript("OnUpdate", nil);
    GottaGoFast.HideFrames();
  end
end

function GottaGoFast:SCENARIO_POI_UPDATE()
  if (GottaGoFast.inCM) then
    self:Print("Scenario POI Update");
    GottaGoFast.UpdateCMInformation();
    GottaGoFast.UpdateObjectives();
  elseif (GottaGoFast.inTW) then
    self:Print("Scenario POI Update");
  end
end
