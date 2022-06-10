-- KeyboardInput
function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end
--

-- Drogues

RegisterNetEvent('esx_basicneeds:test')
AddEventHandler('esx_basicneeds:test', function()
    applyDrugsEffects()
    testDrugEffect()
end)

function startDrugTimer()
    CreateThread(function()
        hasDrugEffect = true

        local timeToWait = GetGameTimer() + 5 * 500
        while GetGameTimer() < timeToWait do
            Wait(1)
        end

        hasDrugEffect = false
    end)
end

function applyDrugsEffects()
    -- If the player already has consum drug in less than 10 minutes
    if hasDrugEffect then
        SetEntityHealth(PlayerPedId(), 0)
        return
    end

    -- Start 10 minutes timer
    startDrugTimer()

    -- Apply drug effect
    ESX.Streaming.RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
    Wait(5000)
    DoScreenFadeOut(1000)
    Wait(1000)
    ClearPedTasksImmediately(PlayerPedId())
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
    SetPedIsDrunk(PlayerPedId(), true)
    DoScreenFadeIn(1000)
    SetTimeout(60 * 1000, function()
        DoScreenFadeOut(1000)
        Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(PlayerPedId(), 0)
        SetPedIsDrunk(PlayerPedId(), false)
        SetPedMotionBlur(PlayerPedId(), false)
    end)
end

function testDrugEffect()
    local playerHealth = GetEntityHealth(PlayerPedId())

    if playerHealth <= GetEntityMaxHealth(PlayerPedId()) - 10 then
        SetEntityHealth(PlayerPedId(), playerHealth + 10) -- 10% of the player life
    end
end

function testDrugEffect()
    local playerHealth = GetEntityHealth(PlayerPedId())

    if playerHealth <= GetEntityMaxHealth(PlayerPedId()) - 10 then
        SetEntityHealth(PlayerPedId(), playerHealth + 10) -- 10% of the player life
    end
end

function testDrugEffect()
    local playerHealth = GetEntityHealth(PlayerPedId())

    if playerHealth <= GetEntityMaxHealth(PlayerPedId()) - 10 then
        SetEntityHealth(PlayerPedId(), playerHealth + 10) -- 10% of the player life
    end
end
