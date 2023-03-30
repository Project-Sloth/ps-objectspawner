local QBCore = exports["qb-core"]:GetCoreObject()
local ServerObjects = {}

QBCore.Commands.Add('object', 'Makes you add objects', {}, true, function(source)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local permission = 'god'
    QBCore.Functions.AddPermission(Player.PlayerData.source, permission)
    if QBCore.Functions.HasPermission(source, 'god') then
        TriggerClientEvent('ps-objectspawner:client:registerobjectcommand', source, permission)
    end
end, 'god')

RegisterNetEvent("ps-objectspawner:server:CreateNewObject", function(model, coords, objecttype, options, objectname)
    local source = source
    local hasperms = QBCore.Functions.HasPermission(source, 'god')
    if hasperms then
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
    local source = source
    local hasperms = QBCore.Functions.HasPermission(source, 'god')
    if hasperms then
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