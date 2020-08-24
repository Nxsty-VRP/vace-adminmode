ESX = nil

AdminList = {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
  end)

RegisterNetEvent('vace-adminmode:clupdatelist')
AddEventHandler('vace-adminmode:clupdatelist', function(list) 
    AdminList = list
end)

RegisterNetEvent('vace-adminmode:setGodmode')
AddEventHandler('vace-adminmode:setGodmode', function(state)
    SetEntityInvincible(GetPlayerPed(-1), state)
end)

RegisterNetEvent('vace-adminmode:setOutfit')
AddEventHandler('vace-adminmode:setOutfit', function()
    SetPedComponentVariation(GetPlayerPed(-1), 0, 1, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 1, 52, 0, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 2, 1, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 3, 42, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 4, 77, 2, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 6, 55, 2, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 1, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 11, 178, 2, 0)
    SetPedPropIndex(GetPlayerPed(-1), 0, 91, 2, 0)
end)

RegisterNetEvent('vace-adminmode:zivil')
AddEventHandler('vace-adminmode:zivil', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

Citizen.CreateThread(function () 
	while true do
        for i, v in ipairs(AdminList) do
			if GetPlayerPed( -1 ) ~= GetPlayerPed( GetPlayerFromServerId(v.id) ) then
				ped = GetPlayerPed(GetPlayerFromServerId(v.id))
				x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
				x2, y2, z2 = table.unpack( GetEntityCoords( ped, true ) )
				
				
				distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
				
				if (distance < 50) then
					DrawText3D(x2, y2, z2 + 1.25, 255, 55, 55, v.name)
				end
			end
		end
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
    Wait(300000)

    ESX.TriggerServerCallback('vace-adminmode:isAdmin', function(enabled)
        if enabled then
            TriggerEvent("chatMessage", "", {255,0,0}, 'Du hast den Adminmode noch aktiviert, beachte diesen nicht auszunutzen!')
        end
    end)
    end
end)

function DrawText3D(x,y,z, red, green, blue, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(red, green, blue, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end