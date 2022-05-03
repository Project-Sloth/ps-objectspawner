local ObjectList = {} -- Object, Model, Coords, IsRendered, SpawnRange

local PlacingObject = false
local LoadedObjects = false
local CurrentModel = nil
local CurrentObject = nil
local CurrentCoords = nil
local CurrentDirection = "x"

RegisterCommand('object', function()
    openMenu()
end)

RegisterCommand('+PlaceObject', function()
    PlaceSpawnedObject()
end)
RegisterKeyMapping("+PlaceObject", "Place Object", "keyboard", "")

RegisterCommand('+CancelObject', function()
    CancelPlacement()
end)
RegisterKeyMapping("+CancelObject", "Cancel Placing Object", "keyboard", "")

RegisterCommand('+RotateObject', function()
    RotateObject(CurrentDirection)
end)
RegisterKeyMapping("+RotateObject", "Rotate Object", "keyboard", "")

RegisterCommand('+ToggleRotationMode', function()
    if CurrentDirection == "x" then 
        CurrentDirection = "y"
    elseif CurrentDirection == "y" then 
        CurrentDirection = "z"
    elseif CurrentDirection == "z" then 
        CurrentDirection = "x"
    end
    print(CurrentDirection)
end)
RegisterKeyMapping("+ToggleRotationMode", "Toggle Rotation Mode", "keyboard", "")

function openMenu()
    SetNuiFocus(true, true)
    if LoadedObjects then
        SendNUIMessage({ action = "open"})
    else
        LoadedObjects = true
        SendNUIMessage({ action = "load", objects = Objects })
    end
end


RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('spawn', function(data)
    SetNuiFocus(false, false)
    PlacingObject = true
    CreateSpawnedObject(data.object)
end)

function RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1000)
    end
end

function RotationToDirection(rotation)
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

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

function CreateSpawnedObject(object)
    RequestSpawnObject(object)

    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, true, true, false)
    SetEntityHeading(CurrentObject, GetEntityHeading(PlayerPedId()))
    SetEntityAlpha(CurrentObject, 150)
    SetEntityCollision(CurrentObject, false, false)
    SetEntityInvincible(CurrentObject, true)
    FreezeEntityPosition(CurrentObject, true)

    CreateThread(function()
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            CurrentCoords = coords
            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(CurrentObject)
            end
            Wait(5)
        end
    end)
end

function PlaceSpawnedObject()
    TriggerServerEvent("objects:CreateNewObject", CurrentModel, CurrentCoords)
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentCoords = nil
    CurrentModel = nil
end

function CancelPlacement()
    DeleteObject(CurrentObject)
    SetNuiFocus(true, true)
    PlacingObject = false
    CurrentObject = nil
    CurrentCoords = nil
end

function RotateObject(direction)
    if CurrentObject ~= nil then 

        local yaw = GetEntityRotation(CurrentObject, 1, false)
        local roll = GetEntityRoll(CurrentObject)
        local pitch = GetEntityPitch(CurrentObject)

        if direction == "x" then
            SetEntityRotation(CurrentObject, pitch + 1.0, roll, yaw.z, 1, false)
        elseif direction == "y" then
            SetEntityRotation(CurrentObject, pitch, roll + 1.0, yaw.z, 1, false)
        elseif direction == "z" then 
            SetEntityRotation(CurrentObject, pitch, roll, yaw.z + 1.0, 1, false)
        end
    else
        print("No Object to rotate!")
    end
end

RegisterNetEvent("objects:UpdateObjectList", function(NewObjectList)
    ObjectList = NewObjectList
    print("Object List Updated")
end)

CreateThread(function()
	while true do
		for _, v in pairs(ObjectList) do
            local data = json.decode(v["options"])
            local objectCoords = json.decode(v["coords"])
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - vector3(objectCoords["x"], objectCoords["y"], objectCoords["z"]))

			if dist < data["SpawnRange"] and v["IsRendered"] == nil then
				local object = CreateObject(v["model"], objectCoords["x"], objectCoords["y"], objectCoords["z"], true, false, false)
                SetEntityHeading(object, objectCoords["w"])
                SetEntityAlpha(object, 0)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
				v["IsRendered"] = true
                v["object"] = object

                for i = 0, 255, 51 do
                    Wait(50)
                    SetEntityAlpha(v["object"], i, false)
                end
			end
			
			if dist >= data["SpawnRange"] and v["IsRendered"] then
                if DoesEntityExist(v["object"]) then 
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(v["object"], i, false)
                    end
                    DeleteObject(v["object"])
                    v["object"] = nil
                    v["IsRendered"] = nil
                end
			end
		end
        Wait(1500)
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(ObjectList) do
            if v["IsRendered"] then
                DeleteObject(v["object"])
            end
        end
    end
end)