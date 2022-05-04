local QBCore = exports["qb-core"]:GetCoreObject()
local ServerObjects = {}

RegisterNetEvent("objects:CreateNewObject", function(model, coords, objecttype, options)
    local src = source
    if model and coords and objecttype then
        MySQL.query.await("INSERT INTO objects (model, coords, type, options) VALUES (?, ?, ?, ?)", { model, json.encode(coords), objecttype, json.encode(options) })
        ServerObjects[#ServerObjects+1] = {model = model, coords = json.encode(coords), type = objecttype, options = json.encode(options) }
        TriggerClientEvent("objects:UpdateObjectList", -1, ServerObjects)
    else 
        print("[P-OBJECTS]: Object or coords was invalid")
    end
end)

function CreateDataObject(mode, coords, type, options)
    MySQL.query.await("INSERT INTO objects (model, coords, type, options) VALUES (?, ?, ?, ?)", { model, json.encode(coords), type, json.encode(options) })
end
exports("CreateDataObject", CreateDataObject)

CreateThread(function()
    ServerObjects = MySQL.query.await('SELECT * FROM objects', {})
    Wait(5000)
    TriggerClientEvent("objects:UpdateObjectList", -1, ServerObjects)
end)

QBCore.Functions.CreateCallback("RequestObjects", function(source, cb)
    cb(ServerObjects)
end)
