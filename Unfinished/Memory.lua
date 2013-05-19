--[[
	Idea to write Memory in Lua: Engineer
	This header can't be edited in any way.
]]

-- 'global variables'
local width, height = term.getSize()
local credits = 0
local nPairs = 0


-- The error crap! :P
if not term.isColor() then
	printError("Advanced computer required")
	return
end

-- Terminal drawing

local cards = { -- Assuming screen is atleast 19 high and a width of 51 px
	open = {	-- Width: 8, height: 5
		[[.------.]],
		[[| .--. |]],
		[[| :/\: |]],
		[[| (__) |]],
		[[| '--' |]],
		[['------']]
	},
	closed_stacked_inside = { -- width: 11 height: 12
		[[......]],
		[[.o00o.]],
	},
	closed_stacked_outline = {
		[[.------.   ]],
		[[|      |   ]], 
		[[|.------.  ]],
		[[||      |  ]],
		[[||.------. ]],
		[['||      | ]],
		[[ ||.------.]],
		[[ '||      |]],
		[[  ||      |]],
		[[  '|      |]],
		[[   |      |]],
		[[   '------']]
	}
}

local writeShapeLine = function( x, y, shape, line )
	term.setCursorPos( x, y )
	write( shape[line] )
end

term.setBackgroundColor( colors.white )
term.clear()

local amountW =  math.floor( width / 11 )
local amountH = math.floor( height / 12 )

for i = 1, amountH * 12, 12 do
	for j = 1, amountW * 11, 11 do
		term.setTextColor( colors.black )
		for k = 1, #cards.closed_stacked_outline do
			writeShapeLine( j, i + k - 1, cards.closed_stacked_outline, k )
		end
		term.setTextColor( colors.red )
		for k = 1, 3, 1 do
			writeShapeLine( j + k, i + 1 + ( ( k - 1 ) * 2 ), cards.closed_stacked_inside, 1 )
		end

		writeShapeLine( j + 4, i + 7, cards.closed_stacked_inside, 1 )
		writeShapeLine( j + 4, i + 8, cards.closed_stacked_inside, 2 )
		writeShapeLine( j + 4, i + 9, cards.closed_stacked_inside, 2 )
		writeShapeLine( j + 4, i + 10, cards.closed_stacked_inside, 1 )

	end
end

term.setCursorPos( 1, height )
term.setBackgroundColor( colors.lightGray )
write( string.rep(" ", width ))

term.setCursorPos( 1, height )
term.setTextColor( colors.black )
write("Pairs: " .. nPairs .. string.rep(" ", 10 - #tostring(nPairs)) .. "Credits: " .. credits )
write( string.rep(" ", width - #tostring(credits) - 41) .. "Time:")

-- Randomize the crap out of it!

local main = {}
local sub = {}

local cardCount = 1

for i = 65, 90 do main[#main + 1] = string.char(i); sub[#sub + 1] = string.char(i) end
for i = 97, 122 do sub[#sub + 1] = string.char(i) end
for i = 48, 57 do sub[#sub + 1] = string.char(i) end

local randomNumb = function()
	local sMain = math.floor(cardCount/62) >= 0 and main[1] or main[math.floor(cardCount/62) + 1]

	local temp = cardCount
	while temp > 0 do
		temp = temp - 62
	end
	
	local sSub = sub[temp + 62]
	cardCount = cardCount + 1

	return sSub, sMain
end

local dynamicMap = {}
local unusedIndex = {}

for i = 1, amountH * amountW * 4 do unusedIndex[i] = i end
for i = 1, amountH * amountW * 2 do
	local fIndex = math.random(#unusedIndex)
	dynamicMap[fIndex] = {randomNumb()}
	table.remove( unusedIndex, fIndex )
	
	local sIndex = math.random(#unusedIndex)
	table.remove( unusedIndex, sIndex )
	dynamicMap[sIndex] = dynamicMap[fIndex]
end

-- reformat the table

local nativeDynamicMap = dynamicMap
dynamicMap = {}

for i = 1, #nativeDynamicMap, 4 do
	dynamicMap[i] = {}
	for j = 1, 4 do
		dynamicMap[i][j] = nativeDynamicMap[ j + i ]
	end
end

-- main functions
