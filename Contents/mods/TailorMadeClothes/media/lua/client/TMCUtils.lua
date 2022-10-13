function GetBodyMeasurementsID(player)
    if not isClient() then
        return 'Player' -- for SP Only
    end
    return player:getUsername() -- for Steam and NoSteam
end