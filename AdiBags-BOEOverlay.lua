local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

local mod = addon:NewModule("BOE", 'ABEvent-1.0')
mod.uiName = L['BOE overlay']
mod.uiDesc = L['Adds a BOE overlay to BOE items']

local enabled = false

function mod:OnInitialize()
end

function mod:OnEnable()
    enabled = true
	self:RegisterMessage('AdiBags_UpdateButton', 'UpdateButton')
	self:SendMessage('AdiBags_UpdateAllButtons')
end

function mod:OnDisable()
    enabled = false
	self:SendMessage('AdiBags_UpdateAllButtons')
end

function mod:GetOptions()
end

local function test()
	local text = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	text:SetPoint("TOPLEFT", button, 3, -1)
	text:Hide()
	texts[button] = text
    return GetItemQualityColor(0)
end

local function isBound(button)
    local link = button:GetItemLink()
    if link then
        local _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = GetItemInfo(link)
        if bindType == 2 then
            if not C_Item.IsBound(ItemLocation:CreateFromBagAndSlot(button.bag, button.slot)) then
                return true
            end
        end
    end

    return false
end

function mod:UpdateButton(event, button)
    local text = button.BOEOverlayText
    
    if enabled then
        local bound, rarity = isBound(button)

        if bound then
            if not text then
                text = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
                text:SetPoint("BOTTOMLEFT", button, 3, 1)
                text:SetText("BOE")
                text:SetTextColor(1, 1, 0)
                text:SetAlpha(1)
                text:Show()
                button.BOEOverlayText = text
            end

            text:SetAlpha(1)
            return
        end
    end

    if text then
        text:SetAlpha(0)
    end
end

