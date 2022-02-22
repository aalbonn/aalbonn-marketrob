QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local basicBeklemeCd = 7200
local hardBeklemeCd = 7200

local marketler = {
    [1] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [2] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [3] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [4] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [5] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [6] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [7] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [8] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [9] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [10] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [11] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [12] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
	[13] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
	[14] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [15] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
	[16] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
    [17] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
	[18] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
	[19] = {
		["son_basic_cd"] = 0,
        ["son_advanced_cd"] = 0,
    },
}

QBCore.Functions.CreateCallback('aalbonn-marketsoygunu:item-ve-sure-kontrol', function(source, cb, marketNo, tip, item1, item2)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        if marketNo == nil then    
            TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Too far from the case!", "error")
            cb(false)
        else
            if tip == "basic" and (os.time() - marketler[marketNo]["son_basic_cd"]) > basicBeklemeCd then
                local gerekenItem1 = xPlayer.Functions.GetItemByName(item1)
                if gerekenItem1.amount >= 1 then
                    cb(true)
                    marketler[marketNo]["son_basic_cd"] = os.time()
                else
                    TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "You dont have any " .. QBCore.Shared.Items[item1].label .. " !", "error")
                    cb(false)
                end
            elseif tip == "hard" and (os.time() - marketler[marketNo]["son_advanced_cd"]) > hardBeklemeCd then
                local gerekenItem1 = xPlayer.Functions.GetItemByName(item1)
                if gerekenItem1.amount >= 1 then
                    local gerekenItem2 = xPlayer.Functions.GetItemByName(item2)
                    if gerekenItem2.amount >= 1 then
                        marketler[marketNo]["son_advanced_cd"] = os.time()
                        cb(true)
                    else
                        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "You dont have any " .. QBCore.Shared.Items[item2].label .. " !", "error")
                        cb(false)
                    end
                else
                    TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "You dont have any " .. QBCore.Shared.Items[item1].label .. " !", "error")
                    cb(false)
                end
            else
                TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Case Empty!", "error")
                cb(false)
            end   
        end
    end
end)

RegisterServerEvent("aalbonn-marketsoygun:soygun-yapildi")
AddEventHandler("aalbonn-marketsoygun:soygun-yapildi", function(kasaNo, durum, tip)
    if durum then
        marketler[kasaNo][tip] = os.time()
    else
        marketler[kasaNo][tip] = 0
    end
end)

RegisterServerEvent("aalbonn-marketsoygun:item-sil")
AddEventHandler("aalbonn-marketsoygun:item-sil", function(key, tip)
    local src = source
    if QBCore.Functions.kickHacKer(src, key) then -- QBCore.Key
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer then
            if tip == "basic" then
                if math.random(0,100) < 50 then
                    xPlayer.Functions.AddItem("template_card", 1)
                    TriggerEvent('DiscordBot:ToDiscord', 'market', 'Market Rob(Front): Template Card', src)
                end
                local para = math.random(50, 80)
                xPlayer.Functions.AddMoney('cash', para)
                TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Got " .. para .. "$ at the case")
                TriggerEvent('DiscordBot:ToDiscord', 'market', 'Market Rob(Front): $'.. para, src)
            elseif tip == "hard" then
                if xPlayer.Functions.RemoveItem("drill", 1) then
                    if xPlayer.Functions.RemoveItem("template_card", 1) then
                        if math.random(0,100) < 55 then
                            xPlayer.Functions.AddItem("green_card", 1)
                            TriggerEvent('DiscordBot:ToDiscord', 'market', 'Market Rob(Back): Green Card', src)
                        end
                        local para = math.random(400, 1200)
                        xPlayer.Functions.AddMoney('cash', para)
						xPlayer.Functions.AddItem("weed", 2)
                        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Got " .. para .. "$ at the case")
                        TriggerEvent('DiscordBot:ToDiscord', 'market', 'Market Rob(Back): $'.. para, src)
                    end
                end
            elseif tip == "drill" then
                xPlayer.Functions.RemoveItem("drill", 1)
                xPlayer.Functions.RemoveItem("template_card", 1)
            end
        end
    end
end)


--webhook


logs = {
["market"] = "WEBHOOK_HERE"
}


RegisterServerEvent('DiscordBot:ToDiscord')
AddEventHandler('DiscordBot:ToDiscord', function(WebHook, Message, player, target)
	local msg = ""
	if player then
		local xPlayer = QBCore.Functions.GetPlayer(player)
		if xPlayer then
			msg = xPlayer.PlayerData.citizenid .. " " .. xPlayer.PlayerData.steam .. " " .. xPlayer.PlayerData.charinfo.firstname.. " " ..xPlayer.PlayerData.charinfo.lastname .. " **"..Message.."**"
		else
			msg = GetPlayerName(src) ..'('.. GetPlayerIdentifiers(src)[1] ..') [xPlayer Not Found!] **'..Message..'**'
		end
		if target then
			local tPlayer = QBCore.Functions.GetPlayer(target)
			if tPlayer then
				msg = msg .. " > " .. tPlayer.PlayerData.citizenid .. " " .. tPlayer.PlayerData.steam .. " " .. tPlayer.PlayerData.charinfo.firstname.. " " ..tPlayer.PlayerData.charinfo.lastname
			else
				msg = msg.. " ".. GetPlayerName(src) ..'('.. GetPlayerIdentifiers(src)[1] ..') [tPlayer Not Found!] '
			end
		end
	else
		msg = Message
	end
	PerformHttpRequest(logs[WebHook:lower()], function() end, 'POST', json.encode({username = Config.SystemName, content = msg, avatar_url = Config.SystemAvatar, tts = false}), {['Content-Type'] = 'application/json'})
end)

function errorLog(x)
    print("^5[aalbonn]^1 " .. x .."^0")
    
end
if GetCurrentResourceName() == "aalbonn-marketrob" then
    errorLog("Don't Change the resource name")  
  
  elseif GetCurrentResourceName() ~= "aalbonn-marketrob" then
    errorLog("Don't Change the resource name")  
    errorLog('This recource should be named "aalbonn-marketrob" for the exports to work properly.')  
  end
