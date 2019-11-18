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

local function isBound(button)
    local link = button:GetItemLink()
    if link then
        local _, _, _, _, _, _, _, _, equipLocation, _, _, _, _, bindType = GetItemInfo(link)
        if equipLocation ~= "" and bindType == 2 then
            local location = ItemLocation:CreateFromBagAndSlot(button.bag, button.slot)
            if location then
                if not C_Item.IsBound(location) then
                    return true
                end
            end
        end
    end

    return false
end

function mod:UpdateButton(event, button)
    local texture = button.BOEOverlayTexture
    
    if enabled then
        local bound, rarity = isBound(button)

        if bound then
            if not texture then
                texture = button:CreateTexture(nil, "OVERLAY")
                texture:SetPoint("BOTTOMLEFT", button, 1, 1)
                texture:SetTexture("Interface\\AddOns\\AdiBags-BOEOverlay\\Textures\\Coin")
                texture:SetVertexColor(1, 1, 0)
                texture:SetWidth(18)
                texture:SetHeight(18)
                texture:Show()
                texture:SetAlpha(1)
                button.BOEOverlayTexture = texture
            end

            texture:SetAlpha(1)
            return
        end
    end

    if texture then
        texture:SetAlpha(0)
    end
end

