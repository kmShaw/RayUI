local R, C, L, DB = unpack(select(2, ...))

local chatbubblehook = CreateFrame("Frame", nil, UIParent)
local noscalemult = 1
local tslu = 0
local numkids = 0
local bubbles = {}

local function skinbubble(frame)
	for i=1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
		end
	end
	
	frame:SetBackdrop({
		bgFile = C["media"].blank,
		edgeFile = C["media"].glow,
		tile = false, tileSize = 0, edgeSize = 5,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	frame:SetClampedToScreen(false)
	frame:SetBackdropBorderColor(unpack(C["media"].bordercolor))
	frame:SetBackdropColor(.1, .1, .1, .6)
	
	tinsert(bubbles, frame)
end

local function ischatbubble(frame)
	if frame:GetName() then return end
	if not frame:GetRegions() then return end
	return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
end

chatbubblehook:SetScript("OnUpdate", function(chatbubblehook, elapsed)
	tslu = tslu + elapsed

	if tslu > .05 then
		tslu = 0

		local newnumkids = WorldFrame:GetNumChildren()
		if newnumkids ~= numkids then
			for i=numkids + 1, newnumkids do
				local frame = select(i, WorldFrame:GetChildren())

				if ischatbubble(frame) then
					skinbubble(frame)
				end
			end
			numkids = newnumkids
		end
		
		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()
			frame:SetBackdropBorderColor(r, g, b, .8)	
		end
	end
end)