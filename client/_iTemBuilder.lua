ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().group == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local Items = {}
local ItemsLoaded = false

RegisterNetEvent('item:refreshItems')
AddEventHandler('item:refreshItems', function(Table)
    Items = Table
    ItemsLoaded = true
end)

local ItemWeight = 'weight'

Liste_Item_1 = {}

rework_item = {
    name = '~w~A Saisir',
    label = '~w~A Saisir',
    weight = ' ~w~A Saisir',
    consommable = false,
    boisson = false,
    nourriture = false,
    drogue = false
}

choixitemamodif = {
    nomdebase = '~w~A Saisir',
    name = '~w~A Saisir',
    label = '~w~A Saisir',
    weight = ' ~w~A Saisir',
    consommable = false,
    boisson = false,
    nourriture = false,
    drogue = false
}


RegisterNetEvent("h4ci:open")
AddEventHandler("h4ci:open", function()
	if isMenuOpened then return end
	OpenCreateItem()
end)


FILTER_ID = nil;
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };
local filter = 1

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local OPTI_ = false
local Item_Menu = RageUI.CreateMenu("", "Pour creer des items.")
local Item_Creation = RageUI.CreateSubMenu(Item_Menu, "", 'Pour creer l\'item')
local Liste_Items = RageUI.CreateSubMenu(Item_Menu, "", 'Pour voir la liste des items')
local Item_Modify = RageUI.CreateSubMenu(Liste_Items, "", 'Pour modifier un item')
Item_Menu.Closed = function()
    OPTI_ = false
end

function OpenCreateItem()
    if OPTI_ == false then
        OPTI_ = true
        RageUI.Visible(Item_Menu, true)
        CreateThread(function()
            while OPTI_ do
                RageUI.IsVisible(Item_Menu, function()
                    RageUI.Button("~w~Creer un item", nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                        end
                    }, Item_Creation)
                    RageUI.Button("~w~Liste des items", nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('rework_item:majitemzebsrv', function(itemsrv)
                                Liste_Item_1 = itemsrv
                            end)
                        end
                    }, Liste_Items)
                end)

                RageUI.IsVisible(Liste_Items, function()
                    RageUI.List("~w~🔎 Filtre:", filterArray, filter, nil, {}, true, {
                        onListChange = function(index, item)
                            filter = index
                        end,
                        onSelected = function(index, item)
                            filter = index
                        end })
                    for k, v in pairs(Liste_Item_1) do
                        if starts(v.label:lower(), filterArray[filter]:lower()) then
                            RageUI.Button(v.label .. ' | ' .. v.name, nil, { RightLabel = "→" }, true, {
                                onSelected = function()
                                    choixitemamodif = v
                                    choixitemamodif.nomdebase = v.name
                                end
                            }, Item_Modify)
                        end
                    end
                end)

                RageUI.IsVisible(Item_Modify, function()
                    RageUI.Button("~w~Poids de l'item : ", nil, { RightLabel = choixitemamodif.weight }, true, {
                        onSelected = function()
                            local nombreinvalide = false
                            choixitemamodif.weight = KeyboardInput('Veuillez choisir le poids de l\'item', '', 3)
                            if tonumber(choixitemamodif.weight) then
                                ESX.ShowNotification('Vous avez changer le poid de l\'item')
                            else
                                nombreinvalide = true
                            end

                            while nombreinvalide == true do
                                ESX.ShowNotification('Poids invalide, veuillez recommencer')
                                choixitemamodif.weight = KeyboardInput('Veuillez choisir le poids de l\'item', '', 3)
                                if tonumber(choixitemamodif.weight) then
                                    ESX.ShowNotification('Vous avez changer le poid de l\'item')
                                    nombreinvalide = false
                                end
                            end
                        end
                    })

                    RageUI.Button("~w~Valider", nil,
                        { RightLabel = "→", Color = { BackgroundColor = RageUI.ItemsColour.Green } }, true, {
                        onSelected = function()
                            if choixitemamodif.label == '~w~A Saisir' then
                                ESX.ShowNotification("Le label n'as pas été saisi")
                            else
                                TriggerServerEvent('h4ci_itembuilder:maj', choixitemamodif)
                                ESX.ShowNotification('Vous avez mis à jour l\'item ' .. choixitemamodif.name)
                                RageUI.CloseAll()
                                OPTI_ = false
                            end
                        end
                    })

                    RageUI.Button("~w~Supprimer", nil,
                        { RightLabel = "→", Color = { BackgroundColor = RageUI.ItemsColour.Red } }, true, {
                        onSelected = function()
                            TriggerServerEvent('rework_item:delete', choixitemamodif.name)
                            RageUI.CloseAll()
                            OPTI_ = false
                        end
                    })

                end)
                RageUI.IsVisible(Item_Creation, function()
                    RageUI.Button("~w~Nom de l'item : ", nil, { RightLabel = rework_item.name }, true, {
                        onSelected = function()
                            rework_item.name = KeyboardInput('Veuillez saisir le name de l\'item', '', 12)
                        end
                    })
                    RageUI.Button("~w~Label de l'item : ", nil, { RightLabel = rework_item.label }, true, {
                        onSelected = function()
                            rework_item.label = KeyboardInput('Veuillez saisir le label de l\'item', '', 30)
                        end
                    })
                    RageUI.Button("~w~Poids de l'item : ", nil, { RightLabel = rework_item.weight }, true, {
                        onSelected = function()
                            local nombreinvalide = false
                            rework_item.weight = KeyboardInput('Veuillez choisir le poids de l\'item', '', 3)
                            if tonumber(rework_item.weight) then
                                ESX.ShowNotification('Vous avez changer le poid de l\'item')
                            else
                                nombreinvalide = true
                            end

                            while nombreinvalide == true do
                                ESX.ShowNotification('Poids invalide, veuillez recommencer')
                                rework_item.weight = KeyboardInput('Veuillez choisir le poids de l\'item', '', 3)
                                if tonumber(rework_item.weight) then
                                    ESX.ShowNotification('Vous avez changer le poid de l\'item')
                                    nombreinvalide = false
                                end
                            end
                        end
                    })
                    RageUI.Checkbox("~w~Consommable", nil, rework_item.consommable, {}, {
                        onChecked = function(Index, Items)
                            rework_item.consommable = true
                        end,
                        onUnChecked = function(Index, Items)
                            rework_item.consommable = false
                        end,
                    })

                    if rework_item.consommable == true then
                        RageUI.Separator('Choix du type de consommable')
                        RageUI.Checkbox("~w~Boisson", nil, rework_item.boisson, {}, {
                            onChecked = function(Index, Items)
                                rework_item.boisson = true
                                rework_item.nourriture = false
                                rework_item.drogue = false
                            end,
                            onUnChecked = function(Index, Items)
                                rework_item.boisson = false
                            end,
                        })
                        RageUI.Checkbox("~w~Nourriture", nil, rework_item.nourriture, {}, {
                            onChecked = function(Index, Items)
                                rework_item.nourriture = true
                                rework_item.boisson = false
                                rework_item.drogue = false
                            end,
                            onUnChecked = function(Index, Items)
                                rework_item.nourriture = false
                            end,
                        })
                        RageUI.Checkbox("~w~Drogue", nil, rework_item.drogue, {}, {
                            onChecked = function(Index, Items)
                                rework_item.drogue = true
                                rework_item.boisson = false
                                rework_item.nourriture = false
                            end,
                            onUnChecked = function(Index, Items)
                                rework_item.drogue = false
                            end,
                        })
                    end
                    RageUI.Button("~w~Valider", nil,
                        { RightLabel = "→", Color = { BackgroundColor = RageUI.ItemsColour.Green } }, true, {
                        onSelected = function()
                            if rework_item.name == '~w~A Saisir' then
                                ESX.ShowNotification("Le name n'as pas été saisi")
                            elseif rework_item.label == '~w~A Saisir' then
                                ESX.ShowNotification("Le label n'as pas été saisi")
                            elseif rework_item.weight == '~w~A Saisir' then
                                ESX.ShowNotification("La weight n'as pas été saisi")
                            else
                                TriggerServerEvent('h4ci_itembuilder:ajout', rework_item, ItemWeight)
                                ESX.ShowNotification('La création de l\'item : ~b~' ..
                                    rework_item.label .. '~w~ a été faite')
                                RageUI.CloseAll()
                                OPTI_ = false
                            end
                        end
                    })
                end)
                Wait(0)
            end
        end)
    end
end