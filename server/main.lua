local QBCore = exports["qb-core"]:GetCoreObject()
local ServerObjects = {}

RegisterNetEvent("ps-objectspawner:server:CreateNewObject", function(model, coords, objecttype, options, objectname)
    local src = source
    if QBCore.Functions.HasPermission(src, 'god') then
        if model and coords then
            local data = MySQL.query.await("INSERT INTO objects (model, coords, type, options, name) VALUES (?, ?, ?, ?, ?)", { model, json.encode(coords), objecttype, json.encode(options), objectname })
            ServerObjects[data.insertId] = {id = data.insertId, model = model, coords = coords, type = objecttype, name = objectname, options = options}
            TriggerClientEvent("ps-objectspawner:client:AddObject", -1, {id = data.insertId, model = model, coords = coords, type = objecttype, name = objectname, options = options})
        else 
            print("[PS-OBJECTSPAWNER]: Object or coords was invalid")
        end
    else
        print("[PS-OBJECTSPAWNER]: You don't have permissions for this")
    end
end)

CreateThread(function()
    local results = MySQL.query.await('SELECT * FROM objects', {})
    --Wait(5000)
    --TriggerClientEvent("ps-objectspawner:client:UpdateObjectList", -1, ServerObjects)
    for k, v in pairs(results) do
        ServerObjects[v["id"]] = {
            id = v["id"],
            model = v["model"],
            coords = json.decode(v["coords"]),
            type = v["type"],
            name = v["name"] or "",
            options = json.decode(v["options"]),
        }
    end
end)

QBCore.Functions.CreateCallback("ps-objectspawner:server:RequestObjects", function(source, cb)
    cb(ServerObjects)
end)

RegisterNetEvent("ps-objectspawner:server:DeleteObject", function(objectid)
    local src = source
    if QBCore.Functions.HasPermission(src, 'god') then
        if objectid > 0 then
            local data = MySQL.query.await('DELETE FROM objects WHERE id = ?', {objectid})
            ServerObjects[objectid] = nil
            TriggerClientEvent("ps-objectspawner:client:receiveObjectDelete", -1, objectid)
        end
    else
        print("[PS-OBJECTSPAWNER]: You don't have permissions for this")
    end
end)

local function CreateDataObject(mode, coords, type, options, objectname)
    MySQL.query.await("INSERT INTO objects (model, coords, type, options, name) VALUES (?, ?, ?, ?, ?)", { model, json.encode(coords), type, json.encode(options), objectname })
end

exports("CreateDataObject", CreateDataObject)