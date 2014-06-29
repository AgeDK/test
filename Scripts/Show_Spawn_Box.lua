require("libs.Utils")

spots = {
--radian
{2240,-4288,3776,-5312}, -- easy
{2688,-2944, 3776,-4096}, -- hard near rune
{1088,-3200,2304,-4544}, -- medium near rune
}

local toggleKey = string.byte("L")
local check = true

local eff = {}
local eff1 = {}
local eff2 = {}
local eff3 = {}
local eff4 = {}

local effec = "candle_flame_medium" -- ambient_gizmo_model

--[[

	a----b
	|	 |
	|	 |
	d----c
	
	a 2240;-4288
	c 3776;-5312

]]

function Key(msg,code)

	if msg ~= KEY_UP or code ~= toggleKey or client.chat or not client.connected or client.loading or client.console then
    	return
    end
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
	check = (not check)

	for i,k in ipairs(spots) do
		
		local vec = Vector(me.position.x,me.position.y,me.position.z)
		
		if (GetDistance2D(Vector(k[1],k[2],0),vec) < 1500 or GetDistance2D(Vector(k[3],k[4],0),vec) < 1500) and not eff[i] and check then
			
			local coint1 = math.floor(math.floor(k[3]-k[1])/50)
			local coint2 = math.floor(math.floor(k[2]-k[4])/50)
			
			eff[i] = {}		
			
			for a = 1,40 do
				eff[i].eff1 = {} eff[i].eff2 = {}	
				eff[i].eff3 = {} eff[i].eff4 = {}
			end		
			
			for a = 1,coint1 do
				local first = Vector(k[1]+a*50, k[4], 0)
				local second = Vector(k[1]+a*50, k[2], 0)				
				eff[i].eff1[a] = Effect(first,effec)
				eff[i].eff1[a]:SetVector(0,GetVector(first))				
				eff[i].eff3[a] = Effect(second,effec)
				eff[i].eff3[a]:SetVector(0,GetVector(second))
			end
			
			for a = 1,coint2 do		
				local first = Vector(k[1], k[4]+a*50, 0)
				local second = Vector(k[3], k[4]+a*50, 0)				
				eff[i].eff2[a] = Effect(first,effec)
				eff[i].eff2[a]:SetVector(0,GetVector(first))				
				eff[i].eff4[a] = Effect(second,effec)
				eff[i].eff4[a]:SetVector(0,GetVector(second))
			end
			
		elseif eff[i] and not check then
			eff[i] = nil
			collectgarbage("collect")
		end
	
	end
	
end

function GetVector(Vec)
	retVector = Vec
	client:GetGroundPosition(retVector)
	retVector.z = retVector.z+50
	return retVector
end

function GameClose()
	eff = {}
	eff1 = {}
	eff2 = {}
	eff3 = {}
	eff4 = {}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_KEY,Key)
