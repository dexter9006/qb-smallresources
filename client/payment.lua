local QBCore = exports['qb-core']:GetCoreObject()



local Target



local ChequeLocations = {

	[1] = vector3(253.27, 220.72, 106.29),

}



local options = {

    [1] = {

        label = 'Faire un chèque',

        icon = 'fa-solid fa-file-invoice-dollar',

        distance = 4,

        items = 'cheque_vierge',

        onSelect = function(data)

            local id = GetPlayerServerId(NetworkGetEntityOwner(data.entity))

            TriggerEvent('payment:input', id)

            --[[print(data.entity, id)

            for key,value in pairs(data) do

                print(key, value)

            end]]

        end,

    },

}  



CreateThread(function()

    local player = QBCore.Functions.GetPlayerData()

    local isboss = player.job.isboss

    if isboss then

        exports.ox_target:addGlobalPlayer(options)

    end

end)



RegisterCommand('debugpayment', function(src)

    TriggerServerEvent('payment:getrecep', src)

end)



local idTarget



function player(target)

    TriggerServerEvent('payment:getPlayer', target)

end



RegisterNetEvent('payment:player', function(player)

    if player then

        idTarget = player 

    end

end)



RegisterNetEvent('payment:input', function(target)

    player(target)

    if idTarget then

        local Ptarget = idTarget.PlayerData

        local tSrc = GetPlayerFromServerId(target) 

        local pData = QBCore.Functions.GetPlayerData()

        --local Ptarget = QBCore.Functions.

        local firstname = Ptarget.charinfo.firstname 

        local lastname = Ptarget.charinfo.lastname

        local dialog = exports['qb-input']:ShowInput({

            header = 'Edition du cheque pour ' .. firstname ..' ' .. lastname .. ' ...',

            submitText = "Donner le cheque ",

            inputs = {

                {

                    text = 'Montant ...',

                    name = 'montant',

                    type = 'number',

                    isRequired = true,

                    disable = true

                },

                {

                    text = 'Raison',

                    name = 'raison',

                    type = 'text',

                    isRequired = true

                },

            }

        })

        if dialog then

            local montant = dialog.montant

            local raison = dialog.raison

            local info = {

                exp = pData.job.name,

                rec = firstname .. " " .. lastname ,

                montant = montant,

                raison = raison,

                cid = Ptarget.citizenid,

                explab = pData.job.label

            }

            TriggerServerEvent('payment:givecheque',info, target)

        end

    end

end)





local chequeZones = {}

for k=1, #ChequeLocations do

	local label = ("GrapeZone-%s"):format(k)

    TriggerServerEvent('payment:inbank', false)

	chequeZones[k] = {

		inbank = false,

		zone = BoxZone:Create(ChequeLocations[k], 1.75, 3, {

			name=label,

			minZ = ChequeLocations[k].z-1.0,

			maxZ = ChequeLocations[k].z+1.0,

			debugPoly=Config.Debug,

		})

	}

	chequeZones[k].zone:onPlayerInOut(function(isPointInside)

		chequeZones[k].inBank = isPointInside

		if chequeZones[k].inBank then

			TriggerServerEvent('payment:inbank', true)

		else

			exports['qb-core']:HideText()

            TriggerServerEvent('payment:inbank', false)

		end

	end)

end

