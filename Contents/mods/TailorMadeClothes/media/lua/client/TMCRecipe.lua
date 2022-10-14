local function addClothingsToRecipe(scriptItems, item)
    local isClothing = tostring(item:getType()) == "Clothing"
    local isCosmetic = item:isCosmetic()
    local instancedItem = item:InstanceItem(nil)
    local isWorldRender = item:isWorldRender()
    if not isClothing or isCosmetic or not isWorldRender or not instancedItem then
        return
    end
    local hasRunSpeedModifier = instancedItem:getRunSpeedModifier() < 1
    local hasCombatSpeedModifier = instancedItem:getCombatSpeedModifier() < 1
    if not (hasRunSpeedModifier or hasCombatSpeedModifier) then
        return
    end
    scriptItems:add(item);
end

function GetClothingToTailorMade(scriptItems)
    local allScriptItems = getScriptManager():getAllItems();
    for i = 1, allScriptItems:size() do
        local item = allScriptItems:get(i - 1);
        addClothingsToRecipe(scriptItems, item)
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


function TMCGiveTailoringXP(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 15);
end