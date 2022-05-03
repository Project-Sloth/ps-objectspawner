local QBCore = exports["qb-core"]:GetCoreObject()
local ServerObjects = {}

RegisterNetEvent("objects:CreateNewObject", function(model, coords)
    local src = source
    if model and coords then
        MySQL.query.await("INSERT INTO objects (model, coords, options) VALUES (?, ?, ?)", { model, json.encode(coords), json.encode({SpawnRange = 5}) })
        ServerObjects[#ServerObjects+1] = {model = model, coords = json.encode(coords), type = "", options = json.encode({SpawnRange = 5}) }
        TriggerClientEvent("objects:UpdateObjectList", -1, ServerObjects)
    else 
        print("[P-OBJECTS]: Object or coords was invalid")
    end
end)



CreateThread(function()
    ServerObjects = MySQL.query.await('SELECT * FROM objects', {})
    Wait(5000)
    TriggerClientEvent("objects:UpdateObjectList", -1, ServerObjects)
end)

QBCore.Functions.CreateCallback("RequestObjects", function(source, cb)
    cb(ServerObjects)
end)
