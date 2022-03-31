vRP_PrisonRPC = {}

vRP = Proxy.getInterface("vRP")
vRP_PrisonRPS = Tunnel.getInterface("vRP_PrisonRP", "vRP_PrisonRP")

Tunnel.bindInterface("vRP_PrisonRP", vRP_PrisonRPC)
Proxy.addInterface("vRP_PrisonRP", vRP_PrisonRPC)

local coordonate = {
    {1713.2331542969,2468.1767578125,55.161838531494-1,"부패 교도관",500.77,0x56C96FC6,"s_m_m_prisguard_01"}
}

local nearbyRadares = {};

local radares = {
	{x = 1821.3349609375, y = 2477.5561523438, z = 45.368366241455},
    {x = 1760.8129882812, y = 2414.1547851562, z = 45.369766235352},
    {x = 1658.7762451172, y = 2398.3491210938, z = 45.403812408447},
    {x = 1543.9514160156, y = 2470.7578125, z = 45.345684051514},
    {x = 1538.2846679688, y = 2585.4445800781, z = 45.335712432861},
    {x = 1572.5372314453, y = 2678.2827148438, z = 45.39412689209},
    {x = 1651.6193847656, y = 2755.2124023438, z = 45.502452850342},
    {x = 1771.826171875, y = 2759.4533691406, z = 45.509464263916},
    {x = 1845.236328125, y = 2698.7272949219, z = 45.534362792969},
    {x = 1820.44921875, y = 2621.4296875, z = 45.5256690979}
}

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Citizen.Wait(3)
      end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Citizen.Wait(3)
      end
      ped = CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(3)
        local ped = GetPlayerPed(-1)
        local PlayerDistance = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(1713.2331542969,2468.1767578125,55.161838531494-1, PlayerDistance.x, PlayerDistance.y, PlayerDistance.z)
        
        if(distance < 5) then
            if(IsControlJustPressed(2, 38)) then
                Citizen.Wait(1000)
                TransitionToBlurred(1000)
                SetNuiFocus(true, true)
                DisplayRadar(false)
                SendNuiMessage(json.encode({
                        type = "ON_Visible"
                    }))
                vRP.notify({"탈옥 RP 알림","탈옥 상점을 방문합니다."})
            end
        end
    end
end
)

Citizen.CreateThread(function ()
  while (true) do
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)

    local temp = {};
    for k, v in pairs(radares) do
      local dist = GetDistanceBetweenCoords(radares[k].x, radares[k].y, radares[k].z, coords["x"], coords["y"], coords["z"])
      if (dist < 3) then
        nearbyRadares[k] = v
      else
        nearbyRadares[k] = nil
      end
    end
    Citizen.Wait(200);
  end
end)


Citizen.CreateThread(function()
  while (true) do
    Citizen.Wait(3)
    for k, v in pairs(nearbyRadares) do
      if (IsControlJustPressed(2, 38)) then
        print("테스트 완료")
        TriggerServerEvent("PrisonRP:cutFence")                    
      end
    end
  end
end)

RegisterNUICallback(
    "Closebtn",
    function(data, cb)
        CloseShop()
        cb(true)
    end
)

RegisterNUICallback(
    "cutterTrigger",
    function(data, cb)
        TriggerServerEvent("PrisonRP:cutter")
        cb(true)
    end
)

RegisterNUICallback(
    "carSupportTrigger",
    function(data, cb)
        TriggerServerEvent("PrisonRP:carSupport")
        cb(true)
    end
)

RegisterNUICallback(
    "bulletProofTrigger",
    function(data, cb)
        TriggerServerEvent("PrisonRP:bulletProof")
        cb(true)
    end
)


RegisterNetEvent("PrisonRP:SpawnCar")
AddEventHandler('PrisonRP:SpawnCar', function()
    local id = PlayerId()
    local playerName = GetPlayerName(id)
    local vehicle = spawncar(adder)

    print("Car Spawned Completly")
    vRP.notify({"탈옥 RP 알림", "차량을 타고 멀리 도주하세요!"})

end)

function spawncar(car)

    local car = GetHashKey("adder")

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(3)
    end

    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, x + 3, y + 3, z + 1, 0.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)

    return vehicle
end

function CloseShop()
	DisplayRadar(true)
    SetNuiFocus(false, false)
    TransitionFromBlurred(1000)
    SendNUIMessage(
        {
            type = "OFF_Visible"
        }
    )
end

--[[ENJOY]]--