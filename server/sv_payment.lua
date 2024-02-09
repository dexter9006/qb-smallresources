local QBCore = exports['qb-core']:GetCoreObject()
local Stashes = {}

RegisterNetEvent('payment:givecheque', function(info, target)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pTarget = QBCore.Functions.GetPlayer(target)
    if Player.Functions.RemoveItem("cheque_vierge", 1) then
        local info = {
            exp = info.exp, ---
            rec = info.rec ,
            montant = info.montant,
            raison = info.raison,
            cid = info.cid,
            explab = info.explab
        }
        if not pTarget.Functions.AddItem("cheque", 1, false, info) then 
            TriggerClientEvent('QBCore:Notify', src, "Inventaire distant plein !", "error")
            Player.Functions.AddItem('cheque_vierge', 1)
        return end
        TriggerClientEvent("inventory:client:ItemBox", target, QBCore.Shared.Items["cheque"], "add")
        TriggerClientEvent('QBCore:Notify', src, "Vous avez bien donner le cheque ! ", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Vous n\'avez pas de cheque vierge ! ", "error")
    end
end)


RegisterNetEvent('payment:getPlayer', function (target)
    local src = source
    local player = QBCore.Functions.GetPlayer(target)
    TriggerClientEvent('payment:player', src,player)
end)


local inbank
QBCore.Functions.CreateUseableItem("cheque", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if inbank then
        local itemp = item
        local item = item.info
        print(item.exp)
        local account = exports['qb-banking']:GetAccount(item.exp).account_balance
        print(account)
        --local recep = {info = }
        if account ~= 0 then -- Checks if player is employed by a society
            if account < tonumber(item.montant) then -- Checks if company has enough money to pay society
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
            else
                Player.Functions.AddMoney('bank', tonumber(item.montant), item.raison)
                exports['qb-banking']:RemoveMoney(item.exp, tonumber(item.montant), item.raison)
                local newBankBalance = Player.Functions.GetMoney('bank')
                -- add statement player
                exports['qb-banking']:CreateBankStatement(source, 'checking', item.montant, item.raison, 'deposit', 'player')
                Player.Functions.RemoveItem('cheque', 1, itemp.slot)
            end

        elseif item.explab ~= nil then
            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'L\'entreprise '..item.explab..' n\'a pas assez de fond !', 'error')
        else
            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'L\'entreprise n\'a pas assez de fond !', 'error')
        end
    end
end)


RegisterNetEvent('payment:inbank', function (cb)
    inbank = cb
    print(inbank)
end)
