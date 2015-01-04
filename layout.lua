local _NAME, _NS = ...
local Butsu = _G[_NAME]

do
	local title = Butsu:CreateFontString(nil, "OVERLAY")
	title:SetPoint("BOTTOMLEFT", Butsu, "TOPLEFT", 0, 2)
	Butsu.title = title
end

Butsu:SetScript("OnMouseDown", function(self)
	if(IsAltKeyDown()) then
		self:StartMoving()
	end
end)

Butsu:SetScript("OnMouseUp", function(self)
	self:StopMovingOrSizing()
	self:SavePosition()
end)

Butsu:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)

local createBackdrop = function(parent, anchor) 
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetFrameStrata("LOW")
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -4, 4)
    frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 4, -4)
    frame:SetBackdrop({
    edgeFile = [=[Interface\AddOns\Media\glowTex]=], edgeSize = 3,
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {left = 3, right = 3, top = 3, bottom = 3}})
    frame:SetBackdropColor(.05, .05, .05, .8)
    frame:SetBackdropBorderColor(0, 0, 0)
    return frame
end

Butsu:SetMovable(true)
Butsu:RegisterForClicks"anyup"

Butsu:SetParent(UIParent)

Butsu.Backdrop = createBackdrop(Butsu, Butsu)

Butsu:SetClampedToScreen(true)
Butsu:SetClampRectInsets(0, 0, 14, 0)
Butsu:SetHitRectInsets(0, 0, -14, 0)
Butsu:SetFrameStrata"HIGH"
Butsu:SetToplevel(true)
