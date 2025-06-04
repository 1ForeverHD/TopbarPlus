return function(icon, Icon)

	local notice = Instance.new("Frame")
	notice.Name = "Notice"
	notice.ZIndex = 25
	notice.AutomaticSize = Enum.AutomaticSize.X
	notice.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notice.BorderSizePixel = 0
	notice.BackgroundTransparency = 0.1
	notice.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notice.Visible = false
	notice.Parent = icon.widget

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = notice

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Parent = notice

	local noticeLabel = Instance.new("TextLabel")
	noticeLabel.Name = "NoticeLabel"
	noticeLabel.ZIndex = 26
	noticeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	noticeLabel.AutomaticSize = Enum.AutomaticSize.X
	noticeLabel.Size = UDim2.new(1, 0, 1, 0)
	noticeLabel.BackgroundTransparency = 1
	noticeLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
	noticeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	noticeLabel.FontSize = Enum.FontSize.Size14
	noticeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	noticeLabel.Text = "1"
	noticeLabel.TextWrapped = true
	noticeLabel.TextWrap = true
	noticeLabel.Font = Enum.Font.Arial
	noticeLabel.Parent = notice
	
	local iconModule = script.Parent.Parent
	local packages = iconModule.Packages
	local Janitor = require(packages.Janitor)
	local Signal = require(packages.GoodSignal)
	local Utility = require(iconModule.Utility)
	icon.noticeChanged:Connect(function(totalNotices)

		-- Notice amount
		if not totalNotices then
			return
		end
		local exceeded99 = totalNotices > 99
		local noticeDisplay = (exceeded99 and "99+") or totalNotices
		noticeLabel.Text = noticeDisplay
		if exceeded99 then
			noticeLabel.TextSize = 11
		end

		-- Should enable
		local enabled = true
		if totalNotices < 1 then
			enabled = false
		end
		local parentIcon = Icon.getIconByUID(icon.parentIconUID)
		local dropdownOrMenuActive = #icon.dropdownIcons > 0 or #icon.menuIcons > 0
		if icon.isSelected and dropdownOrMenuActive then
			enabled = false
		elseif parentIcon and not parentIcon.isSelected then
			enabled = false
		end
		Utility.setVisible(notice, enabled, "NoticeHandler")

	end)
	icon.noticeStarted:Connect(function(customClearSignal, noticeId)
	
		if not customClearSignal then
			customClearSignal = icon.deselected
		end
		local parentIcon = Icon.getIconByUID(icon.parentIconUID)
		if parentIcon then
			parentIcon:notify(customClearSignal)
		end
		
		local noticeJanitor = icon.janitor:add(Janitor.new())
		local noticeComplete = noticeJanitor:add(Signal.new())
		noticeJanitor:add(icon.endNotices:Connect(function()
			noticeComplete:Fire()
		end))
		noticeJanitor:add(customClearSignal:Connect(function()
			noticeComplete:Fire()
		end))
		noticeId = noticeId or Utility.generateUID()
		icon.notices[noticeId] = {
			completeSignal = noticeComplete,
			clearNoticeEvent = customClearSignal,
		}
		local noticeLabel = icon:getInstance("NoticeLabel")
		local function updateNotice()
			icon.noticeChanged:Fire(icon.totalNotices)
		end
		icon.notified:Fire(noticeId)
		icon.totalNotices += 1
		updateNotice()
		noticeComplete:Once(function()
			noticeJanitor:destroy()
			icon.totalNotices -= 1
			icon.notices[noticeId] = nil
			updateNotice()
		end)
	end)
	
	-- Establish the notice
	notice:SetAttribute("ClipToJoinedParent", true)
	icon:clipOutside(notice)
	
	return notice
end