ESX = nil

AdminList = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addGroupCommand', 'adminmode', 'admin', function(source, args, user)
	local found = nil
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = GetPlayerName(source)
		for i, v in ipairs(AdminList) do
            if v.id == source then
				found = i
				break
			end
        end

        if found == nil then
            TriggerClientEvent('esx:showNotification', source, 'Du hast den ~b~Adminmode ~g~aktiviert')
			TriggerEvent('vace-adminmode:updatelist', 'Teammitglied - nicht beachten', false, source)
			sendToDiscord('Supportrechte aktiviert','Das Teammitglied ' .. name .. ' hat den Adminmode aktiviert.', 56108)
            TriggerClientEvent('vace-adminmode:setGodmode', source, true)
            TriggerClientEvent('vace-adminmode:setOutfit', source)
        else
            TriggerClientEvent('esx:showNotification', source, 'Du hast den ~b~Adminmode ~r~deaktiviert')
            TriggerEvent('vace-adminmode:updatelist', 'Teammitglied - nicht beachten', true, source)
			TriggerClientEvent('vace-adminmode:setGodmode', source, false)
			sendToDiscord('Supportrechte deaktiviert','Das Teammitglied ' .. name ..  ' hat den Adminmode deaktiviert.',56108)
			TriggerClientEvent('vace-adminmode:zivil', source)
		end
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Keine Rechte!' } })
end, {help = 'Aktiviere / Deaktiviere den Adminmode'})

function sendToDiscord (name,message,color)
	local DiscordWebHook = "WEBHOOK"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
  local embeds = {
	  {
		  ["title"]=message,
		  ["type"]="rich",
		  ["color"] =color,
		  ["footer"]=  {
		  ["text"]= "21States",
		 },
	  }
  }
  
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('vace-adminmode:isAdmin', function(source, cb)
    local found = nil
    for i, v in ipairs(AdminList) do
        if v.id == source then
            found = i
            break
        end
    end

    if found == nil then
        cb(false)
    else
        cb(true)
    end
end)

RegisterServerEvent('vace-adminmode:updatelist')
AddEventHandler('vace-adminmode:updatelist', function(name2, removebool, id)
	if removebool then
		local found = nil
		for i, v in ipairs(AdminList) do
			if v.id == id then
				found = i
				break
			end
		end
		if found ~= nil then
			table.remove(AdminList, found)
		end
	else
		local found = nil
		for i, v in ipairs(AdminList) do
			if v.id == id then
				found = i
				break
			end
		end
		if found ~= nil then
			table.remove(AdminList, found)
		end
		table.insert(AdminList, {name=name2, id=id})
	end
	
    TriggerClientEvent('vace-adminmode:clupdatelist', -1, AdminList)
end) 