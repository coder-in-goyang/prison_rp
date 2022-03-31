vRP_PrisonRPS = {}

Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_PrisonRP")
vRP_PrisonRPC = Tunnel.getInterface("vRP_PrisonRP", "vRP_PrisonRP")

Tunnel.bindInterface("vRP_PrisonRP", vRP_PrisonRPS)

RegisterServerEvent("PrisonRP:cutter")
AddEventHandler(
    "PrisonRP:cutter",
    function()
        local user_id = vRP.getUserId({source})
        local player = vRP.getUserSource({user_id})

        if vRP.tryFullPayment({user_id, 100}) then
            Citizen.Wait(1000)
            vRPclient.notify(player,{"탈옥 상점", "볼트 커터 구매가 완료되었습니다."})
            vRP.giveInventoryItem({user_id, "bolt_cutter", 1})
            Citizen.Wait(2000)
            vRPclient.notify(player, {"탈옥 RP", "맵에 표시된 빌립스로 가 아이템을 사용하세요!"})
        else
            vRPclient.notify(player, {"탈옥 상점", "돈 부족"})
        end
    end
)

RegisterServerEvent("PrisonRP:carSupport")
AddEventHandler(
    "PrisonRP:carSupport",
    function()
        local user_id = vRP.getUserId({source})
        local player = vRP.getUserSource({user_id})

        if vRP.tryFullPayment({user_id, 100}) then
            Citizen.Wait(1000)
            vRPclient.notify(player,{"탈옥 상점", "차량 지원 구매가 완료되었습니다."})
            vRP.giveInventoryItem({user_id, "car_support", 1})
        else
            vRPclient.notify(player, {"탈옥 상점", "돈 부족"})
        end
    end
)

RegisterServerEvent("PrisonRP:bulletProof")
AddEventHandler(
    "PrisonRP:bulletProof",
    function()
        local user_id = vRP.getUserId({source})
        local player = vRP.getUserSource({user_id})

        if vRP.tryFullPayment({user_id, 100}) then
            Citizen.Wait(1000)
            vRPclient.notify(player,{"탈옥 상점", "방탄복 구매가 완료되었습니다."})
            vRP.giveInventoryItem({user_id, "body_armor1", 1})
        else
            vRPclient.notify(player, {"탈옥 상점", "돈 부족"})
        end
    end
)

RegisterServerEvent("PrisonRP:cutFence")
AddEventHandler(
    "PrisonRP:cutFence",
    function()
        local user_id = vRP.getUserId({source})
        local player = vRP.getUserSource({user_id})
        if vRP.tryGetInventoryItem({user_id, "bolt_cutter", 1, true}) then
            vRPclient.notify(player, {"탈옥 RP", "철조망을 자르는 중 입니다."})
            vRPclient.teleport(player, {1770.4512939453,2403.9611816406,45.915138244629})
            if vRP.tryGetInventoryItem({user_id, "car_support", 1, true}) then
                TriggerClientEvent("PrisonRP:SpawnCar", source)
                TriggerClientEvent('chatMessage', -1, '🚨 속보', { 105, 105, 105 }, "알 수 없는 수감자가 탈옥을 했습니다! ^2")
            else
                vRPclient.notify(player,{"탈옥 RP", "차량 지원 아이템이 없어 걸어가야 합니다. 행운을 빕니다!"})
                TriggerClientEvent('chatMessage', -1, '🚨 ^1속보', { 250, 250, 250 }, "알 수 없는 수감자가 탈옥을 했습니다! ^2")
            end
        else
            vRPclient.notify(player, {"탈옥 RP", "볼트 커터가 없어 철조망을 자를 수 없습니다."})
        end
    end
)

--function CarSpawn()