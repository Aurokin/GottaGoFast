function GottaGoFast.InitState()
  -- Default AddOn Globals
  GottaGoFast.inTW = false;
  GottaGoFast.inCM = false;
  GottaGoFast.minWidth = 200;
  GottaGoFast.unlocked = false;
end

function GottaGoFast.InitFrame()
  -- Register Textures
  GottaGoFastFrame.texture = GottaGoFastFrame:CreateTexture(nil,"BACKGROUND");
  GottaGoFastTimerFrame.texture = GottaGoFastTimerFrame:CreateTexture(nil, "BACKGROUND");
  GottaGoFastObjectiveFrame.texture = GottaGoFastObjectiveFrame:CreateTexture(nil, "BACKGROUND");

  -- Register Fonts
  GottaGoFastTimerFrame.font = GottaGoFastTimerFrame:CreateFontString(nil, "OVERLAY");
  GottaGoFastObjectiveFrame.font = GottaGoFastObjectiveFrame:CreateFontString(nil, "OVERLAY");

  -- Move Frame When Unlocked
  GottaGoFastFrame:SetScript("OnMouseDown", function(self, button)
    if GottaGoFast.unlocked and button == "LeftButton" and not self.isMoving then
     self:StartMoving();
     self.isMoving = true;
    end
  end);

  GottaGoFastFrame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
     self:StopMovingOrSizing();
     self.isMoving = false;
     local point, relativeTo, relativePoint, xOffset, yOffset = GottaGoFastFrame:GetPoint(1);
     
     GottaGoFast.db.profile.FrameAnchor = point;
     GottaGoFast.db.profile.FrameX = xOffset;
     GottaGoFast.db.profile.FrameY = yOffset;
    end
  end);

  GottaGoFastFrame:SetScript("OnHide", function(self)
    if ( self.isMoving ) then
     self:StopMovingOrSizing();
     self.isMoving = false;
    end
  end);

  -- Set Frame Width / Height
  GottaGoFastFrame:SetHeight(340);
  GottaGoFastFrame:SetWidth(GottaGoFast.minWidth);
  GottaGoFastFrame:SetPoint(GottaGoFast.db.profile.FrameAnchor, GottaGoFast.db.profile.FrameX, GottaGoFast.db.profile.FrameY);
  GottaGoFastFrame:SetMovable(GottaGoFast.unlocked);
  GottaGoFastFrame:EnableMouse(GottaGoFast.unlocked);
  GottaGoFastTimerFrame:SetHeight(40);
  GottaGoFastTimerFrame:SetWidth(GottaGoFast.minWidth);
  GottaGoFastTimerFrame:SetPoint("TOP", 0, 0);
  GottaGoFastObjectiveFrame:SetHeight(300);
  GottaGoFastObjectiveFrame:SetWidth(GottaGoFast.minWidth);
  GottaGoFastObjectiveFrame:SetPoint("TOP", 0, -40);

  -- Set Font Settings
  GottaGoFastTimerFrame.font:SetAllPoints(true);
  GottaGoFastTimerFrame.font:SetJustifyH("CENTER");
  GottaGoFastTimerFrame.font:SetJustifyV("BOTTOM");
  GottaGoFastTimerFrame.font:SetFont("Interface\\Addons\\GottaGoFast\\MyriadCondensedWeb.ttf", 29, "OUTLINE");
  GottaGoFastTimerFrame.font:SetTextColor(1, 1, 1, 1);

  GottaGoFastObjectiveFrame.font:SetAllPoints(true);
  GottaGoFastObjectiveFrame.font:SetJustifyH("LEFT");
  GottaGoFastObjectiveFrame.font:SetJustifyV("TOP");
  GottaGoFastObjectiveFrame.font:SetFont("Interface\\Addons\\GottaGoFast\\MyriadCondensedWeb.ttf", 21, "OUTLINE");
  GottaGoFastObjectiveFrame.font:SetTextColor(1, 1, 1, 1);

  -- Remove Frame Background
  GottaGoFastFrame.texture:SetAllPoints(GottaGoFastFrame);
  GottaGoFastFrame.texture:SetTexture(0.5, 0.5, 0.5, 0);
  GottaGoFastTimerFrame.texture:SetAllPoints(GottaGoFastTimerFrame);
  GottaGoFastTimerFrame.texture:SetTexture(1, 0, 0, 0);
  GottaGoFastObjectiveFrame.texture:SetAllPoints(GottaGoFastObjectiveFrame);
  GottaGoFastObjectiveFrame.texture:SetTexture(0, 1, 0, 0);

end

function GottaGoFast.ResizeFrame()
  local width;
  local minWidth = GottaGoFast.minWidth;
  local timerWidth = GottaGoFastTimerFrame.font:GetStringWidth();
  local objectiveWidth = GottaGoFastObjectiveFrame.font:GetStringWidth();
  if (minWidth >= timerWidth and minWidth >= objectiveWidth) then
    -- minWidth
    width = minWidth;
  elseif (timerWidth >= minWidth and timerWidth >= objectiveWidth) then
    -- Timer Width
    width = timerWidth;
  else
    -- Objective Width
    width = objectiveWidth
  end
  GottaGoFastObjectiveFrame:SetWidth(width);
  GottaGoFastTimerFrame:SetWidth(width);
  GottaGoFastFrame:SetWidth(width);
end

function GottaGoFast.ShowFrames()
  GottaGoFastFrame:Show();
  GottaGoFastTimerFrame:Show();
  GottaGoFastObjectiveFrame:Show();
end

function GottaGoFast.HideFrames()
  GottaGoFastFrame:Hide();
  GottaGoFastTimerFrame:Hide();
  GottaGoFastObjectiveFrame:Hide();
end

function GottaGoFast.SecondsToTime(seconds)
  local min = math.floor(seconds/60);
  local sec = seconds - (min * 60);
  return min, sec;
end

function GottaGoFast.FormatTimeNoMS(time)
  if (time < 10) then
    time = string.format("0%d", time);
  else
    time = string.format("%d", time);
  end
  return time;
end

function GottaGoFast.FormatTimeMS(time)
  if (time < 10) then
    time = string.format("0%.3f", time);
  else
    time = string.format("%.3f", time);
  end
  return time;
end
