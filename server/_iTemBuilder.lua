ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

print('[^5ITEM BUILDER^0] ^2Rework by ^0[^6!Therapyst#9268^0] | ^0Autheur du script ^0[^5H4ci^0])')

local Items = {}

MySQL.ready(function()
    Liste_Item = {}
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(data)
        for _, v in pairs(data) do
            table.insert(Liste_Item, { name = v.name, label = v.label, weight = v.weight, consommable = v.consommable })
            if v.consommable == 'boisson' then
                
                ESX.RegisterUsableItem(v.name, function(source)
                    local _source = source
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    xPlayer.removeInventoryItem(v.name, 1)
                    TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
                    TriggerClientEvent('esx_basicneeds:onDrink', source)
                    TriggerClientEvent('esx:showNotification', source, 'tu as bu une boisson')
                end)
            elseif v.consommable == 'nourriture' then
                
                ESX.RegisterUsableItem(v.name, function(source)
                    local _source = source
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    xPlayer.removeInventoryItem(v.name, 1)
                    TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
                    TriggerClientEvent('esx_basicneeds:onEat', source)
                    TriggerClientEvent('esx:showNotification', source, 'tu as manger de la nourriture')
                end)
            elseif v.consommable == 'drogue' then
                
                ESX.RegisterUsableItem(v.name, function(source)
                    local _source = source
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    xPlayer.removeInventoryItem(v.name, 1)
                    TriggerClientEvent('esx_basicneeds:onEattest', source)
                    TriggerClientEvent('esx_status:remove', source, 'hunger', 75000)
                    TriggerClientEvent('esx_status:remove', source, 'thirst', 67500)
                    TriggerClientEvent('esx_status:add', source, 'drunk', 20000)
                    TriggerClientEvent('esx_status:remove', source, 'prevHealth', -95000)
                    TriggerClientEvent('esx_basicneeds:test', source)
                    TriggerClientEvent('esx:showNotification', source, 'Vous avez pris de la ' .. v.name)
                end)
            end
        end
    end)
end)

-- Création de l'item [Boisson / Nourriture / Drogue]
RegisterNetEvent('h4ci_itembuilder:ajout')
AddEventHandler('h4ci_itembuilder:ajout', function(ConfigItem, ItemWeight)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _src = source
    if isAllowed(_src) then
    typeconsommable = 'rien'
    if ConfigItem.consommable == true then
        if ConfigItem.boisson == true then
            typeconsommable = 'boisson'
        elseif ConfigItem.nourriture == true then
            typeconsommable = 'nourriture'
        elseif ConfigItem.drogue == true then
            typeconsommable = 'drogue'
        end
        if ItemWeight == 'weight' then
            if ConfigItem.name ~= nil or ConfigItem.label ~= nil then
                MySQL.Async.execute('INSERT INTO items (name, label, `weight`, consommable) VALUES (@name, @label, @weight, @consommable)', {
                    ['@name'] = ConfigItem.name,
                    ['@label'] = ConfigItem.label,
                    ['@weight'] = tonumber(ConfigItem.weight),
                    ['@consommable'] = typeconsommable
                }, function(rowsChanged)
                end)
            end
        end
        ESX.AddItem(ConfigItem.name, ConfigItem.label)
    end
end
end)

-- Mettre à jour les items via le menu [Liste des items].
RegisterServerEvent('h4ci_itembuilder:maj')
AddEventHandler('h4ci_itembuilder:maj', function(maj)
    local _src = source
    if isAllowed(_src) then
    MySQL.Async.execute(
        'UPDATE items SET `weight` = @weight WHERE name = @name',
        {
            ['@weight'] = tonumber(maj.weight),
            ['@name'] = maj.name,
        }
    )
end
end)

ESX.RegisterServerCallback('rework_item:majitemzebsrv', function(source, cb)
    local _src = source
    if isAllowed(_src) then
    majitems = {}
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(data)
        for _, v in pairs(data) do
            table.insert(majitems, { name = v.name, label = v.label, weight = v.weight, consommable = v.consommable })
        end
        cb(majitems)
    end)
end
end)

RegisterCommand('itembuilder', function(source, args, rawCommand)
    local _src = source
    if isAllowed(_src) then
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    for k, v in pairs(Config['admingroups']) do
        if group == v then
            TriggerClientEvent('h4ci:open', _src)
        end
     end
    else
        TriggerClientEvent('esx:showNotification', _src, '~r~Vous n\'avez pas la permission de faire cela')
end
end)


-- Suppréssion des items dans la table.
RegisterServerEvent('rework_item:delete')
AddEventHandler('rework_item:delete', function(name)
    local _src = source
    if isAllowed(_src) then
    if name ~= nil then
        MySQL.Async.execute(
            'DELETE FROM items WHERE name = @name',
            {
                ['@name'] = name
            }
        )
        TriggerClientEvent('esx:showNotification', source, "Vous avez supprimez l'item ~r~" .. name)
    else
        TriggerClientEvent('esx:showNotification', source, "Impossible de ~r~supprimer~w~ ou ~r~introuvable")
    end
end
end)

isAllowed = function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local group = xPlayer.getGroup()
    for k, v in pairs(Config['admingroups']) do
        if group == v then
            return true
        end
    end
    return false
end