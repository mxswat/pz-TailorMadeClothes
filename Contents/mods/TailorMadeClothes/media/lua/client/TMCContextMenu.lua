-- This using this globals IMHO is awful, but this is also how TIS does it  so, idk it's free code I guess
---@diagnostic disable-next-line: lowercase-global
clickedPlayer = nil;


function TMConTakeMeasures(worldobjects, player, otherPlayer)
    if luautils.walkAdj(player, otherPlayer:getCurrentSquare()) then
        ISTimedActionQueue.add(TMCMeasuresAction:new(player, otherPlayer))
    end
end

function TMCOnFillWorldObjectContextMenu(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
    if playerObj:isAsleep() then return end

    for _, v in ipairs(worldobjects) do
        ISWorldObjectContextMenu.fetch(v, player, true);
    end

    if clickedPlayer and clickedPlayer ~= playerObj then
        local text = getText("ContextMenu_TakeMeasures", clickedPlayer:getDisplayName())
        local option = context:addOption(text, worldobjects, TMConTakeMeasures, playerObj, clickedPlayer)
        if not playerObj:getInventory():getItemFromType('TailorMadeClothes.TapeMeasure', true, true) then
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            option.notAvailable = true;
            tooltip.description = getText("ContextMenu_MissingMeasureTape");
            option.toolTip = tooltip;
        end
        if math.abs(playerObj:getX() - clickedPlayer:getX()) > 2 or math.abs(playerObj:getY() - clickedPlayer:getY()) > 2 then
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            option.notAvailable = true;
            tooltip.description = getText("ContextMenu_GetCloser", clickedPlayer:getDisplayName());
            option.toolTip = tooltip;
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(TMCOnFillWorldObjectContextMenu);
