local function loopIt(player, item)
    if not item:IsClothing() then
        return
    end
    local modData = item:getModData();
    if not modData or not modData["bodyMeasurementsID"] then
        -- Notthing, it has never been modified
        return
    end
    local bodyMeasurementsID = modData["bodyMeasurementsID"]
    if GetBodyMeasurementsID(player) ~= bodyMeasurementsID then
        -- It needs to be reset to original values
        item:setRunSpeedModifier(item:getScriptItem().runSpeedModifier);
        item:setCombatSpeedModifier(item:getScriptItem().combatSpeedModifier);
        return
    end
    item:setRunSpeedModifier(1);
    item:setCombatSpeedModifier(1);
end

local function onClothingUpdated(player)
    local wornItems = player:getWornItems();
    if not wornItems or wornItems:size() < 1 then
        return
    end

    local size = wornItems:size() - 1
    for i = 0, size do
        local item = wornItems:getItems():get(i);
        loopIt(player, item)
    end
end

Events.OnClothingUpdated.Add(onClothingUpdated);
