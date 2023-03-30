local QBCore = exports['qb-core']:GetCoreObject()
local ObjectList = {} -- Object, Model, Coords, IsRendered, SpawnRange

local PlacingObject, LoadedObjects = false, false
local CurrentModel, CurrentObject, CurrentObjectType, CurrentObjectName, CurrentSpawnRange, CurrentCoords = nil, nil, nil, nil, nil, nil

local group = {user = true}

local ObjectTypes = {
    "none",
    "container",
}

local ObjectParams = {
    ["container"] = {event = "ps-objectspawner:client:containers", icon = "fas fa-question", label = "Container", SpawnRange = 200},
    ["none"] = {SpawnRange = 200},
}

--Functions
local function openMenu()
    SetNuiFocus(true, true)
    if LoadedObjects then
        SendNUIMessage({ 
            action = "open",
        })
    else
        LoadedObjects = true
        local tempList = {}
        -- In js, objects cant have number keys so we need to change them to strings to be treated as object
        -- If we dont do this it will be sent as an array which is bad because it fills in missing array indexes
        --   from 0 to min(table ids)
        for k, v in pairs(ObjectList) do
            tempList[""..k] = v
        end
        SendNUIMessage({
            action = "load",
            objects = Objects, 
            objectTypes = ObjectTypes, 
            spawnedObjects = tempList,
        })
    end
end

local function CancelPlacement()
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        QBCore.Functions.TriggerCallback('ps-objectspawner:server:RequestObjects', function(incObjectList)
            ObjectList = incObjectList
        end)
    end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(ObjectList) do
            if v["IsRendered"] then
                RemoveRoadNodeSpeedZone(v["speedzone"])
                DeleteObject(v["object"])
            end
        end
    end
end)

RegisterNetEvent('ps-objectspawner:client:registerobjectcommand', function(perms)
    permission = perms
    if permission == 'god' then
        openMenu()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('ps-objectspawner:server:RequestObjects', function(incObjectList)
        ObjectList = incObjectList
    end)
end)

local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    -- draw it once to set up layout
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 152, true))
    ButtonMessage("Cancel")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 153, true))
    ButtonMessage("Place object")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 190, true))
    Button(GetControlInstructionalButton(2, 189, true))
    ButtonMessage("Rotate object")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

local function RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1000)
    end
end

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

local function PlaceSpawnedObject(heading)
    local ObjectType = 'prop' --will be replaced with inputted prop type later, which will determine options/events
    local Options = { SpawnRange = tonumber(CurrentSpawnRange) }
    if ObjectParams[CurrentObjectType] ~= nil then
        Options = { event = ObjectParams[CurrentObjectType].event, icon = ObjectParams[CurrentObjectType].icon, label = ObjectParams[CurrentObjectType].label, SpawnRange = ObjectParams[CurrentObjectType].SpawnRange} --will be replaced with config of options later
    end
    local finalCoords = vector4(CurrentCoords.x, CurrentCoords.y, CurrentCoords.z, heading)
    TriggerServerEvent("ps-objectspawner:server:CreateNewObject", CurrentModel, finalCoords, CurrentObjectType, Options, CurrentObjectName)
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
    CurrentModel = nil
end

local function CreateSpawnedObject(data)
    if data.object == nil then return print("Invalid Object") end
    local object = data.object
    CurrentObjectType = data.type
    CurrentObjectName = data.name or "Random Object"
    CurrentSpawnRange = ObjectParams[objectType] and ObjectParams[objectType] ~= nil or data.distance or 15
    
    RequestSpawnObject(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, true, true, false)
    local heading = 0.0
    SetEntityHeading(CurrentObject, 0)
    
    SetEntityAlpha(CurrentObject, 150)
    SetEntityCollision(CurrentObject, false, false)
    -- SetEntityInvincible(CurrentObject, true)
    FreezeEntityPosition(CurrentObject, true)

    CreateThread(function()
        form = setupScaleform("instructional_buttons")
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(20.0)
            CurrentCoords = coords

            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)

            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
            end
            
            if IsControlJustPressed(0, 174) then
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end
    
            if IsControlJustPressed(0, 175) then
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end
            
            if IsControlJustPressed(0, 44) then
                CancelPlacement()
            end

            SetEntityHeading(CurrentObject, heading)
            if IsControlJustPressed(0, 38) then
                PlaceSpawnedObject(heading)
            end
            
            Wait(1)
        end
    end)
end
exports("CreateSpawnedObject", CreateSpawnedObject)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('spawn', function(data, cb)
    SetNuiFocus(false, false)
    PlacingObject = true
    CreateSpawnedObject(data)
    cb('ok')
end)

RegisterNetEvent("ps-objectspawner:client:UpdateObjectList", function(NewObjectList)
    ObjectList = NewObjectList
end)

CreateThread(function()
	while true do
		for k, v in pairs(ObjectList) do
            local data = v["options"]
            local objectCoords = v["coords"]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - vector3(objectCoords["x"], objectCoords["y"], objectCoords["z"]))
			if dist < data["SpawnRange"] and v["IsRendered"] == nil then
                
				local object = CreateObject(v["model"], objectCoords["x"], objectCoords["y"], objectCoords["z"], false, false, false)
                SetEntityHeading(object, objectCoords["w"])
                SetEntityAlpha(object, 0)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
				v["IsRendered"] = true
                v["object"] = object

                --local model = GetEntityModel(object)
                --local min, max = GetModelDimensions(model) --TODO: get max model dimensions to generate the SpeedZone radius
                v["speedzone"] = AddRoadNodeSpeedZone(objectCoords["x"], objectCoords["y"], objectCoords["z"], 10.0, 0, false)

                for i = 0, 255, 51 do
                    Wait(50)
                    SetEntityAlpha(v["object"], i, false)
                end
                if ObjectParams[v.type] ~= nil and ObjectParams[v.type].event ~= nil then
                    exports['qb-target']:AddTargetEntity(object, {
                        --debugPoly=true,
                        options = {
                            {
                                name = "object_spawner_"..object, 
                                event = ObjectParams[v.type].event,
                                icon = ObjectParams[v.type].icon,
                                label = ObjectParams[v.type].label,
                                id = v.id
                            },
                        },
                        distance = ObjectParams[data.SpawnRange]
                    })
                end
			end
			
			if dist >= data["SpawnRange"] and v["IsRendered"] then
                if DoesEntityExist(v["object"]) then 
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(v["object"], i, false)
                    end
                    DeleteObject(v["object"])

                    RemoveRoadNodeSpeedZone(v["speedzone"])
                    v["object"] = nil
                    v["IsRendered"] = nil
                end
			end
		end
        Wait(1500)
	end
end)

RegisterNetEvent("ps-objectspawner:client:AddObject", function(object)
    ObjectList[object.id] = object
    if permission == 'god' then
        SendNUIMessage({ 
            action = "created",
            newSpawnedObject = object,
        })
    end
end)

RegisterNUICallback('tpTo', function(data, cb)
    if permission == 'god' then
        SetEntityCoords(PlayerPedId(), data.coords.x+1, data.coords.y+1, data.coords.z)
    end
    cb('ok')
end)

RegisterNUICallback('delete', function(data, cb)
    if permission == 'god' then
        TriggerServerEvent("ps-objectspawner:server:DeleteObject", data.id)
    end
    cb('ok')
end)

RegisterNetEvent('ps-objectspawner:client:receiveObjectDelete', function(id)
    if permission == 'god' then
        if ObjectList[id]["IsRendered"] then
            if DoesEntityExist(ObjectList[id]["object"]) then 
                for i = 255, 0, -51 do
                    Wait(50)
                    SetEntityAlpha(ObjectList[id]["object"], i, false)
                end
                DeleteObject(ObjectList[id]["object"])

                RemoveRoadNodeSpeedZone(ObjectList[id]["speedzone"])
            end
        end
        ObjectList[id] = nil
        SendNUIMessage({ 
            action = "delete",
            id = id,
        })
    end
end)