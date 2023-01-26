------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	ESO EMOJI BASICS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ESOEmoji = {}
local ee = ESOEmoji
ee.version = "v0.4.0-Alpha"
ee.name = "ESOEmoji"
ee.previousText = nil
ee.previousColour = nil
ee.textBox = nil
local vars = {} -- Settings
local DefaultSettings = { -- Default
	showChatBar = true,
	previewString = true,
	realtimeEdit = true,
	emojiSettings = {
		Size = 28,
		Path = "ESOEmoji/icons/openmoji-72x72-colour-dds/",
		SCEnabled = true,
		CustomEnabled = false,
		StandardEnabled = true,
	},
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	ON ADD-ON LOADED	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ee.OnAddOnLoaded(eventCode, addonName)
	if addonName ~= ee.name then return end
	
	ee:Initialize()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	UTILITY FUNCTIONS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ee:GetVars()
	return vars
end

function ee.GetTextureLinkIcon(icon, location, size, colour)
	local path = ""
	if location == 0 then -- Base game
		path = icon
	elseif location == 1 then -- Immersive custom icons
		path = "ESOEmoji/icons/Immersive-dds/" .. icon
	end
	local textureLink = "|t" .. tostring(vars.emojiSettings.Size) .. ":" .. tostring(vars.emojiSettings.Size) .. ":" .. path
	if size ~= nil then
		textureLink = "|t" .. tostring(math.floor(size/28*vars.emojiSettings.Size + 0.5)) .. ":" .. tostring(math.floor(size/28*vars.emojiSettings.Size + 0.5)) .. ":" .. path
	end
	if colour == nil then
		textureLink = textureLink .. "|t"
	else
		textureLink = "|c" .. colour .. textureLink .. ":inheritcolor|t|r"
	end
	
	return textureLink
end


function ee.DisplayVersion()
	d("ESO Emoji version: " .. ee.version)
end

function ee.test(extra)
	--local textEntry = KEYBOARD_CHAT_SYSTEM:GetControl()
	--local channelLabel = textEntry:GetNamedChild("Label")
	--ee.previousColour = channelLabel.GetColour()
	--d(ee.previousColour)
	
--	local links = {}
--	extra = tostring(extra)
--	local text = {}
--	local noLinkText = ""
--	local link = ""
--	local linkend = ""
--	for link in string.gmatch(extra, "[%|][hH][%a%d%:]+[%|][hH][%|][hH]") do
--		links[#links+1] = link
--	end
--	noLinkText = extra:gsub("[%|][hH][%a%d%:]+[%|][hH][%|][hH]", "")
--	d(noLinkText)
--	d(links)
	
--	local links = {}
--	local frag = string.match(extra, "[%|][hH][%a%d%:]+[%|][hH][%|][hH]")
--	d(frag)
--	local i = 1
--	repeat
--		local s, e = string.find(extra, "[%|][hH][%a%d%:]+[%|][hH][%|][hH]", i)
--		links[#links+1] = {sval = s, eval = e}
--		i = tonumber(e)
--	until sval == nil or eval == nil
--	d(links)
--	ee.GetVars().emojiSettings.Size = tonumber(extra)
--	ee.GetVars().emojiSettings.CustomEnabled = false
	ee.GetVars().realtimeEdit = true
end

function ee.Pop(num)
	local popDisplay = ""
	local campaign = nil
	local pop = {
		[0] = "esoui/art/campaign/campaignbrowser_lowpop.dds",
		[1] = "esoui/art/campaign/campaignbrowser_medpop.dds",
		[2] = "esoui/art/campaign/campaignbrowser_hipop.dds",
		[3] = "esoui/art/campaign/campaignbrowser_fullpop.dds",
	}
	local AD = {
		["colour"] = "FFD700", -- gold colour
		["icon"] = ee.GetTextureLinkIcon("esoui/art/campaign/gamepad/gp_overview_allianceicon_aldmeri.dds", 0, 25),--ee.emojiSCs["ad"].func,
		["pop"] = "",
	}
	local EP = {
		["colour"] = "FF2400", -- red colour
		["icon"] = ee.GetTextureLinkIcon("esoui/art/campaign/gamepad/gp_overview_allianceicon_ebonheart.dds", 0, 25),--ee.emojiSCs["ep"].func,
		["pop"] = "",
	}
	local DC = {
		["colour"] = "0096FF", -- blue colour
		["icon"] = ee.GetTextureLinkIcon("esoui/art/campaign/gamepad/gp_overview_allianceicon_daggerfall.dds", 0, 25),--ee.emojiSCs["dc"].func,
		["pop"] = "",
	}
	
	QueryCampaignSelectionData()
	for i = 1, GetNumSelectionCampaigns() do
		if GetSelectionCampaignId(i) == num then -- campaign id 103 is ravenwatch, 102 is greyhost
			campaign = i
		end
	end
	
	local temp = pop[GetSelectionCampaignPopulationData(campaign, ALLIANCE_ALDMERI_DOMINION)]
	AD.pop = ee.GetTextureLinkIcon(temp, 0, nil, AD.colour)
	temp = pop[GetSelectionCampaignPopulationData(campaign, ALLIANCE_EBONHEART_PACT)]
	EP.pop = ee.GetTextureLinkIcon(temp, 0, nil, EP.colour)
	temp = pop[GetSelectionCampaignPopulationData(campaign, ALLIANCE_DAGGERFALL_COVENANT)]
	DC.pop = ee.GetTextureLinkIcon(temp, 0, nil, DC.colour)
	
	popDisplay = AD.icon .. AD.pop .. EP.icon .. EP.pop .. DC.icon .. DC.pop
	return popDisplay
end -- |cFFD700|t150%:150%:esoui/art/campaign/campaignbrowser_fullpop.dds:inheritcolor|t|r
-- |cFFD700|t28:28:esoui/art/campaign/overview_allianceicon_aldmeri.dds:inheritcolor|t|r
-- |c8a0303|t28:28:esoui/art/campaign/overview_allianceicon_ebonheart.dds:inheritcolor|t|r
-- |c000080|t28:28:esoui/art/campaign/overview_allianceicon_daggefall.dds:inheritcolor|t|r

-- |cFFD700|t28:28:ESOEmoji/icons/Immersive-dds/stamplar.dds:inheritcolor|t|r
--|t28:28:ESOEmoji/icons/Immersive-dds/magplar.dds|t

-- |t28:28:esoui/art/ava/ava_keepstatus_icon_food_aldmeri.dds|t

-- |t20:20:esoui/art/campaign/gamepad/gp_overview_allianceicon_aldmeri.dds|t

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CheckByte(myByte) -- TODO: I can prob optimise runtime of this (I was sleep deprived when I wrote this and I forgot how)
	if myByte <= 255 then -- make sure its at most 8 bits
		if BitRShift(myByte, 6) == 2 then
			return 0
		end
		if BitRShift(myByte, 7) == 0 then
			return 1
		end
		if BitRShift(myByte, 5) == 6 then
			return 2
		end
		if BitRShift(myByte, 4) == 14 then
			return 3
		end
		if BitRShift(myByte, 3) == 30 then
			return 4
		end
		if BitRShift(myByte, 2) == 62 then
			return 5
		end
		if BitRShift(myByte, 1) == 126 then
			return 6
		end
	end
	return -1
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function BitRShift(number, n)
	for i=1, n do
		number = math.floor(number/2)
	end
	return number
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function BitLShift(number, n)
	for i=1, n do
		number = math.floor(number*2)
	end
	return number
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function BitAnd(a, b)
	local result = 0
    local bitVal = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitVal      -- set the current bit
      end
      bitVal = BitLShift(bitVal, 1)
      a = BitRShift(a, 1)
      b = BitRShift(b, 1)
    end
    return result
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function BitOr(a, b)
	local result = 0
    local bitVal = 1
    while a > 0 or b > 0 do
      if a % 2 == 1 or b % 2 == 1 then -- test the rightmost bits
          result = result + bitVal      -- set the current bit
      end
      bitVal = BitLShift(bitVal, 1)
      a = BitRShift(a, 1)
      b = BitRShift(b, 1)
    end
	
    return result
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Dec2Hex(number)
	local hDigits = {"1","2","3","4","5","6","7","8","9","A","B","C","D","E","F",[0] = "0"}
	if number < 16 then
		return hDigits[number]
	end
	local result = hDigits[number % 16]
	repeat 
		number = math.floor(number / 16)
		result = hDigits[number % 16] .. result
	until(number < 16)
	return result
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Hex2Dec(number)
	if number == "" then
		number = "0"
	end
	return tonumber(number,16)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Bytes2Unicode(bytes)
	local t = {}
	local n = #bytes
	local uCode = "U+"
	
	if n == 1 then
		t[1] = Dec2Hex(BitAnd(BitRShift(bytes[1], 4), 15))
		t[2] = Dec2Hex(BitAnd(bytes[1], 15))
		
	elseif n == 2 then
		t[1] = Dec2Hex(BitAnd(BitRShift(bytes[1], 2), 15))
		t[2] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[1], 3), 2), BitAnd(BitRShift(bytes[2], 4), 3)))
		t[3] = Dec2Hex(BitAnd(bytes[2], 15))

	elseif n == 3 then
		t[1] = Dec2Hex(BitAnd(bytes[1], 15))
		t[2] = Dec2Hex(BitAnd(BitRShift(bytes[2], 2), 15))
		t[3] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[2], 3), 2), BitAnd(BitRShift(bytes[3], 4), 3))) --
		t[4] = Dec2Hex(BitAnd(bytes[3], 15))

	elseif n == 4 then
		t[1] = Dec2Hex(BitAnd(BitRShift(bytes[1], 2), 1))
		t[2] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[1], 3), 2), BitAnd(BitRShift(bytes[2], 4), 3)))
		t[3] = Dec2Hex(BitAnd(bytes[2], 15))
		t[4] = Dec2Hex(BitAnd(BitRShift(bytes[3], 2), 15))
		t[5] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[3], 3), 2), BitAnd(BitRShift(bytes[4], 4), 3))) --
		t[6] = Dec2Hex(BitAnd(bytes[4], 15))

	elseif n == 5 then
		t[1] = Dec2Hex(BitAnd(bytes[1], 3))
		t[2] = Dec2Hex(BitAnd(BitRShift(bytes[1], 2), 15))
		t[3] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[2], 3), 2), BitAnd(BitRShift(bytes[3],4), 3)))
		t[4] = Dec2Hex(BitAnd(bytes[3], 15))
		t[5] = Dec2Hex(BitAnd(BitRShift(bytes[4], 2), 15))
		t[6] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[4], 3), 2), BitAnd(BitRShift(bytes[5],4), 3)))
		t[7] = Dec2Hex(BitAnd(bytes[5], 15))

	elseif n == 6 then
		t[1] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[1], 1), 2), BitAnd(BitRShift(bytes[1],4), 3)))
		t[2] = Dec2Hex(BitAnd(bytes[2], 15))
		t[3] = Dec2Hex(BitAnd(BitRShift(bytes[3], 2), 15))
		t[4] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[3], 3), 2), BitAnd(BitRShift(bytes[4],4), 3)))
		t[5] = Dec2Hex(BitAnd(bytes[4], 15))
		t[6] = Dec2Hex(BitAnd(BitRShift(bytes[5], 2), 15))
		t[7] = Dec2Hex(BitOr(BitLShift(BitAnd(bytes[5], 3), 2), BitAnd(BitRShift(bytes[6],4), 3)))
		t[8] = Dec2Hex(BitAnd(bytes[6], 15))
	else
		return nil
	end
	for i = 1, #t do
		uCode =  uCode .. t[i]
	end
	uCode,_ = uCode:gsub('^(U%+)[0]+', "U+") -- Remove any pesky leading zeros.
	uCode,_ = uCode:gsub('^(U%+)', "") -- Remove the U+, might change this depending on how useful the U+ is.
	return uCode
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Unicode2Bytes(uCode)
	local nBytes = 0
	local cPoint = {
		[0] = 0,
	}
	local bytes = {}
	local result = ""

	local decUCode = Hex2Dec(uCode)
	if decUCode == nil then
		return uCode
	end
	if decUCode >= 0 and decUCode < 128 then
		nBytes = 1
	elseif decUCode >= 128 and decUCode < 2048 then
		nBytes = 2
	elseif decUCode >= 2048 and decUCode < 65536 then
		nBytes = 3
	elseif decUCode >= 65536 and decUCode < 1114112 then
		nBytes = 4
	elseif decUCode >= 1114112 and decUCode < 67108863 then
		nBytes = 5
	elseif decUCode >= 67108863 and decUCode < 2147483647 then -- to 2^31
		nBytes = 6
	else
		nBytes = 0
	end
	
	for i = #uCode, 1, -1 do
		cPoint[i] = Hex2Dec(string.sub(uCode,i,i))
	end
	
	if nBytes == 1 then
		bytes[1] = BitOr(BitLShift(BitAnd(cPoint[#uCode-1],7),4),cPoint[#uCode])
	elseif nBytes == 2 then
		bytes[1] = BitOr(BitOr(BitLShift(6,5),BitLShift(BitAnd(cPoint[#uCode-2],7), 2)),BitRShift(cPoint[#uCode-1],2))
		bytes[2] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-1], 3),4),cPoint[#uCode]))
	elseif nBytes == 3 then
		bytes[1] = BitOr(BitLShift(14,4),cPoint[#uCode-3])
		bytes[2] = BitOr(BitLShift(2,6),BitOr(BitLShift(cPoint[#uCode-2],2),BitRShift(cPoint[#uCode-1],2)))
		bytes[3] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-1],3),4),cPoint[#uCode]))
	elseif nBytes == 4 then
		bytes[1] = BitOr(BitLShift(30,3),BitOr(BitLShift(BitAnd(cPoint[#uCode-5],1),2),BitRShift(cPoint[#uCode-4],2)))
		bytes[2] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-4],3),4),cPoint[#uCode-3]))
		bytes[3] = BitOr(BitLShift(2,6),BitOr(BitLShift(cPoint[#uCode-2],2),BitRShift(cPoint[#uCode-1],2)))
		bytes[4] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-1],3),4),cPoint[#uCode]))
	elseif nBytes == 5 then
		bytes[1] = BitOr(BitLShift(62,2),BitAnd(cPoint[#uCode-6],3))
		bytes[2] = BitOr(BitLShift(2,6),BitOr(BitLShift(cPoint[#uCode-5],2),BitRShift(cPoint[#uCode-4],2)))
		bytes[3] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-4],3),4),cPoint[#uCode-3]))
		bytes[4] = BitOr(BitLShift(2,6),BitOr(BitLShift(cPoint[#uCode-2],2),BitRShift(cPoint[#uCode-1],2)))
		bytes[5] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-1],3),4),cPoint[#uCode]))
	elseif nBytes == 6 then
		bytes[1] = BitOr(BitLShift(126,1),BitRShift(BitAnd(cPoint[#uCode-7],4),2))
		bytes[2] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-7],3),4),cPoint[#uCode-6]))
		bytes[3] = BitOr(BitLShift(2,6),BitOr(BitLShift(cPoint[#uCode-5],2),BitRShift(cPoint[#uCode-4],2)))
		bytes[4] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-4],3),4),cPoint[#uCode-3]))
		bytes[5] = BitOr(BitLShift(2,6),BitOr(BitLShift(cPoint[#uCode-2],2),BitRShift(cPoint[#uCode-1],2)))
		bytes[6] = BitOr(BitLShift(2,6),BitOr(BitLShift(BitAnd(cPoint[#uCode-1],3),4),cPoint[#uCode]))
	else
		return nil
	end
	for i = 1, #bytes do
		result = result .. string.char(bytes[i])
	end
	
	return result
end

local function Num2Bool(num)
	if num > 1 then
		return -1
	end
	if num == 1 then
		return true
	elseif num == 0 then
		return false
	end
end

local function Bool2Num(bool)
	if bool then
		return 1
	else
		return 0
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	STANDARD FUNCTIONS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function editSC(message, ntype)	--ntype is a 2-bit binary number indicating whether shortcodes and custom emojis are enabled. example: 01 = Custom is disabled, shortcodes enabled
	if ntype == 0 or ntype > 3 then		-- "but ma'am, can't you just use vars instead of sending a parameter?"
		return message					-- yeap, and it probably should work that way, but I did it this way for some reason and I forgot what that reason was. I should probably change it to use vars
	end
	local shortcode = ""
	local uCode
	local editStandard =  Num2Bool(BitAnd(ntype, 1))
	local editCustom =  Num2Bool(BitAnd(BitRShift(ntype, 1), 1))
	
	for shortcode in string.gmatch(message, "[%:]([^%:%s]+)[%:]") do
		if ee.emojiSCs[shortcode] then
			if ee.emojiSCs[shortcode].unicode and editStandard then
				--textureLink = "|t" .. tostring(vars.emojiSettings.Size) .. ":" .. tostring(vars.emojiSettings.Size) .. ":" .. vars.emojiSettings.Path .. ee.emojiMap[ee.emojiSCs[shortcode].unicode].texture .. "|t"
				--message,_ = message:gsub("[%:]" .. shortcode .. "[%:]", textureLink)
				local result = ""
				for uCode in string.gmatch(ee.emojiSCs[shortcode].unicode, "([%u%1%d]+)") do
				--Encode
					result = result .. Unicode2Bytes(uCode)
				end
				message,_ = message:gsub("[%:]" .. shortcode .. "[%:]", result)
			elseif ee.emojiSCs[shortcode].func and editCustom then -- Special shortcode, therefore it actually needs a function to return a string WIP
				message,_ = message:gsub("[%:]" .. shortcode .. "[%:]", ee.GetTextureLinkIcon(ee.emojiSCs[shortcode].func.icon, ee.emojiSCs[shortcode].func.location, ee.emojiSCs[shortcode].func.size, ee.emojiSCs[shortcode].func.colour))
			end
		end
	end
	return message
end

local function editStandard(message)
	local uCode = ""
	local textureLink = ""
	local itString = tostring(message)
	local bytes = {}
	local eFound = {}
	local eFoundZWJ = {}
	local it = 1
	local mergeNext = false
		
	while (it <= #itString) -- Use While loop instead of for loop for dynamic increment
	do
		bytes = {}
		local iChar = tonumber(string.byte(string.sub(itString,it,it)))
		nBytes = CheckByte(iChar)
		
		for j = 0, nBytes - 1 do
			bytes[#bytes+1] = tonumber(string.byte(string.sub(itString,it+j,it+j)))
		end
		uCode = Bytes2Unicode(bytes)
		
		-- If uCode is present in emojiMap table, then it is an emoji
		if ee.emojiMap[uCode] or ee.emojiModifiers[uCode] or ee.emojiZWJs[uCode] or ee.emojiRILs[uCode] then
			local bytesStr = ""
			for i = 1, #bytes do
				bytesStr = bytesStr .. string.char(bytes[i])
			end
			
			if (ee.emojiModifiers[uCode] or (mergeNext and ee.emojiRILs[uCode])) and #eFound >= 1 then
				-- combine modifiers
				eFound[#eFound] = {eCode = eFound[#eFound].eCode .. "-" .. uCode, eBytes = eFound[#eFound].eBytes .. bytesStr}
			else
				eFound[#eFound + 1] = {eCode = uCode, eBytes = bytesStr}
			end
			if ee.emojiRILs[uCode] then
				mergeNext = not mergeNext
			end
		end
		
		-- Dynamic loop increment to skip bytes already accounted for
		if nBytes == 0 then
			it = it + 1
		else
			it = it + nBytes
		end
	end
	-- combine ZWJs
	mergeNext = false
	for i = 1, #eFound do
		if ee.emojiZWJs[eFound[i].eCode] or mergeNext then -- TODO: should apply to 200B, 200C and FEFF as well
			if mergeNext then
				mergeNext = false
			else
				mergeNext = true
			end
			eFoundZWJ[#eFoundZWJ].eCode = eFoundZWJ[#eFoundZWJ].eCode .. "-" .. eFound[i].eCode
			eFoundZWJ[#eFoundZWJ].eBytes = eFoundZWJ[#eFoundZWJ].eBytes .. eFound[i].eBytes
		else
			eFoundZWJ[#eFoundZWJ+1] = {eCode = eFound[i].eCode, eBytes = eFound[i].eBytes}
		end
	end
	-- If final list contains emoji, edit raw message to have icons
	if #eFoundZWJ >= 1 then
		for i = 1, #eFoundZWJ do
			local noFE0F,_ = eFoundZWJ[i].eCode:gsub("[%-][F][E][0][F]", "") -- Remove FE0Fs from final eCode (eBytes don't matter)
			if ee.emojiMap[noFE0F] then -- If, for whatever reason, the final combo doesn't have an icon, skip it
				textureLink = "|t" .. tostring(vars.emojiSettings.Size) .. ":" .. tostring(vars.emojiSettings.Size) .. ":" .. vars.emojiSettings.Path .. ee.emojiMap[noFE0F].texture .. "|t"
				message,_ = message:gsub(eFoundZWJ[i].eBytes, textureLink)
			end
		end
	end
	
	return message
end

function ee:Edit(rawMessage)
	local editedMessage = rawMessage
	
	
	---- Shortcode emoji test (has to run before the other emoji stuff)
	local settings = BitOr(BitLShift(Bool2Num(vars.emojiSettings.CustomEnabled),1), Bool2Num(vars.emojiSettings.SCEnabled))
	editedMessage = editSC(editedMessage, settings)
	---- test end
	
	editedMessage = editStandard(editedMessage)
	
	return editedMessage
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ee:UndoEdit(message)			-- This does not yet work for custom emoji, only for standard
	local unEditedMessage = message
	local path = vars.emojiSettings.Path
	local emoji = ""
	local n = 1
	path,_ = path:gsub("%/", "%%%/")
	path,_ = path:gsub("%-", "%%%-")
	
	repeat
		unEditedMessage,n = unEditedMessage:gsub(path, "", 1)
	until n <= 0
		
	for emoji in string.gmatch(unEditedMessage, "%|t%d%d%:%d%d%:([%u%1%d%-]+)[%.][d][d][s]%|t") do
		local result = ""
		for uCode in string.gmatch(emoji, "([%u%1%d]+)") do
			--Encode
			result = result .. Unicode2Bytes(uCode)
		end
		local value,_ = emoji:gsub("%-", "%%%-")
		unEditedMessage,_ = unEditedMessage:gsub("%|t%d%d%:%d%d%:" .. value .. "[%.][d][d][s]%|t", result)
	end
	return unEditedMessage
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	HIJACKER FUNCTIONS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Hijack_MessageFormatter()
	local original = CHAT_ROUTER.FormatAndAddChatMessage
	CHAT_ROUTER.FormatAndAddChatMessage = function(self, eventCode, channelType, fromName, messageText, isCustomerService, fromDisplayName)
		if type(messageText) == "string" then
			editedMessage = ee:Edit(messageText)
		else
			editedMessage = messageText
		end
		return original(self, eventCode, channelType, fromName, editedMessage, isCustomerService, fromDisplayName)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Hijack_GetText()
	local original = KEYBOARD_CHAT_SYSTEM.textEntry.editControl.GetText
	KEYBOARD_CHAT_SYSTEM.textEntry.editControl.GetText = function(self, ...)
		return ee:UndoEdit(original(self, ...))
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Hijack_OnTextChanged()
	local originalControl = KEYBOARD_CHAT_SYSTEM:GetEditControl()
	local originalHandler = originalControl:GetHandler("OnTextChanged")
	
	originalControl:SetHandler("OnTextChanged", function(...)
		local editedMessage = ee:Edit(originalControl:GetText())
		ee.textBox:SetText(editedMessage)		-- Edit preview
		originalControl:SetText(editedMessage)	-- Edit text entry in realtime
		
		local count = 350						-- For every emoji texture link found, increase maximum text entry char number (since the texture links are massive, but the emoji sent only uses a few characters)
		for emoji in string.gmatch(editedMessage, "%|[tT]%d-:%d-:.-|[tT]") do
			count = count + 55
		end
		if count >= 1500 then
			count = 1500
		end
		originalControl:SetMaxInputChars(count)
		originalHandler(...)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	EVENT REGISTRATIONS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(ee.name, EVENT_ADD_ON_LOADED, ee.OnAddOnLoaded)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	//////////////////////////////////////////////////////////////////////////////////////////	  SLASH COMMANDS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SLASH_COMMANDS["/ee_version"] = ee.DisplayVersion
SLASH_COMMANDS["/ee_test"] = ee.test
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	////////////////////////////////////////////////////////////////////////////////////////// INITIALIZE FUNCTIONS	//////////////////////////////////////////////////////////////////////////////////////////	--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Init_MainChat()
	Hijack_MessageFormatter()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Init_TextInput()
	Hijack_OnTextChanged()
	Hijack_GetText()
end


local function setupAnchors()
	local originalControl = KEYBOARD_CHAT_SYSTEM:GetEditControl()
	local originalParent = originalControl:GetParent():GetParent()

	ee.container:ClearAnchors()
	ee.container:SetAnchor(TOPLEFT, originalParent, TOPLEFT, 0, -27.5)
	ee.container:SetAnchor(BOTTOMRIGHT, originalParent, BOTTOMRIGHT, 0, -27.5)
	ee.container:SetParent(originalParent)

	--[[
	local chatBuffer = ZO_KeyboardChatWindowTemplate1Buffer
	local _,_,parentframe = chatBuffer:GetAnchor()
	chatBuffer:SetAnchor(BOTTOMRIGHT,parentframe,BOTTOMRIGHT,0,-27.5,0)
	]]


  for j=1, #ZO_ChatWindow.container.windows do
  	local chatBuffer = ZO_ChatWindow.container.windows[j]
    local _,_,parentframe = chatBuffer:GetAnchor()
		chatBuffer:SetAnchor(BOTTOMRIGHT,parentframe,BOTTOMRIGHT,0,-27.5,0)
  end


	local scrollbar = ZO_ChatWindowScrollbar
	local _,a,parentframe,b,x,y,z = scrollbar:GetAnchor(1)
	scrollbar:SetAnchor(BOTTOMRIGHT,parentframe,BOTTOMRIGHT,x,y-27.5,z)

	ee.textBox:SetMaxInputChars(1000)
	ee.textBox:SetAllowMarkupType(ALLOW_MARKUP_TYPE_ALL) -- Format links and stuff!!
	ee.textBox:SetFont("$(CHAT_FONT)|$(KB_" .. GetChatFontSize() .. ")|shadow") -- Base font

	EVENT_MANAGER:UnregisterForEvent(ee.name, EVENT_PLAYER_ACTIVATED)
end

EVENT_MANAGER:RegisterForEvent(ee.name, EVENT_PLAYER_ACTIVATED, setupAnchors)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ee:Initialize()
	EVENT_MANAGER:UnregisterForEvent(ee.name, EVENT_ADD_ON_LOADED)
	vars = ZO_SavedVars:NewAccountWide("EEVars", 1, nil, DefaultSettings)
	
	Init_MainChat()
	
	local originalControl = KEYBOARD_CHAT_SYSTEM:GetEditControl()

	ee.textBox = displayTextEntryBox
	ee.label = displayTextEntryLabel
	ee.container = displayTextEntry

	local o_SetFont = originalControl.SetFont
	originalControl.SetFont = function(self, ...)
		ee.textBox:SetFont(...)
		ee.label:SetFont(...)
		o_SetFont(self, ...)
	end
	
	local o_SetColour = originalControl.SetColor
	originalControl.SetColor = function(self, ...)
		ee.textBox:SetColor(...)
		ee.label:SetColor(...)
		o_SetColour(self, ...)
	end
	
	local o_SetHeight = originalControl.SetHeight
	originalControl.SetHeight = function(self, ...)
		ee.textBox:SetHeight(...)
		ee.label:SetHeight(...)
		o_SetHeight(self, ...)
	end

	--[[
	local o_SetWidth = originalControl.SetWidth
	originalControl.SetWidth = function(self, ...)
		ee.textBox:SetWidth(...)
		o_SetWidth(self, ...)
	end
	
	local o_SetDimensions = originalControl.SetDimensions
	originalControl.SetDimensions = function(self, ...)
		ee.textBox:SetDimensions(...)
		o_SetDimensions(self, ...)
	end
	--
	local o_SetCursorPos = originalControl.SetCursorPosition
	originalControl.SetCursorPosition = function(self, ...)
		ee.textBox:SetCursorPosition(...)
		o_SetCursorPos(self, ...)
	end
	--]]
	if ee.GetVars().realtimeEdit then
		Init_TextInput()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------