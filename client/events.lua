RegisterNetEvent('ps-objectspawner:client:containers', function(data)
    local objectData = data
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "container_"..objectData.id, {maxweight = 1000000, slots = 10})
    TriggerEvent("inventory:client:SetCurrentStash", "container_"..objectData.id)
end)