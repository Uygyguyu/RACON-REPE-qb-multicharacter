local QBCore = exports['qb-core']:GetCoreObject()
local hasDonePreloading = {}

-- Functions

function GiveStarterItems(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for _, v in pairs(Config.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end

local function loadHouseData(src)
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.query.await('SELECT * FROM houselocations', {})
    if result[1] ~= nil then
        for _, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("qb-garages:client:houseGarageConfig", src, HouseGarages)
    TriggerClientEvent("qb-houses:client:setHouseConfig", src, Houses)
end

-- Events

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    Wait(1000) -- 1 second should be enough to do the preloading in other resources
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)


RegisterNetEvent('qb-multicharacter:server:disconnect', function()
    local src = source
    print(src)
    DropPlayer(src, "Başarıyla Oyundan Çıkıldı")
end)

RegisterNetEvent('qb-multicharacter:server:loadUserData', function(cData)
    local src = source
    if QBCore.Player.Login(src, cData.citizenid) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        print('^2[qb-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has successfully loaded!')
  

        local issuerPlayer = QBCore.Functions.GetPlayer(src)
        local issuerPlayerName = issuerPlayer.PlayerData.charinfo.firstname .. " " .. issuerPlayer.PlayerData.charinfo.lastname
        local issuerCitizenID = issuerPlayer.PlayerData.citizenid

        local issuerIdentifiers = GetPlayerIdentifiers(src)
        local issuerDiscord = "Discord ID Bulunamadı"
        local issuerSteam = "Steam HEX ID Bulunamadı"
        local issuerSteamProfileLink = "Steam Profil Linki Bulunamadı"

        for _, identifier in ipairs(issuerIdentifiers) do
            if string.find(identifier, "discord:") then
                issuerDiscord = string.sub(identifier, 9)  
            elseif string.find(identifier, "steam:") then
                issuerSteam = string.sub(identifier, 7)  
                local steamId = tonumber(issuerSteam, 16)
                issuerSteamProfileLink = "https://steamcommunity.com/profiles/" .. steamId
            end
        end

        local logMessage = "**Oyuncu Giriş Yaptı**" ..
        "\n" ..
        "\n**Giriş Yapan Kişi**\nİsim Soyisim = " .. (issuerPlayerName or "Bilinmiyor") .. 
        "\nID = " .. (src or "Bilinmiyor") .. 
        "\nCitizen ID = " .. (issuerCitizenID or "Bilinmiyor") .. 
        "\nDiscord = " .. "<@" .. (issuerDiscord or "Bilinmiyor") .. ">" .. 
        "\nDiscord ID = " .. (issuerDiscord or "Bilinmiyor") .. 
        "\nSteam Hex ID = " .. (issuerSteam or "Bilinmiyor") .. 
        "\nSteam Profil Linki = " .. (issuerSteamProfileLink or "Bilinmiyor") ..
        "\n"

        TriggerEvent("qb-log:server:CreateLog", "joinleave", "", "green",logMessage) 
  
        QBCore.Commands.Refresh(src)
        loadHouseData(src)
        if Config.SkipSelection then
            local coords = json.decode(cData.position)
            TriggerClientEvent('qb-multicharacter:client:spawnLastLocation', src, coords, cData)
        else
            if GetResourceState('qb-apartments') == 'started' then
                TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
            else
                TriggerClientEvent('qb-spawn:client:setupSpawns', src, cData, false, nil)
                TriggerClientEvent('qb-spawn:client:openUI', src, true)
            end
        end 
    end
end)

RegisterNetEvent('qb-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if QBCore.Player.Login(src, false, newData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
            print('^2[qb-core]^7 '..GetPlayerName(src)..' has successfully loaded!')
            QBCore.Commands.Refresh(src)
            loadHouseData(src)
            TriggerClientEvent("qb-multicharacter:client:closeNUIdefault", src)
            GiveStarterItems(src)
    end
end)


    RegisterServerEvent('qb-multicharacter:server:deleteCharacter')
    AddEventHandler('qb-multicharacter:server:deleteCharacter', function(citizenid)
        local src = source
        if Config.EnableDeleteButton then
            QBCore.Player.DeleteCharacter(src, citizenid)
            TriggerClientEvent('QBCore:Notify', src, "Başarıyla Karakter Silindi" , "success")
        end
    end)
    

-- Callbacks

QBCore.Functions.CreateCallback("qb-multicharacter:server:GetUserCharacters", function(source, cb)
    local src = source
    local license = QBCore.Functions.GetIdentifier(src, 'license')

    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        cb(result)
    end)
end)

QBCore.Functions.CreateCallback("qb-multicharacter:server:GetServerLogs", function(_, cb)
    MySQL.query('SELECT * FROM server_logs', {}, function(result)
        cb(result)
    end)
end)    

QBCore.Functions.CreateCallback("qb-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local src = source
    local license = QBCore.Functions.GetIdentifier(src, 'license')
    local steam = QBCore.Functions.GetIdentifier(src, 'steam')
    local discord = QBCore.Functions.GetIdentifier(src, 'discord')
    local numOfChars = Config.DefaultNumberOfCharacters

    if next(Config.PlayersNumberOfCharacters) then
        for _, v in pairs(Config.PlayersNumberOfCharacters) do
            if v.license and v.license == license then
                numOfChars = v.numberOfChars
                break
            elseif v.steam and v.steam == steam then
                numOfChars = v.numberOfChars
                break
            elseif v.discord and v.discord == discord then
                numOfChars = v.numberOfChars
                break
            end
        end
    end

    cb(numOfChars)
end)

QBCore.Functions.CreateCallback("qb-multicharacter:server:setupCharacters", function(source, cb)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

QBCore.Functions.CreateCallback("qb-multicharacter:server:getSkin", function(source, cb, cid)
    local src = source

    MySQL.Async.fetchAll("SELECT * FROM `playerskins` WHERE `citizenid` = @citizenid AND `active` = @active", {
        ['@citizenid'] = cid,
        ['@active'] = 1
    }, function(result)
        if result[1] ~= nil then
            cb(result[1].model, result[1].skin)
        else
            cb(nil)
        end
    end)
end)





function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if Config.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.Mysql == "ghmattimysql" then
        exports.ghmattimysql:execute(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    elseif Config.Mysql == "mysql-async" then   
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end
