--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

TMCMeasuresAction = ISBaseTimedAction:derive("TMCMeasuresAction");

TMCMeasuresAction.HealthWindows = {}

function TMCMeasuresAction.getHealthWindowForPlayer(playerObj)
    return TMCMeasuresAction.HealthWindows[playerObj]
end

function TMCMeasuresAction:isValid()
    return self.character:getAccessLevel() ~= "None" or
        (self.otherPlayerX == self.otherPlayer:getX() and self.otherPlayerY == self.otherPlayer:getY());
end

function TMCMeasuresAction:waitToStart()
    if self.character:isSeatedInVehicle() then
        return false
    end
    self.character:faceThisObject(self.otherPlayer)
    return self.character:shouldBeTurning()
end

function TMCMeasuresAction:update()
    self.character:faceThisObject(self.otherPlayer)
end

function TMCMeasuresAction:start()
    self:setActionAnim("MedicalCheck")
end

function TMCMeasuresAction:stop()
    ISBaseTimedAction.stop(self);
end

local MAXIMUM_RENAME_LENGTH = 28

function TMCMeasuresAction:perform()
    local bodyMeasurementsItem = self.character:getInventory():AddItem("TailorMadeClothes.BodyMeasurements")

    local name = "Measurement of "..self.otherPlayer:getUsername()

    bodyMeasurementsItem:setName(string.sub(name, 1, MAXIMUM_RENAME_LENGTH));

    local itemModData = bodyMeasurementsItem:getModData()
    itemModData["bodyMeasurementsIDs"] = {
        ['steamID'] = self.otherPlayer:getSteamID(),
        ['onlineID'] = self.otherPlayer:getOnlineID(),
    }

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function TMCMeasuresAction:new(character, otherPlayer)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.otherPlayer = otherPlayer;
    o.otherPlayerX = otherPlayer:getX();
    o.otherPlayerY = otherPlayer:getY();
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 150 - (character:getPerkLevel(Perks.Doctor) * 2.5);
    o.forceProgressBar = true;
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end
    return o;
end
