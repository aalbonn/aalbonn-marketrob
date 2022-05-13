local kasa, kasaNo = nil, nil
local drill, temp, aktif = nil, false, true

local kasa, kasaNo = nil, nil
local drill, temp, aktif = nil, false, true

local QBCore = exports['qb-core']:GetCoreObject() --new qb

--[[
QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)
]]

local marketler = {
    [1] = {
        ["basic_kasa"] = vector3(373.49, 328.49, 103.37),
        ["hard_kasa"] = vector3(378.21, 333.79, 103.57),
        ["son_advanced_time"] = 60000 * 3,
    },
    [2] = {
        ["basic_kasa"] = vector3(-1486.45, -378.24, 40.16),
        ["hard_kasa"] = vector3(-1478.71, -375.61, 39.16),
        ["son_advanced_time"] = 60000 * 3,
    },
    [3] = {
        ["basic_kasa"] = vector3(-46.88, -1757.55, 29.42),
        ["hard_kasa"] = vector3(-43.75, -1748.16, 29.42),
        ["son_advanced_time"] = 60000 * 3,
    },
    [4] = {
        ["basic_kasa"] = vector3(1164.38, -322.42, 69.48),
        ["hard_kasa"] = vector3(1159.02, -314.07, 69.48),
        ["son_advanced_time"] = 60000 * 3,
    },
    [5] = {
        ["basic_kasa"] = vector3(-706.47, -913.51, 19.58),
        ["hard_kasa"] = vector3(-710.25, -904.18, 19.22),
        ["son_advanced_time"] = 60000 * 3,
    },
	[6] = {
        ["basic_kasa"] = vector3(1134.26, -982.52, 46.42),
        ["hard_kasa"] = vector3(1126.8, -979.78, 45.42),
        ["son_advanced_time"] = 60000 * 3,
    },
    [7] = {
        ["basic_kasa"] = vector3(24.75, -1344.9, 29.42),
        ["hard_kasa"] = vector3(28.2, -1338.8, 29.42),
        ["son_advanced_time"] = 60000 * 3,
    }
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		local playerPed = PlayerPedId()
		local PlayerCoords = GetEntityCoords(playerPed)
		kasa = nil
		kasaNo = nil
		for i=1, #marketler do
            local basitKasaMesafe = #(PlayerCoords - marketler[i]["basic_kasa"])
			local hardKasaMesafe = #(PlayerCoords - marketler[i]["hard_kasa"])
			if basitKasaMesafe < 1.5 then
				kasa = "basic"
				kasaNo = i
			elseif hardKasaMesafe < 1.5 then
				kasa = "hard"
				kasaNo = i
			end
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		local time = 1000
		if kasa and kasaNo and aktif then
			time = 1
			if kasa == "basic" then 
				QBCore.Functions.DrawText3D(marketler[kasaNo]["basic_kasa"]["x"], marketler[kasaNo]["basic_kasa"]["y"], marketler[kasaNo]["basic_kasa"]["z"]+ 0.1, "[H] Kasayı Maymuncukla", 200)
				if IsControlJustPressed(0, 74) then
					QBCore.Functions.TriggerCallback('aalbonn-base:polis-sayi', function(AktifPolis) --police check
						if AktifPolis >= 0 then
							basicMarketSoy()
						else
							QBCore.Functions.Notify('Yeterli Sayıda Polis Yok', 'error')
						end
					end)
				end
			else
				QBCore.Functions.DrawText3D(marketler[kasaNo]["hard_kasa"]["x"], marketler[kasaNo]["hard_kasa"]["y"], marketler[kasaNo]["hard_kasa"]["z"]-0.5, "[E] Kasayı Del", 250)
				if IsControlJustPressed(0, 38) then
					QBCore.Functions.TriggerCallback('aalbonn-base:polis-sayi', function(AktifPolis) --police check
						if AktifPolis >= 0 then
							hardMarketSoy()
						else
							QBCore.Functions.Notify('Yeterli Sayıda Polis Yok', 'error')
						end
					end)
				end
			end
		end

		if drill then 
			time = 1
			local instructions = CreateInstuctionScaleform("instructional_buttons")
			DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)			
		end
		Citizen.Wait(time)
	end
end)

function basicMarketSoy()
	aktif = false

	QBCore.Functions.Progressbar("maymuncuk_kasa_kontrol", "Checking...", math.random(2000,8000), false, true, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {
        animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 49,
    }, {}, {}, function() -- Done
		QBCore.Functions.TriggerCallback('aalbonn-marketsoygunu:item-ve-sure-kontrol', function(durum)
			if durum then
				QBCore.Functions.TriggerCallback("aalbonn-base:item-kontrol", function(amount)
					if amount > 0 then
						TriggerServerEvent("aalbonn-base:event:removeItem", "lockpick", 1)
						TriggerEvent("aalbonn-PolisBildirim:BildirimGonder", kasaNo .." Numaralı Marketin Kasiyeri Soyuluyor", false) --police alert

						local lockpickAnim = true
						Citizen.CreateThread(function()
							QBCore.Shared.RequestAnimDict('veh@break_in@0h@p_m_one@', function() -- animasyon oynatma
								TaskPlayAnim(PlayerPedId(), 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 3.0, 3.0, -1, 49, 0, false, false, false)
							end)
							
							while lockpickAnim do
								Citizen.Wait(10)
								if not IsEntityPlayingAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1) then
									TaskPlayAnim(PlayerPedId(), 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 3.0, 3.0, -1, 49, 0, false, false, false)
								end
							end
							ClearPedTasks(PlayerPedId())
						end)

						TriggerEvent("lsrp-lockpick:StartLockpickfo", function(result)
							lockpickAnim = false
							if result then
								QBCore.Functions.Notify("Successfully Lockpicked")
								TriggerServerEvent("aalbonn-marketsoygun:item-sil", "basic")
							end
							aktif = true
						end)

					end
				end, "lockpick")
			else
				aktif = true
			end
		end, kasaNo, "basic", "lockpick")
    end, function() -- Cancel
        aktif = true
    end)
end

function hardMarketSoy()
	aktif = false
	QBCore.Functions.Progressbar("del_kasa_kontrol", "Controlling", math.random(2000,8000), false, true, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 49,
    }, {}, {}, function() -- Done
        QBCore.Functions.TriggerCallback('aalbonn-marketsoygunu:item-ve-sure-kontrol', function(durum)
			if durum then
				TriggerEvent("aalbonn-PolisBildirim:BildirimGonder", kasaNo .." Numaralı Marketin Kasası Soyuluyor", false) --police alert
				exports["datacrack"]:Start(5)
			else
				aktif = true
			end
		end, kasaNo, "hard", "security_card_01", "drill")
    end, function() -- Cancel
		aktif = true
    end)
end

AddEventHandler("datacrack", function(output)
    if output then
        QBCore.Functions.Progressbar("kasa_del", "Preparing Robbery.. [DEL Cancel]", marketler[kasaNo]["son_advanced_time"], false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "mini@repair",
			anim = "fixing_a_player",
			flags = 49,
		}, {}, {}, function() -- Done
			startAnim()
			TriggerEvent("Drilling:Start",function(success)
				aktif = true
				stopAnim()
				if success then
					QBCore.Functions.Notify('Successfully Drilled', 'success')
					TriggerServerEvent("aalbonn-marketsoygun:item-sil", "hard")
				else
					QBCore.Functions.Notify("Rob Failed!", "error")
					TriggerServerEvent("QBCore:Server:RemoveItem", "drill", 1)
				end
			end)
		end, function() -- Cancel
			aktif = true
			TriggerServerEvent("aalbonn-marketsoygun:soygun-yapildi", kasaNo, false, "son_advanced_cd")
		end)
    else
        QBCore.Functions.Notify("Hack Error", "error")
    end
end)

function attachObject()
	drill = CreateObject(`hei_prop_heist_drill`, 0, 0, 0, true, true, true)
	AttachEntityToEntity(drill, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 64017), 0.100, 0.0250, 0.018, 0.024, 35.0, 73.0, true, true, false, true, 1, true)
end

function stopAnim()
	StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteObject(drill)
	temp = false
	drill = nil
end

function startAnim()
	if not temp then
		RequestAnimDict("anim@heists@fleeca_bank@drilling")
		while not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") do
			Citizen.Wait(0)
		end
		attachObject()
		TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 8.0, 8.0, -1, 1, 0, false, false, false)
		temp = true
	end
end

function CreateInstuctionScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(5)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 172, true))
	InstructionButtonMessage("Matkabı İttir")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(4)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 173, true))
	InstructionButtonMessage("Matkabı Çek")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(3)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 175, true))
	InstructionButtonMessage("Matkabı Hızlandır")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(2)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 174, true))
	InstructionButtonMessage("Matkabı Yavaşlat")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 177, true))
	InstructionButtonMessage("İptal")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()

	return scaleform
end

function InstructionButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end
