local ee = ESOEmoji


ee.SCAutocomplete = ZO_AutoComplete:Subclass()
local sca = ee.SCAutocomplete
local shortcodes = {}
local shortcodeBytes = {}





-- This file utilizes alot of code from the esoui. Below are some of the major files used:
-- https://github.com/esoui/esoui/blob/master/esoui/libraries/utility/zo_autocomplete.lua
-- https://github.com/esoui/esoui/blob/master/esoui/ingame/slashcommands/slashcommandautocomplete.lua





function ee.initauto()
    local vars = ee:GetVars()
	for i,v in pairs(ee.emojiSCs) do
		--ee.Unicode2Bytes
		if v.unicode and ee.emojiMap[v.unicode] then -- skip various unicode icons such as copyright which dont have a texture
            local size = vars.emojiSettings.Size
            local path = vars.emojiSettings.Path
            local emotePath = ee.emojiMap[v.unicode].texture
            textureLink = "|t" .. tostring(size) .. ":" .. tostring(size) .. ":" .. path .. emotePath .. "|t"
            local text = textureLink.." - :"..i..":"
            shortcodes[i] = text
            shortcodeBytes[text] = ee.Unicode2Bytes(v.unicode)
		end
	end
end


function sca:New(...)
    return ZO_AutoComplete.New(self, ...)
end

function sca:Initialize(editControl, ...)
    ZO_AutoComplete.Initialize(self, editControl, ...)

    self.possibleMatches = {}

    self:SetUseCallbacks(true)
    self:SetAnchorStyle(AUTO_COMPLETION_ANCHOR_BOTTOM)
    self:SetOwner(ee.emojiSCs)
    self:SetKeepFocusOnCommit(true)

    local function OnAutoCompleteEntrySelected(selected, selectionMethod) -- EDIT THIS
        editControl:SetText(shortcodeBytes[selected])
    end

    self:RegisterCallback(ZO_AutoComplete.ON_ENTRY_SELECTED, OnAutoCompleteEntrySelected)


    ZO_PreHook("ZO_ChatTextEntry_PreviousCommand", function(...)
        if not IsShiftKeyDown() and self:IsOpen() then
            local index = self:GetAutoCompleteIndex()
            if not index or index > 1 then
                self:ChangeAutoCompleteIndex(-1)
                return true
            end
        end
    end)

    ZO_PreHook("ZO_ChatTextEntry_NextCommand", function(...)
        if not IsShiftKeyDown() and self:IsOpen() then
            local index = self:GetAutoCompleteIndex()
            if not index or index < self:GetNumAutoCompleteEntries() then
                self:ChangeAutoCompleteIndex(1)
                return true --Handled
            end
        end
    end)
--[[
    local function OnEmoteSlashCommandsUpdated()
        self:InvalidateSlashCommandCache()
    end
    PLAYER_EMOTE_MANAGER:RegisterCallback("EmoteSlashCommandsUpdated", OnEmoteSlashCommandsUpdated)
--]]
end

function sca:InvalidateSlashCommandCache()
    self.possibleMatches = {}
end





function sca:ApplyAutoCompletionResults(...)
    if ... and ... ~= "" then
        ClearMenu()
        SetMenuMinimumWidth(self.editControl:GetWidth() - GetMenuPadding() * 2)

        local numResults = select("#", ...)
        for i=1, numResults do
            local name = select(i, ...)
            AddMenuItem(shortcodes[name], function()
                self.editControl:SetText(shortcodeBytes[shortcodes[name]]) 
            end)
        end
        
        ShowMenu(self.owner, nil, MENU_TYPE_TEXT_ENTRY_DROP_DOWN)

        if self.anchorStyle == AUTO_COMPLETION_ANCHOR_BOTTOM then
            ZO_Menu:ClearAnchors()
            ZO_Menu:SetAnchor(BOTTOMLEFT, self.editControl, TOPLEFT, -8, -2)
            ZO_Menu:SetAnchor(BOTTOMRIGHT, self.editControl, TOPRIGHT, 8, -2)
        else
            ZO_Menu:ClearAnchors()
            ZO_Menu:SetAnchor(TOPLEFT, self.editControl, BOTTOMLEFT, -8, 2)
            ZO_Menu:SetAnchor(TOPRIGHT, self.editControl, BOTTOMRIGHT, 8, 2)
        end
        
        return true
    end
    
    return false
end



--[[
function ZO_AutoComplete:OnCommit(commitBehavior, commitMethod)
    if self:IsOpen() then
        local selectedIndex = ZO_Menu_GetSelectedIndex()
        if selectedIndex then
            local name = ZO_Menu_GetSelectedText()
            if self.useCallbacks then
                self:FireCallbacks(self.ON_ENTRY_SELECTED, name, commitMethod)
            else
                self.editControl:SetText(name) 
            end
        end
        if not commitBehavior or commitBehavior == COMMIT_BEHAVIOR_LOSE_FOCUS then
            self.editControl:LoseFocus()
        end

        self:Hide()

        if selectedIndex then
            return self.dontCallHookedHandlers
        else
            return false
        end
    end
end
]]


function sca:SetEditControl(editControl)
    if editControl then
        if self.automaticMode then
            ZO_PreHookHandler(editControl, "OnTextChanged", function() self:OnTextChanged() end)
        end

        --[[
        ZO_PreHookHandler(editControl, "OnEnter", function()
            if self:IsOpen() then
                if not self.keepFocusOnCommit and self.automaticMode then
                    return self:OnCommit(COMMIT_BEHAVIOR_LOSE_FOCUS, AUTO_COMPLETION_SELECTED_BY_ENTER)
                else
                    return self:OnCommit(COMMIT_BEHAVIOR_KEEP_FOCUS, AUTO_COMPLETION_SELECTED_BY_ENTER)
                end
            end
        end)
        --]]

        ZO_PreHookHandler(editControl, "OnTab", function()
            if self:IsOpen() then
                if not ZO_Menu_GetSelectedIndex() then
                    self:ChangeAutoCompleteIndex(1)
                end
                return self:OnCommit(COMMIT_BEHAVIOR_KEEP_FOCUS, AUTO_COMPLETION_SELECTED_BY_TAB)
            end
        end)

        if self.useArrows then
            ZO_PreHookHandler(editControl, "OnDownArrow", function() self:ChangeAutoCompleteIndex(1) end)
            ZO_PreHookHandler(editControl, "OnUpArrow", function() self:ChangeAutoCompleteIndex(-1) end)
        end
    
        ZO_PreHookHandler(editControl, "OnFocusLost", function() self:Hide() end)
        ZO_PreHookHandler(editControl, "OnHide", function() self:Hide() end)
    end
    
    self.editControl = editControl
end


function sca:GetAutoCompletionResults(text)
    if #text < 3 then
        return
    end
    local startChar = text:sub(1, 1)
    if startChar ~= ":" then
        return
    end
    if text:find(" ", 1, true) then
        return
    end

    if next(self.possibleMatches) == nil then
        for i,v in pairs(shortcodes) do
            self.possibleMatches[i] = i
        end
    end

    local results = GetTopMatchesByLevenshteinSubStringScore(self.possibleMatches, text, 2, self.maxResults)
    if results then
        return unpack(results)
    end
    return nil
end