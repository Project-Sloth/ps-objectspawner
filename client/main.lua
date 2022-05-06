local ObjectList = {} -- Object, Model, Coords, IsRendered, SpawnRange

local PlacingObject = false
local LoadedObjects = false
local CurrentModel = nil
local CurrentObject = nil
local CurrentObjectType = nil
local CurrentSpawnRange = nil
local CurrentCoords = nil
local CurrentDirection = "x"

local ObjectTypes = {
    "none",
    "container",
}

local ObjectParams = {
    ["container"] = {event = "ps-objectspawner:client:containers", icon = "fas fa-question", label = "Container", SpawnRange = 200},
}

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(ObjectList) do
            if v["IsRendered"] then
                DeleteObject(v["object"])
            end
        end
    end
end)

local function openMenu()
    SetNuiFocus(true, true)
    if LoadedObjects then
        SendNUIMessage({ action = "open"})
    else
        LoadedObjects = true
        SendNUIMessage({ action = "load", objects = Objects, objectTypes = ObjectTypes })
    end
end

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
    Button(GetControlInstructionalButton(2, 153, true))
    ButtonMessage("Place object")
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
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

local function PlaceSpawnedObject()
    local ObjectType = 'prop' --will be replaced with inputted prop type later, which will determine options/events
    local Options = { SpawnRange = tonumber(CurrentSpawnRange) }
    if ObjectParams[CurrentObjectType] ~= nil then
        Options = { event = ObjectParams[CurrentObjectType].event, icon = ObjectParams[CurrentObjectType].icon, label = ObjectParams[CurrentObjectType].label, SpawnRange = ObjectParams[CurrentObjectType].SpawnRange} --will be replaced with config of options later
    end
    TriggerServerEvent("objects:CreateNewObject", CurrentModel, CurrentCoords, CurrentObjectType, Options)
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
    CurrentModel = nil
end

local function CreateSpawnedObject(data)
    if data.object == nil then return print("Invalid Object") end
    local object = data.object
    CurrentObjectType = data.type
    CurrentSpawnRange = ObjectParams[objectType] and ObjectParams[objectType] ~= nil or data.distance or 15
    
    RequestSpawnObject(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, true, true, false)
    SetEntityHeading(CurrentObject, GetEntityHeading(PlayerPedId()))
    SetEntityAlpha(CurrentObject, 150)
    SetEntityCollision(CurrentObject, false, false)
    SetEntityInvincible(CurrentObject, true)
    FreezeEntityPosition(CurrentObject, true)

    CreateThread(function()
        form = setupScaleform("instructional_buttons")
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            CurrentCoords = coords

            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)

            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(CurrentObject)
            end
            
            if IsControlJustPressed(0, 38) then
                PlaceSpawnedObject()
            end
            
            Wait(1)
        end
    end)
end



local function CancelPlacement()
    DeleteObject(CurrentObject)
    SetNuiFocus(true, true)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
end

local function RotateObject(direction)
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

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('spawn', function(data)
    SetNuiFocus(false, false)
    PlacingObject = true
    CreateSpawnedObject(data)
end)

RegisterNetEvent("objects:UpdateObjectList", function(NewObjectList)
    ObjectList = NewObjectList
    print("Object List Updated")
end)

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
    --print(CurrentDirection)
end)
RegisterKeyMapping("+ToggleRotationMode", "Toggle Rotation Mode", "keyboard", "")


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

                print(v.type, v.type)
                if ObjectParams[v.type] ~= nil and ObjectParams[v.type].event ~= nil then
                    print("HELLO?")
                    exports.qtarget:AddTargetEntity(object, {
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
                    v["object"] = nil
                    v["IsRendered"] = nil
                end
			end
		end
        Wait(1500)
	end
end)

RegisterNetEvent("objects:AddObject", function(object)
    ObjectList[#ObjectList+1] = object
end)