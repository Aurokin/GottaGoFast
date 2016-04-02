function GottaGoFast.GetUnlocked(info)
  return GottaGoFast.unlocked;
end

function GottaGoFast.SetUnlocked(info, value)
  GottaGoFast.unlocked = value;
  GottaGoFastFrame:SetMovable(GottaGoFast.unlocked);
  GottaGoFastFrame:EnableMouse(GottaGoFast.unlocked);
end

function GottaGoFast.GetGoldTimer(info)
  return GottaGoFast.db.profile.GoldTimer;
end

function GottaGoFast.SetGoldTimer(info, value)
  GottaGoFast.db.profile.GoldTimer = value;
end

function GottaGoFast.GetTrueTimer(info)
  return GottaGoFast.db.profile.TrueTimer;
end

function GottaGoFast.SetTrueTimer(info, value)
  GottaGoFast.db.profile.TrueTimer = value;
end

function GottaGoFast.GetTimerX(info)
  return GottaGoFast.db.profile.TimerX;
end

function GottaGoFast.SetTimerX(info, value)
  GottaGoFast.db.profile.TimerX = value;
  GottaGoFastTimerFrame:ClearAllPoints();
  GottaGoFastTimerFrame:SetPoint("TOP", GottaGoFast.db.profile.TimerX, GottaGoFast.db.profile.TimerY);
end

function GottaGoFast.GetTimerY(info)
  return GottaGoFast.db.profile.TimerY;
end

function GottaGoFast.SetTimerY(info, value)
  GottaGoFast.db.profile.TimerY = value;
  GottaGoFastTimerFrame:ClearAllPoints();
  GottaGoFastTimerFrame:SetPoint("TOP", GottaGoFast.db.profile.TimerX, GottaGoFast.db.profile.TimerY);
end

function GottaGoFast.GetTimerFont(info)
  return GottaGoFast.db.profile.TimerFont;
end

function GottaGoFast.SetTimerFont(info, value)
  GottaGoFast.db.profile.TimerFont = value;
  GottaGoFastTimerFrame.font:SetFont(GottaGoFast.LSM:Fetch("font", GottaGoFast.db.profile.TimerFont), GottaGoFast.db.profile.TimerFontSize, "OUTLINE");
end

function GottaGoFast.GetObjectiveFont(info)
  return GottaGoFast.db.profile.ObjectiveFont;
end

function GottaGoFast.SetObjectiveFont(info, value)
  GottaGoFast.db.profile.ObjectiveFont = value;
  GottaGoFastObjectiveFrame.font:SetFont(GottaGoFast.LSM:Fetch("font", GottaGoFast.db.profile.ObjectiveFont), GottaGoFast.db.profile.ObjectiveFontSize, "OUTLINE");
end

function GottaGoFast.GetTimerFontSize(info)
  return GottaGoFast.db.profile.TimerFontSize;
end

function GottaGoFast.SetTimerFontSize(info, value)
  GottaGoFast.db.profile.TimerFontSize = value;
  GottaGoFastTimerFrame.font:SetFont(GottaGoFast.LSM:Fetch("font", GottaGoFast.db.profile.TimerFont), GottaGoFast.db.profile.TimerFontSize, "OUTLINE");
end

function GottaGoFast.GetTimerAlign(info)
  return GottaGoFast.db.profile.TimerAlign;
end

function GottaGoFast.SetTimerAlign(info, value)
  GottaGoFast.db.profile.TimerAlign = value;
  GottaGoFastTimerFrame.font:SetJustifyH(GottaGoFast.db.profile.TimerAlign);
end

function GottaGoFast.GetObjectiveX(info)
  return GottaGoFast.db.profile.ObjectiveX;
end

function GottaGoFast.SetObjectiveX(info, value)
  GottaGoFast.db.profile.ObjectiveX = value;
  GottaGoFastObjectiveFrame:ClearAllPoints();
  GottaGoFastObjectiveFrame:SetPoint("TOP", GottaGoFast.db.profile.ObjectiveX, GottaGoFast.db.profile.ObjectiveY);
end

function GottaGoFast.GetObjectiveY(info)
  return GottaGoFast.db.profile.ObjectiveY;
end

function GottaGoFast.SetObjectiveY(info, value)
  GottaGoFast.db.profile.ObjectiveY = value;
  GottaGoFastObjectiveFrame:ClearAllPoints();
  GottaGoFastObjectiveFrame:SetPoint("TOP", GottaGoFast.db.profile.ObjectiveX, GottaGoFast.db.profile.ObjectiveY);
end

function GottaGoFast.GetObjectiveFontSize(info)
  return GottaGoFast.db.profile.ObjectiveFontSize;
end

function GottaGoFast.SetObjectiveFontSize(info, value)
  GottaGoFast.db.profile.ObjectiveFontSize = value;
  GottaGoFastObjectiveFrame.font:SetFont(GottaGoFast.LSM:Fetch("font", GottaGoFast.db.profile.ObjectiveFont), GottaGoFast.db.profile.ObjectiveFontSize, "OUTLINE");
end

function GottaGoFast.GetObjectiveAlign(info)
  return GottaGoFast.db.profile.ObjectiveAlign;
end

function GottaGoFast.SetObjectiveAlign(info, value)
  GottaGoFast.db.profile.ObjectiveAlign = value;
  GottaGoFastObjectiveFrame.font:SetJustifyH(GottaGoFast.db.profile.ObjectiveAlign);
end

function GottaGoFast.GetCMAutoStart(info)
  return GottaGoFast.db.profile.CMAutoStart;
end

function GottaGoFast.SetCMAutoStart(info, value)
  GottaGoFast.db.profile.CMAutoStart = value;
end


function GottaGoFast.InitOptions()
  GottaGoFast.LSM = LibStub:GetLibrary("LibSharedMedia-3.0");
  GottaGoFast.LSM:Register("font", "Myriad Condensed Web", "Interface\\Addons\\GottaGoFast\\MyriadCondensedWeb.ttf")
  local defaults = {
    profile = {
      GoldTimer = true,
      TrueTimer = true,
      CMAutoStart = false,
      FrameAnchor = "RIGHT",
      FrameX = 0,
      FrameY = 0,
      TimerAlign = "CENTER",
      TimerX = 0,
      TimerY = 0,
      TimerFont = "Myriad Condensed Web",
      TimerFontSize = 29,
      ObjectiveAlign = "LEFT",
      ObjectiveX = 0,
      ObjectiveY = -40,
      ObjectiveFont = "Myriad Condensed Web",
      ObjectiveFontSize = 21,
    },
  }
  local options = {
    name = "GottaGoFast",
    handler = GottaGoFast,
    type = "group",
    args = {
      cms = {
        name = "Challenge Modes",
        type = "group",
        args = {
          TrueTimer = {
            order = 2,
            type = "toggle",
            name = "True Timer",
            desc = "Toggles True Timer",
            get = GottaGoFast.GetTrueTimer,
            set = GottaGoFast.SetTrueTimer,
          },
          CMAutoStart = {
            order = 1,
            type = "toggle",
            name = "CM Auto Start",
            desc = "Auto Starts CM When Orb Is Clicked",
            get = GottaGoFast.GetCMAutoStart,
            set = GottaGoFast.SetCMAutoStart,
          },
        }
      },
      display = {
        name = "Display",
        type = "group",
        args = {
          unlocked = {
            order = 1,
            type = "toggle",
            name = "Unlocked",
            desc = "Toggles Unlock State Of Timer Frame",
            get = GottaGoFast.GetUnlocked,
            set = GottaGoFast.SetUnlocked,
          },
          GoldTimer = {
            order = 2,
            type = "toggle",
            name = "Gold Timer",
            desc = "Toggles Gold Timer",
            get = GottaGoFast.GetGoldTimer,
            set = GottaGoFast.SetGoldTimer,
          },
          TimerX = {
            order = 3,
            type = "range",
            name = "Timer X Offset",
            desc = "Default: 0",
            min = -100,
            max = 100,
            step = 1,
            get = GottaGoFast.GetTimerX,
            set = GottaGoFast.SetTimerX,
          },
          TimerY = {
            order = 4,
            type = "range",
            name = "Timer Y Offset",
            desc = "Default: 0",
            min = -100,
            max = 100,
            step = 1,
            get = GottaGoFast.GetTimerY,
            set = GottaGoFast.SetTimerY,
          },
          TimerFontSize = {
            order = 7,
            type = "range",
            name = "Timer Font Size",
            desc = "Default: 29",
            min = 8,
            max = 32,
            step = 1,
            get = GottaGoFast.GetTimerFontSize,
            set = GottaGoFast.SetTimerFontSize,
          },
          ObjectiveX = {
            order = 5,
            type = "range",
            name = "Objective X Offset",
            desc = "Default: 0",
            min = -100,
            max = 100,
            step = 1,
            get = GottaGoFast.GetObjectiveX,
            set = GottaGoFast.SetObjectiveX,
          },
          ObjectiveY = {
            order = 6,
            type = "range",
            name = "Objective Y Offset",
            desc = "Default: -40",
            min = -100,
            max = 100,
            step = 1,
            get = GottaGoFast.GetObjectiveY,
            set = GottaGoFast.SetObjectiveY,
          },
          ObjectiveFontSize = {
            order = 8,
            type = "range",
            name = "Objective Font Size",
            desc = "Default: 21",
            min = 8,
            max = 32,
            step = 1,
            get = GottaGoFast.GetObjectiveFontSize,
            set = GottaGoFast.SetObjectiveFontSize,
          },
          TimerAlign = {
            order = 9,
            type = "select",
            name = "Timer Align",
            desc = "Default: CENTER",
            values = {["LEFT"] = "LEFT", ["CENTER"] = "CENTER", ["RIGHT"] = "RIGHT"},
            get = GottaGoFast.GetTimerAlign,
            set = GottaGoFast.SetTimerAlign,
          },
          ObjectiveAlign = {
            order = 10,
            type = "select",
            name = "Objective Align",
            desc = "Default: LEFT",
            values = {["LEFT"] = "LEFT", ["CENTER"] = "CENTER", ["RIGHT"] = "RIGHT"},
            get = GottaGoFast.GetObjectiveAlign,
            set = GottaGoFast.SetObjectiveAlign,
          },
          TimerFont = {
            order = 11,
            type = "select",
            dialogControl = "LSM30_Font",
            name = "Timer Font",
            desc = "Default: Arial, Monospaced Fonts like MyriadCondensedWeb are recommended",
            values = GottaGoFast.LSM:HashTable("font"),
            get = GottaGoFast.GetTimerFont,
            set = GottaGoFast.SetTimerFont,
          },
          ObjectiveFont = {
            order = 12,
            type = "select",
            dialogControl = "LSM30_Font",
            name = "Objective Font",
            desc = "Default: Arial, Monospaced Fonts like MyriadCondensedWeb are recommended",
            values = GottaGoFast.LSM:HashTable("font"),
            get = GottaGoFast.GetObjectiveFont,
            set = GottaGoFast.SetObjectiveFont,
          },
        },
      },
    },
  };
  GottaGoFast.db = LibStub("AceDB-3.0"):New("GottaGoFastDB", defaults, true);
  LibStub("AceConfig-3.0"):RegisterOptionsTable("GottaGoFast", options);
  GottaGoFast.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GottaGoFast", "GottaGoFast");
end
