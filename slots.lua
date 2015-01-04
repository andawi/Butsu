local _NAME, _NS = ...
local Butsu = _G[_NAME]

local slots = {}
_NS.slots = slots

local backdrop_1px = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"

		LootFrame.selectedLootButton = self
		LootFrame.selectedSlot = self:GetID()
		LootFrame.selectedQuality = self.quality
		LootFrame.selectedItemName = self.name:GetText()

		LootSlot(self:GetID())
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local Font = ("Interface\\AddOns\\Media\\pixel.ttf")
function _NS.CreateSlot(id)
	local db = _NS.db
	local iconSize = db.iconSize
	local fontSizeItem = 8
	local fontSizeCount = 8
	local fontItem = Font
	local fontCount = Font

	local frame = CreateFrame("Button", 'ButsuSlot'..id, Butsu)
	frame:SetHeight(math.max(fontSizeItem, iconSize))
	frame:SetID(id)
	
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)
	
	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetSize(iconSize, iconSize)
	iconFrame:SetPoint("RIGHT", frame)
	iconFrame:SetBackdrop(backdrop_1px)
	frame.iconFrame = iconFrame

	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(.8)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetAllPoints(iconFrame)
	frame.icon = icon
	
	local quest = iconFrame:CreateTexture(nil, 'OVERLAY')
	quest:SetTexture([[Interface\Minimap\ObjectIcons]])
	quest:SetTexCoord(1/8, 2/8, 1/8, 2/8)
	quest:SetSize(iconSize * .8, iconSize * .8)
	quest:SetPoint('BOTTOMLEFT', -iconSize * .15, 0)
	frame.quest = quest

	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, 2, 0)
	count:SetFont(fontCount, fontSizeCount, 'Outlinemonochrome')
	count:SetShadowColor(0, 0, 0, 1)
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH"LEFT"
	name:SetPoint("LEFT", frame)
	name:SetPoint("RIGHT", iconFrame, "LEFT")
	name:SetNonSpaceWrap(true)
	name:SetFont(fontItem, fontSizeItem, 'Outlinemonochrome')
	name:SetShadowColor(0, 0, 0, 1)
	frame.name = name

	slots[id] = frame
	return frame
end

function Butsu:UpdateWidth()
	local maxWidth = 0
	for _, slot in next, _NS.slots do
		if(slot:IsShown()) then
			local width = slot.name:GetStringWidth()
			if(width > maxWidth) then
				maxWidth = width
			end
		end
	end

	self:SetWidth(math.max(maxWidth + 30 + _NS.db.iconSize, self.title:GetStringWidth() + 5))
end

function Butsu:AnchorSlots()
	local frameSize = math.max(_NS.db.iconSize+4, _NS.db.fontSizeItem)
	local iconSize = _NS.db.iconSize
	local shownSlots = 0

	local prevShown
	for i=1, #slots do
		local frame = slots[i]
		if(frame:IsShown()) then
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", 2, 0)
			frame:SetPoint("RIGHT", -2, 0)
			if(not prevShown) then
				frame:SetPoint('TOPLEFT', self, 2, -1)
			else
				frame:SetPoint('TOP', prevShown, 'BOTTOM')
			end

			frame:SetHeight(frameSize)
			shownSlots = shownSlots + 1
			prevShown = frame
		end
	end

	local offset = self:GetTop() or 0
	self:SetHeight(math.max((shownSlots * frameSize + 2), 20))

	-- Reposition the frame so it doesn't move.
	local point, parent, relPoint, x, y = self:GetPoint()
	offset = offset - (self:GetTop() or 0)
	self:SetPoint(point, parent, relPoint, x, y + offset)
end
