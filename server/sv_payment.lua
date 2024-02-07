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
        local account = exports['qb-management']:GetAccount(item.exp)
        --local recep = {info = }
        if account ~= 0 then -- Checks if player is employed by a society
            if account < tonumber(item.montant) then -- Checks if company has enough money to pay society
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
            else
                Player.Functions.AddMoney('bank', tonumber(item.montant), item.raison)
                exports['qb-management']:RemoveMoney(item.exp, tonumber(item.montant))
                local newBankBalance = Player.Functions.GetMoney('bank')
                TriggerEvent('bank:addstatement', item.cid, 'Bank', tonumber(item.montant), 0, newBankBalance, 'Depôt de cheque : '..item.explab..' --> '..item.rec .. '. Motif : ' .. item.raison)
                Player.Functions.RemoveItem('cheque', 1, itemp.slot)
                --TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["cheque"], "remove")
                TriggerEvent('payment:addrecep', item)
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
end)

RegisterNetEvent('payment:addstash', function(source, info)
    
end)

RegisterNetEvent('payment:addrecep', function (info)
    local amount = MySQL.query.await('SELECT amount FROM management_funds WHERE job_name = ?', {info.exp})
    local newBankBalance = amount[1].amount - info.montant
    print(amount[1].amount, info.montant, newBankBalance)
    local job = {
        name = info.exp,
        label = info.explab,
    }
    local price = info.montant
    local raison = info.raison
    local cidrec = info.cid
    local namerec = info.rec
    MySQL.query('INSERT into recepice (JobLabel,JobName,Price,Raison,Name,cidrec) VALUE (?,?,?,?,?,?)', {
        job.label,job.name, price, raison, namerec, cidrec
    })
    TriggerEvent('bank:addBusstatement', job.name, 'Bank', 0, price, newBankBalance, 'Encaissement de cheque : '..job.label..' --> '..namerec .. '. Motif : ' .. raison)
end)

RegisterNetEvent('payment:getrecep', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local job = Player.PlayerData.job.name
    MySQL.query('SELECT * FROM recepice WHERE JobName = @job ORDER BY Date ', {
        job = job
    },function (result)
        for _, v in pairs(result) do
            local info = {
                rec = v.Name ,
                montant = v.Price,
                raison = v.Raison,
                cid = v.cidrec,
                explab = v.JobLabel,
                date = v.Date
            }
            
            if not Player.Functions.AddItem("recepisse", 1, false, info) then 
                TriggerClientEvent('QBCore:Notify', src, "Inventaire plein !", "error")
                return 
            end
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["recepisse"], "add")
            TriggerClientEvent('QBCore:Notify', src,"Vous avez reçu un récépissé  ! ", "success")
            MySQL.query("DELETE from recepice WHERE id = @id", {id = v.id})

            
        end
    end)
end)