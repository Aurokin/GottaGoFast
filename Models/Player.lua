-- Define Objects
-- Player
local Player = {}
Player.__index = Player

setmetatable(Player, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Player.New(name, server, class, iLvl, spec, role)
  local self = setmetatable({}, Player)
  self.name = name;
  self.server = server;
  self.class = class;
  self.iLvl = iLvl;
  self.spec = spec;
  self.role = role;
  return self
end

function Player:GetName()
  return self.name
end

function Player:SetName(name)
  self.name = name
end

function Player:GetServer()
  return self.server
end

function Player:SetServer(server)
  self.server = server
end

function Player:GetClass()
  return self.class
end

function Player:SetClass(class)
  self.class = class
end

function Player:GetILvl()
  return self.iLvl
end

function Player:SetILvl(iLvl)
  self.iLvl = iLvl
end

function Player:GetSpec()
  return self.spec
end

function Player:SetSpec(spec)
  self.spec = spec
end

function Player:GetRole()
  return self.role
end

function Player:SetRole(role)
  self.role = role
end

GottaGoFast.Models.Player = Player;
