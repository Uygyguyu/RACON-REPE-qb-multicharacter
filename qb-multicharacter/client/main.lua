local cam = nil
local charPed = nil
local loadScreenCheckState = false
local QBCore = exports['qb-core']:GetCoreObject()
local cached_player_skins = {}

local randommodels = {
    'mp_m_freemode_01',
    'mp_f_freemode_01',
}


CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb-multicharacter:client:chooseChar')
			return
		end
	end
end)

-- Main Thread

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb-multicharacter:client:chooseChar')
			return
		end
	end
end)

-- Functions

local function skyCam(bool)
    TriggerEvent('qb-weathersync:client:DisableSync')
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z, 0.0 ,0.0, Config.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

local function openCharMenu(bool)
    QBCore.Functions.TriggerCallback("qb-multicharacter:server:GetNumberOfCharacters", function(result)
        local translations = {}
        SetNuiFocus(bool, bool)
        SendNUIMessage({
            action = "ui",
            customNationality = Config.customNationality,
            toggle = bool,
            nChar = result,
            enableDeleteButton = Config.EnableDeleteButton,
            translations = translations
        })
        skyCam(bool)
        if not loadScreenCheckState then
            ShutdownLoadingScreenNui()
            loadScreenCheckState = true
        end
    end)
end


RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData  
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
            model = model ~= nil and tonumber(model) or false
            if model ~= nil then
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    local randomAnims = {
                        "WORLD_HUMAN_HANG_OUT_STREET",
                        "WORLD_HUMAN_STAND_IMPATIENT",
                        "WORLD_HUMAN_STAND_MOBILE",
                        "WORLD_HUMAN_SMOKING_POT",
                        "WORLD_HUMAN_LEANING",
                        "WORLD_HUMAN_DRUG_DEALER_HARD",
                        "WORLD_HUMAN_SUPERHERO",
                        "WORLD_HUMAN_TOURIST_MAP",
                        "WORLD_HUMAN_YOGA",
                        "WORLD_HUMAN_BINOCULARS",
                        "WORLD_HUMAN_BUM_WASH",
                        "WORLD_HUMAN_CONST_DRILL",
                        "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
                        "WORLD_HUMAN_MUSCLE_FLEX",
                        "WORLD_HUMAN_MUSICIAN",
                        "WORLD_HUMAN_PAPARAZZI",
                        "WORLD_HUMAN_PARTYING",
                        "WORLD_HUMAN_PUSH_UPS",
                        "WORLD_HUMAN_SIT_UPS",
                        "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS",
                        "WORLD_HUMAN_PROSTITUTE_LOW_CLASS",
                        "WORLD_HUMAN_BUM_FREEWAY",
                        "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
                        "WORLD_HUMAN_CLIPBOARD",
                        "WORLD_HUMAN_SECURITY_SHINE_TORCH",
                        "WORLD_HUMAN_STRIP_WATCH_STAND",
                        "PROP_HUMAN_ATM",
                        "PROP_HUMAN_SEAT_BENCH",
                        "PROP_HUMAN_SEAT_CHAIR",
                        "PROP_HUMAN_SEAT_ARMCHAIR",
                        "PROP_HUMAN_MUSCLE_CHIN_UPS",
                        "PROP_HUMAN_BBQ",
                        "PROP_HUMAN_PARKING_METER",
                        "PROP_HUMAN_MOVIE_BULB", -- Film ışığı ayarlama
                        "PROP_HUMAN_MOVIE_STUDIO_LIGHT", -- Stüdyo ışığı kullanma
                        "PROP_HUMAN_BUM_BIN", -- Çöpte karıştırma
                        "PROP_HUMAN_BUM_SHOPPING_CART", -- Alışveriş arabası itme
                        "PROP_HUMAN_SEAT_COMPUTER", -- Bilgisayar kullanma
                        "PROP_HUMAN_SEAT_DECKCHAIR", -- Şezlongda oturma
                        "PROP_HUMAN_SEAT_COW_MILK", -- İnek sağma
                        "PROP_HUMAN_SEAT_SUNLOUNGER", -- Güneşlenme
                        "PROP_HUMAN_SKATEBOARD_PICKUP", -- Kaykay taşıma
                        "PROP_HUMAN_WELDING", -- Kaynak yapma
                        "PROP_HUMAN_CLEANING", -- Temizlik yapma
                        "PROP_HUMAN_BUM_BACKPACK", -- Sırt çantası takma
                        "PROP_HUMAN_BOX_CARRY", -- Kutu taşıma
                        "PROP_HUMAN_JOG_STANDING", -- Koşu öncesi ısınma
                        "PROP_HUMAN_MUSCLE_WEIGHT_LIFT", -- Ağırlık kaldırma
                        "PROP_HUMAN_DRINK_BEER", -- Bira içme
                        "PROP_HUMAN_SMOKE", -- Sigara içme
                        "PROP_HUMAN_CHAMPAGNE", -- Şampanya açma
                        "PROP_HUMAN_CHEERING", -- Tezahürat yapma
                        "PROP_HUMAN_FIRE_EXTINGUISHER", -- Yangın söndürme
                        "WORLD_HUMAN_STUPOR", -- Sarhoş hareketleri
                        "WORLD_HUMAN_TENNIS_PLAYER", -- Tenis oynama
                        "WORLD_HUMAN_MEDITATING", -- Meditasyon yapma
                        "WORLD_HUMAN_JOG_STANDING", -- Koşu yapar gibi durma
                        "WORLD_HUMAN_CHEERING", -- Alkışlama
                        "WORLD_HUMAN_HAMMERING", -- Çekiçle vurma
                        "WORLD_HUMAN_BUM_STANDING", -- Yerde durma
                        "WORLD_HUMAN_DRINKING", -- İçecek içme
                        "WORLD_HUMAN_GUITAR", -- Gitar çalma
                        "WORLD_HUMAN_AA_COFFEE", -- Kahve içme
                        "WORLD_HUMAN_AA_SMOKE", -- Sigara içme (grup)
                        "WORLD_HUMAN_HIKER_STANDING", -- Doğa yürüyüşü
                        "WORLD_HUMAN_WELDING", -- Kaynak yapma
                        "WORLD_HUMAN_VEHICLE_MECHANIC", -- Araç tamir etme
                        "PROP_HUMAN_STAND_IMPATIENT_UPRIGHT", -- Sabırsızca bekleme
                        "WORLD_HUMAN_WINDOW_SHOP_BROWSE", -- Mağaza vitrinine bakma
                        "WORLD_HUMAN_CHECKOUT_LINE", -- Kuyrukta bekleme
                    }
                    local playAnim = randomAnims[math.random(#randomAnims)]
                    TaskStartScenarioInPlace(charPed, playAnim, 0, true)   
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    data = json.decode(data)
                    TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
                end)
            else
                Citizen.CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end           
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    local randomAnims = {
                        "WORLD_HUMAN_HANG_OUT_STREET",
                        "WORLD_HUMAN_STAND_IMPATIENT",
                        "WORLD_HUMAN_STAND_MOBILE",
                        "WORLD_HUMAN_SMOKING_POT",
                        "WORLD_HUMAN_LEANING",
                        "WORLD_HUMAN_DRUG_DEALER_HARD",
                        "WORLD_HUMAN_SUPERHERO",
                        "WORLD_HUMAN_TOURIST_MAP",
                        "WORLD_HUMAN_YOGA",
                        "WORLD_HUMAN_BINOCULARS",
                        "WORLD_HUMAN_BUM_WASH",
                        "WORLD_HUMAN_CONST_DRILL",
                        "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
                        "WORLD_HUMAN_MUSCLE_FLEX",
                        "WORLD_HUMAN_MUSICIAN",
                        "WORLD_HUMAN_PAPARAZZI",
                        "WORLD_HUMAN_PARTYING",
                        "WORLD_HUMAN_PUSH_UPS",
                        "WORLD_HUMAN_SIT_UPS",
                        "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS",
                        "WORLD_HUMAN_PROSTITUTE_LOW_CLASS",
                        "WORLD_HUMAN_BUM_FREEWAY",
                        "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
                        "WORLD_HUMAN_CLIPBOARD",
                        "WORLD_HUMAN_SECURITY_SHINE_TORCH",
                        "WORLD_HUMAN_STRIP_WATCH_STAND",
                        "PROP_HUMAN_ATM",
                        "PROP_HUMAN_SEAT_BENCH",
                        "PROP_HUMAN_SEAT_CHAIR",
                        "PROP_HUMAN_SEAT_ARMCHAIR",
                        "PROP_HUMAN_MUSCLE_CHIN_UPS",
                        "PROP_HUMAN_BBQ",
                        "PROP_HUMAN_PARKING_METER",
                        "PROP_HUMAN_MOVIE_BULB", -- Film ışığı ayarlama
                        "PROP_HUMAN_MOVIE_STUDIO_LIGHT", -- Stüdyo ışığı kullanma
                        "PROP_HUMAN_BUM_BIN", -- Çöpte karıştırma
                        "PROP_HUMAN_BUM_SHOPPING_CART", -- Alışveriş arabası itme
                        "PROP_HUMAN_SEAT_COMPUTER", -- Bilgisayar kullanma
                        "PROP_HUMAN_SEAT_DECKCHAIR", -- Şezlongda oturma
                        "PROP_HUMAN_SEAT_COW_MILK", -- İnek sağma
                        "PROP_HUMAN_SEAT_SUNLOUNGER", -- Güneşlenme
                        "PROP_HUMAN_SKATEBOARD_PICKUP", -- Kaykay taşıma
                        "PROP_HUMAN_WELDING", -- Kaynak yapma
                        "PROP_HUMAN_CLEANING", -- Temizlik yapma
                        "PROP_HUMAN_BUM_BACKPACK", -- Sırt çantası takma
                        "PROP_HUMAN_BOX_CARRY", -- Kutu taşıma
                        "PROP_HUMAN_JOG_STANDING", -- Koşu öncesi ısınma
                        "PROP_HUMAN_MUSCLE_WEIGHT_LIFT", -- Ağırlık kaldırma
                        "PROP_HUMAN_DRINK_BEER", -- Bira içme
                        "PROP_HUMAN_SMOKE", -- Sigara içme
                        "PROP_HUMAN_CHAMPAGNE", -- Şampanya açma
                        "PROP_HUMAN_CHEERING", -- Tezahürat yapma
                        "PROP_HUMAN_FIRE_EXTINGUISHER", -- Yangın söndürme
                        "WORLD_HUMAN_STUPOR", -- Sarhoş hareketleri
                        "WORLD_HUMAN_TENNIS_PLAYER", -- Tenis oynama
                        "WORLD_HUMAN_MEDITATING", -- Meditasyon yapma
                        "WORLD_HUMAN_JOG_STANDING", -- Koşu yapar gibi durma
                        "WORLD_HUMAN_CHEERING", -- Alkışlama
                        "WORLD_HUMAN_HAMMERING", -- Çekiçle vurma
                        "WORLD_HUMAN_BUM_STANDING", -- Yerde durma
                        "WORLD_HUMAN_DRINKING", -- İçecek içme
                        "WORLD_HUMAN_GUITAR", -- Gitar çalma
                        "WORLD_HUMAN_AA_COFFEE", -- Kahve içme
                        "WORLD_HUMAN_AA_SMOKE", -- Sigara içme (grup)
                        "WORLD_HUMAN_HIKER_STANDING", -- Doğa yürüyüşü
                        "WORLD_HUMAN_WELDING", -- Kaynak yapma
                        "WORLD_HUMAN_VEHICLE_MECHANIC", -- Araç tamir etme
                        "PROP_HUMAN_STAND_IMPATIENT_UPRIGHT", -- Sabırsızca bekleme
                        "WORLD_HUMAN_WINDOW_SHOP_BROWSE", -- Mağaza vitrinine bakma
                        "WORLD_HUMAN_CHECKOUT_LINE", -- Kuyrukta bekleme
                    }
                    
                    local playAnim = randomAnims[math.random(#randomAnims)]
                    TaskStartScenarioInPlace(charPed, playAnim, 0, true)   
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
        end, cData.citizenid)
    else
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            local randomAnims = {
                "WORLD_HUMAN_HANG_OUT_STREET",
                "WORLD_HUMAN_STAND_IMPATIENT",
                "WORLD_HUMAN_STAND_MOBILE",
                "WORLD_HUMAN_SMOKING_POT",
                "WORLD_HUMAN_LEANING",
                "WORLD_HUMAN_DRUG_DEALER_HARD",
                "WORLD_HUMAN_SUPERHERO",
                "WORLD_HUMAN_TOURIST_MAP",
                "WORLD_HUMAN_YOGA",
                "WORLD_HUMAN_BINOCULARS",
                "WORLD_HUMAN_BUM_WASH",
                "WORLD_HUMAN_CONST_DRILL",
                "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
                "WORLD_HUMAN_MUSCLE_FLEX",
                "WORLD_HUMAN_MUSICIAN",
                "WORLD_HUMAN_PAPARAZZI",
                "WORLD_HUMAN_PARTYING",
                "WORLD_HUMAN_PUSH_UPS",
                "WORLD_HUMAN_SIT_UPS",
                "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS",
                "WORLD_HUMAN_PROSTITUTE_LOW_CLASS",
                "WORLD_HUMAN_BUM_FREEWAY",
                "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
                "WORLD_HUMAN_CLIPBOARD",
                "WORLD_HUMAN_SECURITY_SHINE_TORCH",
                "WORLD_HUMAN_STRIP_WATCH_STAND",
                "PROP_HUMAN_ATM",
                "PROP_HUMAN_SEAT_BENCH",
                "PROP_HUMAN_SEAT_CHAIR",
                "PROP_HUMAN_SEAT_ARMCHAIR",
                "PROP_HUMAN_MUSCLE_CHIN_UPS",
                "PROP_HUMAN_BBQ",
                "PROP_HUMAN_PARKING_METER",
                "PROP_HUMAN_MOVIE_BULB", -- Film ışığı ayarlama
                "PROP_HUMAN_MOVIE_STUDIO_LIGHT", -- Stüdyo ışığı kullanma
                "PROP_HUMAN_BUM_BIN", -- Çöpte karıştırma
                "PROP_HUMAN_BUM_SHOPPING_CART", -- Alışveriş arabası itme
                "PROP_HUMAN_SEAT_COMPUTER", -- Bilgisayar kullanma
                "PROP_HUMAN_SEAT_DECKCHAIR", -- Şezlongda oturma
                "PROP_HUMAN_SEAT_COW_MILK", -- İnek sağma
                "PROP_HUMAN_SEAT_SUNLOUNGER", -- Güneşlenme
                "PROP_HUMAN_SKATEBOARD_PICKUP", -- Kaykay taşıma
                "PROP_HUMAN_WELDING", -- Kaynak yapma
                "PROP_HUMAN_CLEANING", -- Temizlik yapma
                "PROP_HUMAN_BUM_BACKPACK", -- Sırt çantası takma
                "PROP_HUMAN_BOX_CARRY", -- Kutu taşıma
                "PROP_HUMAN_JOG_STANDING", -- Koşu öncesi ısınma
                "PROP_HUMAN_MUSCLE_WEIGHT_LIFT", -- Ağırlık kaldırma
                "PROP_HUMAN_DRINK_BEER", -- Bira içme
                "PROP_HUMAN_SMOKE", -- Sigara içme
                "PROP_HUMAN_CHAMPAGNE", -- Şampanya açma
                "PROP_HUMAN_CHEERING", -- Tezahürat yapma
                "PROP_HUMAN_FIRE_EXTINGUISHER", -- Yangın söndürme
                "WORLD_HUMAN_STUPOR", -- Sarhoş hareketleri
                "WORLD_HUMAN_TENNIS_PLAYER", -- Tenis oynama
                "WORLD_HUMAN_MEDITATING", -- Meditasyon yapma
                "WORLD_HUMAN_JOG_STANDING", -- Koşu yapar gibi durma
                "WORLD_HUMAN_CHEERING", -- Alkışlama
                "WORLD_HUMAN_HAMMERING", -- Çekiçle vurma
                "WORLD_HUMAN_BUM_STANDING", -- Yerde durma
                "WORLD_HUMAN_DRINKING", -- İçecek içme
                "WORLD_HUMAN_GUITAR", -- Gitar çalma
                "WORLD_HUMAN_AA_COFFEE", -- Kahve içme
                "WORLD_HUMAN_AA_SMOKE", -- Sigara içme (grup)
                "WORLD_HUMAN_HIKER_STANDING", -- Doğa yürüyüşü
                "WORLD_HUMAN_WELDING", -- Kaynak yapma
                "WORLD_HUMAN_VEHICLE_MECHANIC", -- Araç tamir etme
                "PROP_HUMAN_STAND_IMPATIENT_UPRIGHT", -- Sabırsızca bekleme
                "WORLD_HUMAN_WINDOW_SHOP_BROWSE", -- Mağaza vitrinine bakma
                "WORLD_HUMAN_CHECKOUT_LINE", -- Kuyrukta bekleme
            }
            
            local playAnim = randomAnims[math.random(#randomAnims)]
            TaskStartScenarioInPlace(charPed, playAnim, 0, true)   
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
    end
end)



-- Events

RegisterNetEvent('qb-multicharacter:client:closeNUIdefault', function() -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
 --   TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
 --   TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    Wait(500)
    openCharMenu()
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('qb-weathersync:client:EnableSync')
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end)

RegisterNetEvent('qb-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('qb-multicharacter:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    local interior = GetInteriorAtCoords(Config.Interior.x, Config.Interior.y, Config.Interior.z - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1000)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    openCharMenu(true)
end)

RegisterNetEvent('qb-multicharacter:client:spawnLastLocation', function(coords, cData)
    QBCore.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
        if result then
            TriggerEvent("apartments:client:SetHomeBlip", result.type)
            local ped = PlayerPedId()
            SetEntityCoords(ped, coords.x, coords.y, coords.z)
            SetEntityHeading(ped, coords.w)
            FreezeEntityPosition(ped, false)
            SetEntityVisible(ped, true)
            local PlayerData = QBCore.Functions.GetPlayerData()
            local insideMeta = PlayerData.metadata["inside"]
            DoScreenFadeOut(500)

            if insideMeta.house then
                TriggerEvent('qb-houses:client:LastLocationHouse', insideMeta.house)
            elseif insideMeta.apartment.apartmentType and insideMeta.apartment.apartmentId then
                TriggerEvent('qb-apartments:client:LastLocationHouse', insideMeta.apartment.apartmentType, insideMeta.apartment.apartmentId)
            else
                SetEntityCoords(ped, coords.x, coords.y, coords.z)
                SetEntityHeading(ped, coords.w)
                FreezeEntityPosition(ped, false)
                SetEntityVisible(ped, true)
            end

            TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
            TriggerEvent('QBCore:Client:OnPlayerLoaded')
            Wait(2000)
            DoScreenFadeIn(250)
        end
    end, cData.citizenid)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if Config.SkipSelection then
        SetNuiFocus(false, false)
        skyCam(false)
    else
        openCharMenu(false)
    end
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb-multicharacter:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
end)

RegisterNUICallback('setupCharacters', function(_, cb)
    QBCore.Functions.TriggerCallback("qb-multicharacter:server:setupCharacters", function(result)
	cached_player_skins = {}
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
        cb("ok")
    end)
end)

RegisterNUICallback('removeBlur', function(_, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "Male" then
        cData.gender = 0
    elseif cData.gender == "Female" then
        cData.gender = 1
    end

    TriggerServerEvent('qb-multicharacter:server:createCharacter', cData)
    Citizen.Wait(500)
end)


RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', data.citizenid)
    DeletePed(charPed)
    TriggerEvent('qb-multicharacter:client:chooseChar')
    cb("ok")
end)