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

function GottaGoFast.InitOptions()
  local defaults = {
    profile = {
      GoldTimer = true,
      FrameAnchor = "RIGHT",
      FrameX = 0,
      FrameY = 0,
    },
  }
  local options = {
    name = "GottaGoFast",
    handler = GottaGoFast,
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
    },
  };
  GottaGoFast.db = LibStub("AceDB-3.0"):New("GottaGoFastDB", defaults, true);
  LibStub("AceConfig-3.0"):RegisterOptionsTable("GottaGoFast", options);
  GottaGoFast.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GottaGoFast", "GottaGoFast");
end
