-- When designing your game for many devices and screen sizes, icons may occasionally
-- particularly for smaller devices like phones, overlap with other icons or the bounds
-- of the screen. The overflow handler solves this challenge by moving the out-of-bounds
-- icon into an overflow menu (with a limited scrolling canvas) preventing overlaps occuring

--!!! TO DO STILL:
-- 1. Replace test loop with events that are listened for
-- 2. The boundaries (or the holder sizing) aren't 100% accurate. Double check values and make sure there is comfortable spacing
-- 3. Hang on Ben, maybe reconsider this appraoach entirely because 
-- 3. Update the description above as might not reflect new behaviour (frames not overflow icons)
-- 4. Ensure :clipOutside items acccount for this such as notices and captions



-- LOCAL
local SUBMISSIVE_ALIGNMENT = "Right" -- This boundary shrinks if the other alignments boundary gets too close 
local Overflow = {}
local holders = {}
local orderedAvailableIcons = {}
local boundaries = {}
local iconsDict
local currentCamera = workspace.CurrentCamera
local overflowIcons = {}
local overflowIconUIDs = {}
local Icon



-- FUNCTIONS
-- This is called upon the Icon initializing
function Overflow.start(incomingIcon)
	Icon = incomingIcon
	iconsDict = Icon.iconsDictionary
	for _, screenGui in pairs(Icon.container) do
		for _, holder in pairs(screenGui.Holders:GetChildren()) do
			if holder:GetAttribute("IsAHolder") then
				holders[holder.Name] = holder
			end
		end
	end

	-- !!! The completed overflow will not use a loop, it will listen
	-- for various icon events such as size changed, alignment changed, etc
	-- This is just something quick and easy to help me test
	while false do
		task.wait(0.5)
		Overflow.updateAvailableIcons("Center")
		Overflow.updateBoundary("Left")
	end
end

function Overflow.getAvailableIcons(alignment)
	local ourOrderedIcons = orderedAvailableIcons[alignment]
	if not ourOrderedIcons then
		ourOrderedIcons = Overflow.updateAvailableIcons(alignment)
	end
	return ourOrderedIcons
end

function Overflow.updateAvailableIcons(alignment)

	-- We only track items that are directly on the topbar (i.e. not within a parent icon)
	local ourTotal = 0
	local holder = holders[alignment]
	local holderUIList = holder.UIListLayout
	local ourOrderedIcons = {}
	for _, icon in pairs(iconsDict) do
		local parentUID = icon.parentIconUID
		local isDirectlyOnTopbar = not parentUID or overflowIconUIDs[parentUID]
		local isOverflow = false--overflowIconUIDs[icon.UID]
		if isDirectlyOnTopbar and icon.alignment == alignment and not isOverflow then
			table.insert(ourOrderedIcons, icon)
			ourTotal += 1
		end
	end

	-- Ignore if no icons are available
	if ourTotal <= 0 then
		return {}
	end

	-- This sorts these icons by smallest order, or if equal, left-most position
	-- (even for the right alignment because all icons are sorted left-to-right)
	table.sort(ourOrderedIcons, function(iconA, iconB)
		local orderA = iconA.widget.LayoutOrder
		local orderB = iconB.widget.LayoutOrder
		if orderA < orderB then
			return true
		end
		if orderA > orderB then
			return false
		end
		local joinA = iconA.joinOverflowTime
		local joinB = iconA.joinOverflowTime
		if joinA and joinB then
			if joinA ~= joinB then
				return joinA > joinB
			end
		elseif joinA then
			return true
		elseif joinB then
			return false
		end
		return iconA.widget.AbsolutePosition.X < iconB.widget.AbsolutePosition.X
	end)
	
	-- Finish up
	orderedAvailableIcons[alignment] = ourOrderedIcons
	return ourOrderedIcons

end

function Overflow.updateBoundary(alignment)
	
	-- These are the icons with menus which icons will be moved into
	-- when overflowing
	local isCentral = alignment == "Central"
	local isLeft = alignment == "Left"
	local isRight = not isLeft
	local overflowIcon = overflowIcons[alignment]
	if not overflowIcon and not isCentral then
		local order = (isLeft and -9999999) or 9999999
		overflowIcon = Icon.new():setLabel(`{alignment}`)
		overflowIcon:setName("Overflow"..alignment)
		overflowIcon:setOrder(order)
		overflowIcon:setAlignment(alignment)
		overflowIcon.isAnOverflow = true
		--overflowIcon:freezeMenu()
		overflowIcons[alignment] = overflowIcon
		overflowIconUIDs[overflowIcon.UID] = true
	end

	-- We only track items that are directly on the topbar (i.e. not within a parent icon)
	local holder = holders[alignment]
	local holderUIList = holder.UIListLayout
	local topbarInset = holderUIList.Padding.Offset
	local topbarPadding = holderUIList.Padding.Offset
	local BOUNDARY_GAP = topbarInset
	local ourOrderedIcons = Overflow.updateAvailableIcons(alignment)
	local boundWidth = 0
	local ourTotal = 0
	for _, icon in pairs(ourOrderedIcons) do
		boundWidth += icon.widget.AbsoluteSize.X + topbarPadding
		ourTotal += 1
	end
	if ourTotal <= 0 then
		return
	end
	
	-- Calculate the start bounds and total bound
	local lastIcon = (isLeft and ourOrderedIcons[1]) or ourOrderedIcons[ourTotal]
	local lastXPos = lastIcon.widget.AbsolutePosition.X
	local startBound = (isLeft and lastXPos) or lastXPos + lastIcon.widget.AbsoluteSize.X
	local boundary = (isLeft and startBound + boundWidth) or startBound - boundWidth
	--
	if isRight then
		print("boundary (1) =", boundary)
	elseif isLeft then
		print("BOUNDARY LEFT =", boundary, startBound, boundWidth)
	end
	--
	
	-- Now we get the left-most icon (if left alignment) or right-most-icon (if
	-- right alignment) of the central icons group to see if we need to change
	-- the boundary (if the central icon boundary is smaller than the alignment
	-- boundary then we use the central)
	local centerOrderedIcons = Overflow.getAvailableIcons("Center")
	local centerPos = (isLeft and 1) or #centerOrderedIcons
	local nearestCenterIcon = centerOrderedIcons[centerPos]
	if nearestCenterIcon then
		local nearestXPos = nearestCenterIcon.widget.AbsolutePosition.X
		local centerBoundary = (isLeft and nearestXPos) or nearestXPos + nearestCenterIcon.widget.AbsoluteSize.X + topbarInset
		if isLeft and centerBoundary - BOUNDARY_GAP < boundary then
			boundary = centerBoundary
		elseif isRight and centerBoundary + BOUNDARY_GAP > boundary then
			boundary = centerBoundary
		end
	end
	--
	if isRight then
		print("boundary (2) =", boundary)
	end

	-- If the boundary exceeds the sides of the screen minus the
	-- size of 3 default icons and 2 boundary gaps IF > 1 icons on
	-- opposite side of screen (because the overflow
	-- could be an open menu) we clamp it (forcing the dominant boundary
	-- to also shrink in addition to the submissive boundary)
	local hasExceededSide = false
	if not isCentral then
		local Themes = require(script.Parent.Themes)
		local stateGroup = overflowIcon:getStateGroup()
		local defaultIconWidth = Themes.getThemeValue(stateGroup, "Widget", "MinimumWidth") or 0
		local requiredSideGap = (defaultIconWidth*3) + (BOUNDARY_GAP*2)
		local viewportWidth = currentCamera.ViewportSize.X
		if isRight and boundary < requiredSideGap then
			-- FOR THIS, CONSIDER ICONS JOINING A SOLE SIDE OF THE SCREEN
			--boundary = requiredSideGap
			--hasExceededSide = true
		elseif isLeft and boundary > viewportWidth - requiredSideGap then
			boundary = viewportWidth - requiredSideGap
			hasExceededSide = true
		end
	end
	--
	if isRight then
		print("boundary (3) =", boundary, hasExceededSide)
	end
	
	-- If the dominant boundary exceeds the submissive boundary, its
	-- important we shrink the submissive one to account
	local isSubmissive = alignment == SUBMISSIVE_ALIGNMENT 
	local isDominant = not isSubmissive
	local oppositeAlignment = (alignment == "Left" and "Right") or "Left"
	local oppositeBoundary = boundaries[oppositeAlignment]
	if ((isSubmissive and not hasExceededSide) or (isDominant and hasExceededSide)) then
		if oppositeBoundary and not hasExceededSide then
			if isLeft and oppositeBoundary - topbarPadding < boundary then
				boundary = oppositeBoundary
			elseif isRight and oppositeBoundary + topbarPadding > boundary then
				boundary = oppositeBoundary
			end
		end
	end
	--
	if isRight then
		print("boundary (4) =", boundary)
	end

	-- Record the boundary so the opposite alignment can use it
	boundaries[alignment] = boundary

	-- Now update the size of the holder
	local viewportWidth = currentCamera.ViewportSize.X
	local holderXPos = holder.AbsolutePosition.X
	local holderXSize = holder.AbsoluteSize.X
	local holderWidth = (isLeft and boundary - holderXPos) or (viewportWidth - boundary)
	holderWidth -= BOUNDARY_GAP
	--holder.Size = UDim2.new(0, holderWidth, 1, 0)
	
	--Parent icons into the overflow if they exceed the bounds
	--
	if alignment == "Right" then
		print("ourOrderedIcons =", boundary, #ourOrderedIcons, ourOrderedIcons)
	end
	--
	
	-- We calculate the the absolute position of icons instead of reading
	-- directly to determine where they would be if not within an overflow
	local absoluteX = (isLeft and holderXPos) or holderXPos + holderXSize
	for i = #ourOrderedIcons, 1, -1 do
		local joinOverflow = false
		local icon = ourOrderedIcons[i]
		local sizeX = icon.widget.AbsoluteSize.X
		local holderIncrement = (isLeft and sizeX) or -sizeX
		local isOverflow = overflowIconUIDs[icon.UID]
		absoluteX += holderIncrement
		if isRight then
			--print("absoluteX =", boundary, icon.widget.Name, absoluteX, icon.widget.AbsolutePosition.X)
		end
		if (isLeft and absoluteX + sizeX >= boundary) or (isRight and absoluteX <= boundary) then
			joinOverflow = true
		end
		if not isOverflow then
			if joinOverflow and not icon.parentIconUID then
				icon.joinOverflowTime = os.clock()
				icon:joinMenu(overflowIcon)
			elseif not joinOverflow and icon.parentIconUID then
				icon.joinOverflowTime = nil
				icon:leave()
			end
		end
		absoluteX += (isLeft and topbarInset) or -topbarInset
	end
	
	-- If we're the dominant boundary it's important we recalculate the
	-- submissive boundary as they depend on our boundary information
	if isDominant then
		Overflow.updateBoundary(oppositeAlignment)
	end

end



return Overflow