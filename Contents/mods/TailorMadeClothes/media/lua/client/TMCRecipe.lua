function GetClothingToTailorMade(scriptItems)
    local allScriptItems = getScriptManager():getAllItems();
    for i = 1, allScriptItems:size() do
        local item = allScriptItems:get(i - 1);
        local isClothing = tostring(item:getType()) == "Clothing"
        local isCosmetic = item:isCosmetic()
        local isWorldRender = item:isWorldRender()
        if isClothing and isWorldRender and not isCosmetic then
            scriptItems:add(item);
        end
    end
end

function OnCreateTailorMadeClothing(inputItems, resultItem, player)
    local clothingToTailor = inputItems:get(0) -- assumes any tool comes after this in recipes.txt
    local bodyMeasurementsItem = inputItems:get(1) -- assumes any tool comes after this in recipes.txt

    local bodyMeasurementsID = bodyMeasurementsItem:getModData()["bodyMeasurementsID"]

    local cothingModData = clothingToTailor:getModData()
    cothingModData["bodyMeasurementsID"] = bodyMeasurementsID
end


function OnCreateSelfBodyMeasurement(inputItems, resultItem, player)
    local itemModData = resultItem:getModData()
    itemModData["bodyMeasurementsID"] = GetBodyMeasurementsID(player)

    local MAXIMUM_RENAME_LENGTH = 28
    local name = "Measurement of " .. player:getUsername()
    resultItem:setName(string.sub(name, 1, MAXIMUM_RENAME_LENGTH));
end