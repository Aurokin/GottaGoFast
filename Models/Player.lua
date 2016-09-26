-- Define Objects
-- Player
local Player = {}
Player.__index = Player

setmetatable(Player, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Player.New(name, class, role)
  local self = setmetatable({}, Player)
  self.name = name;
  self.class = class;
  self.role = role;
  return self
end

function Player:GetName()
  return self.name
end

function Player:SetName(name)
  self.name = name
end

function Player:GetClass()
  return self.class
end

function Player:SetClass(class)
  self.class = class
end

function Player:GetRole()
  return self.role
end

function Player:SetRole(role)
  self.role = role
end

function GottaGoFast.InitModelPlayer()
  GottaGoFast.Models.Player = Player;
end

function GottaGoFast.GetGroupPrefix()
  if IsInRaid() then
    return "raid";
  else
    return "party";
  end
end

function GottaGoFast.GetPlayer(unit)
  local name = GetUnitName(unit, false);
  local class = UnitClass(unit);
  local role = UnitGroupRolesAssigned(unit);
  return GottaGoFast.Models.Player.New(name, class, role);
end

function GottaGoFast.GetPlayersFromGroup()
  local players = {};
  local members = GetNumGroupMembers();
  local prefix = GottaGoFast.GetGroupPrefix();
  for i = 1, members - 1 do
    table.insert(players, GottaGoFast.GetPlayer(prefix .. i));
  end
  table.insert(players, GottaGoFast.GetPlayer("player"));
  return players;
end
