--// AFNANSAKHA HUB LOADER + MAIN GUI (INTEGRATED ADVANCED STUDS ESP, AIMBOT & WALL CHECK)
--// Jalankan script ini langsung melalui Executor pilihan Anda.

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

----------------------------------------------------
-- AUTO CLEANUP PREVIOUS UI
----------------------------------------------------
local oldUI1 = PlayerGui:FindFirstChild("AfnanSakhaLoadingScreen")
if oldUI1 then oldUI1:Destroy() end

local oldUI2 = PlayerGui:FindFirstChild("AfnanSakhaHubUI")
if oldUI2 then oldUI2:Destroy() end

local oldRGB = PlayerGui:FindFirstChild("RGBEditor")
if oldRGB then oldRGB:Destroy() end

----------------------------------------------------
-- STATE CONFIGURATIONS & GLOBAL VARIABLES
----------------------------------------------------
local OutlineEnabled = false
local BoxesEnabled = false
local TracersEnabled = false
local NameESPEnabled = false
local HealthESPEnabled = false

local OutlineColor = Color3.fromRGB(0, 230, 255)
local BoxColor = Color3.fromRGB(0, 230, 255)
local TracerColor = Color3.fromRGB(0, 230, 255)
local NameColor = Color3.fromRGB(255, 255, 255)
local StrokeColor = Color3.fromRGB(0, 0, 0)

local OutlineUseTeam = true
local BoxUseTeam = true
local TracerUseTeam = true
local NameUseTeam = true

local OutlineIsRainbow = false
local BoxIsRainbow = false
local TracerIsRainbow = false
local NameIsRainbow = false

-- STUDS SIZING CONFIG (SIDE HEALTH)
local BAR_WIDTH = 0.25        
local OFFSET = 0.35           

local TeamColors = {
    Color3.fromRGB(0, 120, 255),   
    Color3.fromRGB(255, 40, 40),   
    Color3.fromRGB(40, 255, 40),   
    Color3.fromRGB(255, 230, 0),   
    Color3.fromRGB(180, 40, 255),  
    Color3.fromRGB(255, 255, 255), 
    Color3.fromRGB(25, 25, 25),    
}

-- AIMBOT & WALL CHECK CONFIG
local circleEnabled = false
local shootLockEnabled = false
local dontLockTeammate = false
local wallCheckEnabled = false

local circleRadius = 100
local targetBodyPart = "Head"
local AimbotIsRainbow = false
local AimbotIsInvisibleColor = false

local shootLockActiveUntil = 0
local currentShootLockTarget = nil
local activeTouches = {}

local aimbotColorPresets = {
	["Cyan Neon"] = Color3.fromRGB(0, 230, 255),
	["Red"] = Color3.fromRGB(255, 50, 50),
	["Green"] = Color3.fromRGB(50, 255, 50),
	["Yellow"] = Color3.fromRGB(255, 255, 50),
	["Invisible"] = Color3.fromRGB(100, 30, 30) -- Warna redup penanda terhalang
}

----------------------------------------------------
-- HELPER UTILITIES
----------------------------------------------------
local function getPlayerTeamColor(player)
    if player.Team then
        local currentTeams = Teams:GetTeams()
        table.sort(currentTeams, function(a, b) return a.Name < b.Name end)
        local idx = table.find(currentTeams, player.Team)
        if idx then
            return TeamColors[((idx - 1) % #TeamColors) + 1]
        end
    end
    return Color3.fromRGB(170, 170, 170)
end

local function GetActiveColor(player, feature)
    local rainbowColor = Color3.fromHSV((os.clock() * 0.4) % 1, 1, 1)
    if feature == "Outline" then
        return OutlineIsRainbow and rainbowColor or (OutlineUseTeam and getPlayerTeamColor(player) or OutlineColor)
    elseif feature == "Box" then
        return BoxIsRainbow and rainbowColor or (BoxUseTeam and getPlayerTeamColor(player) or BoxColor)
    elseif feature == "Tracer" then
        return TracerIsRainbow and rainbowColor or (TracerUseTeam and getPlayerTeamColor(player) or TracerColor)
    elseif feature == "Name" then
        return NameIsRainbow and rainbowColor or (NameUseTeam and getPlayerTeamColor(player) or NameColor)
    end
    return Color3.fromRGB(255, 255, 255)
end

----------------------------------------------------
-- LOADING SCREEN
----------------------------------------------------
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "AfnanSakhaLoadingScreen"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(10,15,30)
Background.BorderSizePixel = 0
Background.Parent = LoadingGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,20,45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5,10,25))
}
UIGradient.Rotation = 45
UIGradient.Parent = Background

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0,500,0,150)
MainContainer.Position = UDim2.new(0.5,-250,0.5,-75)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = Background

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,0,0,30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Loading [AfnanSakha HUB]"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainContainer

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(1,0,0,40)
BarBackground.Position = UDim2.new(0,0,0,45)
BarBackground.BackgroundColor3 = Color3.fromRGB(20,30,50)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = MainContainer

Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(0.5,0)

local BarStroke = Instance.new("UIStroke")
BarStroke.Color = Color3.fromRGB(0,150,255)
BarStroke.Thickness = 1.5
BarStroke.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(0,180,255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0.5,0)

local FillGradient = Instance.new("UIGradient")
FillGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,100,220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,230,255))
}
FillGradient.Parent = BarFill

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1,0,0,30)
StatusLabel.Position = UDim2.new(0,0,0,95)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "0/100 assets loaded"
StatusLabel.TextColor3 = Color3.fromRGB(200,220,255)
StatusLabel.TextSize = 22
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainContainer

local totalAssets = 100
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

task.wait(0.5)
for i = 1, totalAssets do
    local progress = i / totalAssets
    TweenService:Create(BarFill, tweenInfo, {Size = UDim2.new(progress,0,1,0)}):Play()
    StatusLabel.Text = i .. "/" .. totalAssets .. " assets loaded"
    if i < 15 or i > 85 then task.wait(0.01) elseif i == 50 or i == 70 then task.wait(0.15) else task.wait(0.02) end
end
StatusLabel.Text = "Selesai!"
task.wait(0.2)

local fadeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(Background, fadeTweenInfo, {BackgroundTransparency = 1}):Play()
for _, child in ipairs(MainContainer:GetChildren()) do
    if child:IsA("TextLabel") then TweenService:Create(child, fadeTweenInfo, {TextTransparency = 1}):Play()
    elseif child:IsA("Frame") then TweenService:Create(child, fadeTweenInfo, {BackgroundTransparency = 1}):Play()
        local stroke = child:FindFirstChildOfClass("UIStroke")
        if stroke then TweenService:Create(stroke, fadeTweenInfo, {Transparency = 1}):Play() end
    end
end
task.wait(0.4)
LoadingGui:Destroy()

----------------------------------------------------
-- MAIN GUI BUILDER
----------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AfnanSakhaHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local TargetCircle = Instance.new("Frame")
TargetCircle.Name = "AfnanSakhaTargetCircle"
TargetCircle.AnchorPoint = Vector2.new(0.5, 0.5)
TargetCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
TargetCircle.BackgroundTransparency = 1
TargetCircle.Size = UDim2.new(0, circleRadius * 2, 0, circleRadius * 2)
TargetCircle.Visible = false
TargetCircle.Parent = ScreenGui

Instance.new("UICorner", TargetCircle).CornerRadius = UDim.new(1, 0)

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 230, 255)
CircleStroke.Thickness = 1.5
CircleStroke.Parent = TargetCircle

local function UpdateCircleVisual()
	TargetCircle.Size = UDim2.new(0, circleRadius * 2, 0, circleRadius * 2)
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0,550,0,400)
MainFrame.Position = UDim2.new(0.5,-275,0.5,-200)
MainFrame.BackgroundColor3 = Color3.fromRGB(12,22,37)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0,180,255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local ExecTitle = Instance.new("TextLabel")
ExecTitle.Size = UDim2.new(1,-50,0,40)
ExecTitle.Position = UDim2.new(0,15,0,5)
ExecTitle.BackgroundTransparency = 1
ExecTitle.Text = "AFNANSAKHA HUB"
ExecTitle.TextColor3 = Color3.fromRGB(0,230,255)
ExecTitle.TextSize = 22
ExecTitle.Font = Enum.Font.GothamBold
ExecTitle.TextXAlignment = Enum.TextXAlignment.Left
ExecTitle.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-40,0,8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(20,40,65)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(0,180,255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(0,130,200)
CloseStroke.Parent = CloseBtn

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1,-30,0,35)
TabContainer.Position = UDim2.new(0,15,0,50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local function CreateTab(name, posIdx)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0.31,0,1,0)
    Tab.Position = UDim2.new((posIdx - 1) * 0.34,0,0,0)
    Tab.BackgroundColor3 = posIdx == 1 and Color3.fromRGB(15,45,80) or Color3.fromRGB(15,30,50)
    Tab.Text = name
    Tab.TextColor3 = posIdx == 1 and Color3.fromRGB(0,230,255) or Color3.fromRGB(150,180,210)
    Tab.TextSize = 14
    Tab.Font = Enum.Font.GothamBold
    Tab.Parent = TabContainer
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0,6)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = posIdx == 1 and Color3.fromRGB(0,180,255) or Color3.fromRGB(0,90,150)
    Stroke.Parent = Tab
end
CreateTab("SCRIPTS",1)
CreateTab("SETTINGS",2)
CreateTab("HISTORY",3)

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1,-30,0,230)
ScrollList.Position = UDim2.new(0,15,0,95)
ScrollList.BackgroundTransparency = 1
ScrollList.CanvasSize = UDim2.new(0,0,0,720) -- Ditambah agar scroll muat pemicu baru
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(0,180,255)
ScrollList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ScrollList

local TracerFolder = Instance.new("Folder", ScreenGui)
TracerFolder.Name = "TracerFolder"
local TracerFrames = {}

----------------------------------------------------
-- SYSTEM LOGIC: OUTLINES CONTROL
----------------------------------------------------
local function UpdatePlayerOutlines()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local existing = player.Character:FindFirstChild("PlayerOutline")
            if OutlineEnabled then
                local calculatedColor = GetActiveColor(player, "Outline")
                if not existing then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerOutline"
                    highlight.FillTransparency = 1
                    highlight.OutlineTransparency = 0
                    highlight.OutlineColor = calculatedColor
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                else
                    existing.OutlineColor = calculatedColor
                end
            else
                if existing then existing:Destroy() end
            end
        end
    end
end

----------------------------------------------------
-- CORE COMPONENT SYSTEM: SEPARATED DECOUPLED ESP HOOKS
----------------------------------------------------
local function SetupCharacter(character)
    local player = Players:GetPlayerFromCharacter(character)
    local humanoid = character:WaitForChild("Humanoid", 3)
    local hrp = character:WaitForChild("HumanoidRootPart", 3)
    local head = character:WaitForChild("Head", 3)

    if not humanoid or not hrp or not player or not head then return end  

    -- 1. BOX ESP GENERATION
    local oldBox = hrp:FindFirstChild("PlayerBoxESP")  
    if oldBox then oldBox:Destroy() end  
    
    local boxBillboard = Instance.new("BillboardGui")  
    boxBillboard.Name = "PlayerBoxESP"  
    boxBillboard.Size = UDim2.new(4.5, 0, 6, 0)  
    boxBillboard.AlwaysOnTop = true  
    boxBillboard.LightInfluence = 0 
    boxBillboard.Enabled = BoxesEnabled  
    boxBillboard.Parent = hrp  
    
    local boxFrame = Instance.new("Frame")  
    boxFrame.Name = "BoxFrame"  
    boxFrame.Size = UDim2.new(1, 0, 1, 0)  
    boxFrame.BackgroundTransparency = 1  
    boxFrame.Parent = boxBillboard  

    local boxStroke = Instance.new("UIStroke")  
    boxStroke.Color = GetActiveColor(player, "Box")  
    boxStroke.Thickness = 2  
    boxStroke.Parent = boxFrame  

    -- 2. DYNAMIC NAMETAG SYSTEM
    local oldTag = character:FindFirstChild("DynamicNameTag")
    if oldTag then oldTag:Destroy() end

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "DynamicNameTag"
    nameBillboard.Adornee = head
    nameBillboard.AlwaysOnTop = true      
    nameBillboard.LightInfluence = 0     
    nameBillboard.Size = UDim2.fromOffset(220, 40)
    nameBillboard.StudsOffset = Vector3.new(0, 2.8, 0)
    nameBillboard.Enabled = NameESPEnabled
    nameBillboard.Parent = character

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.fromScale(1, 1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Text = player.DisplayName
    nameLabel.TextColor3 = GetActiveColor(player, "Name")
    nameLabel.Parent = nameBillboard

    local nameStroke = Instance.new("UIStroke")
    nameStroke.Color = StrokeColor
    nameStroke.Thickness = 2
    nameStroke.Parent = nameLabel

    -- 3. SIDE HEALTH BAR SYSTEM IN STUDS SCALE
    local oldSideHealth = character:FindFirstChild("SideHealthBar")
    if oldSideHealth then oldSideHealth:Destroy() end

    local size = character:GetExtentsSize()
    local healthBillboard = Instance.new("BillboardGui")
    healthBillboard.Name = "SideHealthBar"
    healthBillboard.Adornee = hrp
    healthBillboard.AlwaysOnTop = true
    healthBillboard.LightInfluence = 0
    healthBillboard.ResetOnSpawn = false
    healthBillboard.Size = UDim2.new(BAR_WIDTH, 0, size.Y, 0)
    healthBillboard.StudsOffset = Vector3.new(-(size.X / 2 + OFFSET), 0, 0)
    healthBillboard.Enabled = HealthESPEnabled
    healthBillboard.Parent = character

    local bgFrame = Instance.new("Frame")
    bgFrame.Name = "BGFrame"
    bgFrame.Size = UDim2.fromScale(1, 1)
    bgFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = healthBillboard

    Instance.new("UICorner", bgFrame).CornerRadius = UDim.new(1, 0)

    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(0, 0, 0)
    bgStroke.Thickness = 1
    bgStroke.Parent = bgFrame

    local fillBar = Instance.new("Frame")
    fillBar.Name = "FillBar"
    fillBar.AnchorPoint = Vector2.new(0, 1)
    fillBar.Position = UDim2.new(0, 0, 1, 0)
    fillBar.Size = UDim2.fromScale(1, 1)
    fillBar.BorderSizePixel = 0
    fillBar.Parent = bgFrame

    Instance.new("UICorner", fillBar).CornerRadius = UDim.new(1, 0)
end

local function SetupPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(character)
        task.wait(0.4)
        if OutlineEnabled then UpdatePlayerOutlines() end
        task.spawn(SetupCharacter, character)
    end)
    if player.Character then
        task.spawn(SetupCharacter, player.Character)
        if OutlineEnabled then UpdatePlayerOutlines() end
    end
end

task.spawn(function()
    for _, player in ipairs(Players:GetPlayers()) do SetupPlayer(player) end
end)

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(function(player)
    if TracerFrames[player] then TracerFrames[player]:Destroy() TracerFrames[player] = nil end
end)

----------------------------------------------------
-- SYSTEM LOGIC: CORE AIMBOT TARGET FINDER + WALL CHECK
----------------------------------------------------
local function IsPlayerVisible(targetPart, playerCharacter)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera, playerCharacter}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	local rayDirection = targetPart.Position - Camera.CFrame.Position
	local raycastResult = workspace:Raycast(Camera.CFrame.Position, rayDirection, raycastParams)

	-- Jika tidak ada benda/part yang menghalangi raycast, berarti target terlihat jelas
	return raycastResult == nil
end

local function GetClosestTarget(maxDistance)
	local closestTarget = nil
	local shortestDistance = maxDistance or math.huge
	local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if dontLockTeammate and player.Team == LocalPlayer.Team then
				continue
			end
			
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			local targetPart = player.Character:FindFirstChild(targetBodyPart) or player.Character:FindFirstChild("HumanoidRootPart")
			
			if humanoid and humanoid.Health > 0 and targetPart then
				local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

				if onScreen then
					-- Jika Wall Check aktif secara global, filter pemain yang bersembunyi di balik tembok
					if wallCheckEnabled and not IsPlayerVisible(targetPart, player.Character) then
						continue
					end

					local playerCoord = Vector2.new(screenPos.X, screenPos.Y)
					local distance = (playerCoord - screenCenter).Magnitude

					if distance < shortestDistance then
						shortestDistance = distance
						closestTarget = targetPart
					end
				end
			end
		end
	end
	return closestTarget
end

----------------------------------------------------
-- INPUT DETECTIONS (MOBILE & PC HANDLING)
----------------------------------------------------
local function TriggerShootLockTarget()
	local target = GetClosestTarget()
	if target then
		currentShootLockTarget = target
		shootLockActiveUntil = os.clock() + 0.5
	end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key ~= Enum.KeyCode.W and key ~= Enum.KeyCode.A and key ~= Enum.KeyCode.S and key ~= Enum.KeyCode.D and key ~= Enum.KeyCode.Space and key ~= Enum.KeyCode.Unknown then
			TriggerShootLockTarget()
		end
	elseif input.UserInputType == Enum.UserInputType.Touch then
		-- Menangkap data posisi awal sentuhan di mobile
		activeTouches[input] = {
			StartPosition = input.Position,
			StartTime = os.clock()
		}
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not shootLockEnabled then return end

	if input.UserInputType == Enum.UserInputType.Touch then
		local touchData = activeTouches[input]
		if touchData then
			local startPos = touchData.StartPosition
			local endPos = input.Position
			local duration = os.clock() - touchData.StartTime
			local distanceMoved = (Vector2.new(endPos.X, endPos.Y) - Vector2.new(startPos.X, startPos.Y)).Magnitude
			
			activeTouches[input] = nil 

			if duration < 0.25 and distanceMoved < 15 then
				local screenSize = Camera.ViewportSize
				local isJumpZone = (startPos.X > screenSize.X * 0.65 and startPos.Y > screenSize.Y * 0.55)
				local isMoveZone = (startPos.X < screenSize.X * 0.35 and startPos.Y > screenSize.Y * 0.5)

				if not (isJumpZone or isMoveZone) then
					TriggerShootLockTarget()
				end
			end
		end
	end
end)
----------------------------------------------------
-- COMPONENT: ADAPTIVE DROPDOWN ROW INTERFACE SYSTEM
----------------------------------------------------
local function CreateScriptRow(rowType, name, configData)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1,-10,0,45)
    Row.BackgroundColor3 = Color3.fromRGB(18,32,55)
    Row.ClipsDescendants = true
    Row.Parent = ScrollList

    Instance.new("UICorner", Row).CornerRadius = UDim.new(0,8)  

    local Stroke = Instance.new("UIStroke")  
    Stroke.Color = Color3.fromRGB(0,100,180)  
    Stroke.Parent = Row  

    local Label = Instance.new("TextLabel")  
    Label.Size = UDim2.new(0.6,0,0,45)  
    Label.Position = UDim2.new(0,15,0,0)  
    Label.BackgroundTransparency = 1  
    Label.Text = name .. ((rowType == "ESP_Toggle" or rowType == "Toggle") and " (OFF)" or "")  
    Label.TextColor3 = Color3.fromRGB(240,245,255)  
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamMedium  
    Label.TextXAlignment = Enum.TextXAlignment.Left  
    Label.Parent = Row  

    if rowType == "ESP_Toggle" or rowType == "Toggle" then  
        local ToggleBtn = Instance.new("TextButton")  
        ToggleBtn.Size = UDim2.new(0,55,0,26)  
        ToggleBtn.Position = UDim2.new(1,-70,0,9)  
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(35,50,75)  
        ToggleBtn.Text = ""  
        ToggleBtn.Parent = Row  
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0.5,0)  

        local Circle = Instance.new("Frame")  
        Circle.Size = UDim2.new(0,20,0,20)  
        Circle.Position = UDim2.new(0,3,0.5,-10)  
        Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)  
        Circle.Parent = ToggleBtn  
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(0.5,0)  

        local ColorContainer  
        if rowType == "ESP_Toggle" then  
            ColorContainer = Instance.new("Frame")  
            ColorContainer.Size = UDim2.new(1, 0, 0, 40)  
            ColorContainer.Position = UDim2.new(0, 0, 0, 45)  
            ColorContainer.BackgroundTransparency = 1  
            ColorContainer.Visible = false  
            ColorContainer.Parent = Row  

            local ColorLabel = Instance.new("TextLabel")  
            ColorLabel.Size = UDim2.new(0, 75, 1, 0)  
            ColorLabel.Position = UDim2.new(0, 15, 0, 0)  
            ColorLabel.BackgroundTransparency = 1  
            ColorLabel.Text = "Warna ESP:"  
            ColorLabel.TextColor3 = Color3.fromRGB(150, 180, 210)  
            ColorLabel.TextSize = 12  
            ColorLabel.Font = Enum.Font.GothamMedium  
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left  
            ColorLabel.Parent = ColorContainer  

            local ColorsFrame = Instance.new("Frame")  
            ColorsFrame.Size = UDim2.new(1, -95, 1, 0)  
            ColorsFrame.Position = UDim2.new(0, 90, 0, 0)  
            ColorsFrame.BackgroundTransparency = 1  
            ColorsFrame.Parent = ColorContainer  

            local ColorsLayout = Instance.new("UIListLayout")  
            ColorsLayout.FillDirection = Enum.FillDirection.Horizontal  
            ColorsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left  
            ColorsLayout.VerticalAlignment = Enum.VerticalAlignment.Center  
            ColorsLayout.Padding = UDim.new(0, 6)  
            ColorsLayout.Parent = ColorsFrame  

            local TeamToggleBtn = Instance.new("TextButton")  
            TeamToggleBtn.Size = UDim2.new(0, 42, 0, 22)  
            TeamToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 220)  
            TeamToggleBtn.Text = "TEAM"  
            TeamToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)  
            TeamToggleBtn.Font = Enum.Font.GothamBold  
            TeamToggleBtn.TextSize = 9  
            TeamToggleBtn.Parent = ColorsFrame  
            Instance.new("UICorner", TeamToggleBtn).CornerRadius = UDim.new(0, 4)  

            TeamToggleBtn.MouseButton1Click:Connect(function()  
                if name == "Player Outline" then OutlineUseTeam = true OutlineIsRainbow = false  
                elseif name == "Team Box ESP" then BoxUseTeam = true BoxIsRainbow = false  
                elseif name == "Team Tracer ESP" then TracerUseTeam = true TracerIsRainbow = false  
                elseif name == "Team Name ESP" then NameUseTeam = true NameIsRainbow = false end  
                if OutlineEnabled then UpdatePlayerOutlines() end  
            end)  

            local RainbowToggleBtn = Instance.new("TextButton")
            RainbowToggleBtn.Size = UDim2.new(0, 58, 0, 22)
            RainbowToggleBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
            RainbowToggleBtn.Text = "RAINBOW"
            RainbowToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
            RainbowToggleBtn.Font = Enum.Font.GothamBold
            RainbowToggleBtn.TextSize = 9
            RainbowToggleBtn.Parent = ColorsFrame
            Instance.new("UICorner", RainbowToggleBtn).CornerRadius = UDim.new(0, 4)

            local RainbowGrad = Instance.new("UIGradient")
            RainbowGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
            }
            RainbowGrad.Parent = RainbowToggleBtn

            local RainbowTextStroke = Instance.new("UIStroke")
            RainbowTextStroke.Color = Color3.fromRGB(0, 0, 0)
            RainbowTextStroke.Thickness = 1
            RainbowTextStroke.Parent = RainbowToggleBtn

            RainbowToggleBtn.MouseButton1Click:Connect(function()
                if name == "Player Outline" then OutlineUseTeam = false OutlineIsRainbow = true  
                elseif name == "Team Box ESP" then BoxUseTeam = false BoxIsRainbow = true  
                elseif name == "Team Tracer ESP" then TracerUseTeam = false TracerIsRainbow = true  
                elseif name == "Team Name ESP" then NameUseTeam = false NameIsRainbow = true end  
                if OutlineEnabled then UpdatePlayerOutlines() end  
            end)

            local colorPresets = {  
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(0, 230, 255),   
                Color3.fromRGB(255, 30, 30),   
                Color3.fromRGB(30, 255, 30),   
                Color3.fromRGB(255, 255, 30)
            }  

            for _, color in ipairs(colorPresets) do  
                local ColorBtn = Instance.new("TextButton")  
                ColorBtn.Size = UDim2.new(0, 20, 0, 20)  
                ColorBtn.BackgroundColor3 = color  
                ColorBtn.Text = ""  
                ColorBtn.Parent = ColorsFrame  
                Instance.new("UICorner", ColorBtn).CornerRadius = UDim.new(1, 0)  

                ColorBtn.MouseButton1Click:Connect(function()  
                    if name == "Player Outline" then OutlineUseTeam = false OutlineIsRainbow = false OutlineColor = color  
                    elseif name == "Team Box ESP" then BoxUseTeam = false BoxIsRainbow = false BoxColor = color  
                    elseif name == "Team Tracer ESP" then TracerUseTeam = false TracerIsRainbow = false TracerColor = color  
                    elseif name == "Team Name ESP" then NameUseTeam = false NameIsRainbow = false NameColor = color end  
                    if OutlineEnabled then UpdatePlayerOutlines() end  
                end)  
            end  
        end  

        local isOn = false  
        ToggleBtn.MouseButton1Click:Connect(function()  
            isOn = not isOn  
            Label.Text = name .. (isOn and " (ON)" or " (OFF)")  

            local targetPos = isOn and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)  
            local targetColor = isOn and Color3.fromRGB(0,180,255) or Color3.fromRGB(35,50,75)  

            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()  
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()  

            if rowType == "ESP_Toggle" then
                local isExpandable = (name ~= "Side Health ESP")
                local targetRowHeight = (isOn and isExpandable) and 85 or 45  
                
                TweenService:Create(Row, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, targetRowHeight)}):Play()  
                if ColorContainer and isExpandable then ColorContainer.Visible = isOn end  

                if name == "Player Outline" then OutlineEnabled = isOn UpdatePlayerOutlines()  
                elseif name == "Team Box ESP" then BoxesEnabled = isOn  
                elseif name == "Team Tracer ESP" then TracersEnabled = isOn if not isOn then for _, f in pairs(TracerFrames) do f.Visible = false end end  
                elseif name == "Team Name ESP" then NameESPEnabled = isOn  
                elseif name == "Side Health ESP" then HealthESPEnabled = isOn end  
            elseif rowType == "Toggle" then
                configData.Callback(isOn)
            end
        end)  

	elseif rowType == "TextBox" then
		local SizeInput = Instance.new("TextBox")
		SizeInput.Size = UDim2.new(0, 65, 0, 26)
		SizeInput.Position = UDim2.new(1, -80, 0.5, -13)
		SizeInput.BackgroundColor3 = Color3.fromRGB(35, 50, 75)
		SizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
		SizeInput.Font = Enum.Font.GothamBold
		SizeInput.TextSize = 13
		SizeInput.Text = tostring(configData.Default)
		SizeInput.ClearTextOnFocus = true
		SizeInput.Parent = Row

		Instance.new("UICorner", SizeInput).CornerRadius = UDim.new(0.3, 0)
		
		local InputStroke = Instance.new("UIStroke")
		InputStroke.Color = Color3.fromRGB(0, 100, 180)
		InputStroke.Parent = SizeInput

		SizeInput.FocusLost:Connect(function()
			configData.Callback(SizeInput)
		end)

	elseif rowType == "Cycle" then
		local CycleBtn = Instance.new("TextButton")
		CycleBtn.Size = UDim2.new(0, 85, 0, 26)
		CycleBtn.Position = UDim2.new(1, -100, 0.5, -13)
		CycleBtn.BackgroundColor3 = Color3.fromRGB(35, 50, 75)
		CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CycleBtn.Font = Enum.Font.GothamBold
		CycleBtn.TextSize = 12
		
		local currentIdx = 1
		CycleBtn.Text = configData.List[currentIdx]
		CycleBtn.Parent = Row

		Instance.new("UICorner", CycleBtn).CornerRadius = UDim.new(0.3, 0)
		
		local CycleStroke = Instance.new("UIStroke")
		CycleStroke.Color = Color3.fromRGB(0, 100, 180)
		CycleStroke.Parent = CycleBtn

		CycleBtn.MouseButton1Click:Connect(function()
			currentIdx = currentIdx + 1
			if currentIdx > #configData.List then currentIdx = 1 end
			CycleBtn.Text = configData.List[currentIdx]
			configData.Callback(configData.List[currentIdx])
		end)
    end
end

CreateScriptRow("ESP_Toggle", "Player Outline", nil)
CreateScriptRow("ESP_Toggle", "Team Box ESP", nil)
CreateScriptRow("ESP_Toggle", "Team Tracer ESP", nil)
CreateScriptRow("ESP_Toggle", "Team Name ESP", nil)
CreateScriptRow("ESP_Toggle", "Side Health ESP", nil)

CreateScriptRow("Toggle", "Aimbot POV", {
	Callback = function(isOn)
		circleEnabled = isOn
		TargetCircle.Visible = isOn
	end
})

CreateScriptRow("Toggle", "Aimbot Shoot button", {
	Callback = function(isOn)
		shootLockEnabled = isOn
		if not isOn then shootLockActiveUntil = 0 end
	end
})

CreateScriptRow("Toggle", "Ignore Teammate", {
	Callback = function(isOn)
		dontLockTeammate = isOn
	end
})

-- BARU: Pemicu Wall Check
CreateScriptRow("Toggle", "Wall Check", {
	Callback = function(isOn)
		wallCheckEnabled = isOn
	end
})

CreateScriptRow("TextBox", "POV Radius", {
	Default = circleRadius,
	Callback = function(box)
		local verifiedNum = tonumber(box.Text)
		if verifiedNum and verifiedNum > 0 then
			circleRadius = verifiedNum
			UpdateCircleVisual()
		else
			box.Text = tostring(circleRadius)
		end
	end
})

-- DIPERBARUI: Opsi warna "Invisible" ditambahkan tanpa menghapus preset bawaan
CreateScriptRow("Cycle", "Circle Color", {
	List = {"Cyan Neon", "Red", "Green", "Yellow", "Invisible", "Rainbow"},
	Callback = function(selectedOption)
		if selectedOption == "Rainbow" then
			AimbotIsRainbow = true
			AimbotIsInvisibleColor = false
		elseif selectedOption == "Invisible" then
			AimbotIsRainbow = false
			AimbotIsInvisibleColor = true
			CircleStroke.Color = aimbotColorPresets["Invisible"]
		else
			AimbotIsRainbow = false
			AimbotIsInvisibleColor = false
			CircleStroke.Color = aimbotColorPresets[selectedOption]
		end
	end
})

CreateScriptRow("Cycle", "Camera Target", {
	List = {"Head", "Torso"},
	Callback = function(selectedOption)
		targetBodyPart = selectedOption
	end
})

----------------------------------------------------
-- MAIN CORE RUNTIME RENDER LOOP
----------------------------------------------------
RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera
    local viewportSize = Camera.ViewportSize
    local startPos = Vector2.new(viewportSize.X / 2, viewportSize.Y)

    for _, player in ipairs(Players:GetPlayers()) do  
        if player ~= LocalPlayer then  
            local character = player.Character  
            local hrp = character and character:FindFirstChild("HumanoidRootPart")  
            local humanoid = character and character:FindFirstChild("Humanoid")  

            if hrp and humanoid then  
                -- MANAGE BOX ESP
                local boxESP = hrp:FindFirstChild("PlayerBoxESP")  
                if boxESP then  
                    boxESP.Enabled = BoxesEnabled
                    local bf = boxESP:FindFirstChild("BoxFrame")  
                    if bf then   
                        local s = bf:FindFirstChildOfClass("UIStroke")  
                        if s then s.Color = GetActiveColor(player, "Box") end  
                    end  
                end  

                -- MANAGE DYNAMIC NAMETAG
                local nameTag = character:FindFirstChild("DynamicNameTag")
                if nameTag then
                    nameTag.Enabled = NameESPEnabled
                    local label = nameTag:FindFirstChild("NameLabel")
                    if label then
                        label.TextColor3 = GetActiveColor(player, "Name")
                    end
                end

                -- MANAGE SIDE HEALTH STUDS ACCURATE BAR
                local sideHealth = character:FindFirstChild("SideHealthBar")
                if sideHealth then
                    sideHealth.Enabled = HealthESPEnabled
                    local bgFrame = sideHealth:FindFirstChild("BGFrame")
                    local fillBar = bgFrame and bgFrame:FindFirstChild("FillBar")
                    if fillBar then
                        local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        fillBar.Size = UDim2.new(1, 0, percent, 0)
                        
                        fillBar.BackgroundColor3 = Color3.fromRGB(
                            255 * (1 - percent),
                            255 * percent,
                            0
                        )
                    end
                end
            end  

            -- MANAGE TRACERS
            if TracersEnabled and hrp and humanoid and humanoid.Health > 0 then  
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)  
                
                if screenPos.Z < 0 then  
                    local center = viewportSize / 2  
                    local dir = (Vector2.new(screenPos.X, screenPos.Y) - center).Unit  
                    if dir.Magnitude == 0 or tostring(dir.X) == "nan" then dir = Vector2.new(0, 1) end  
                    local farPoint = center - (dir * 2000)  
                    screenPos = Vector3.new(farPoint.X, farPoint.Y, screenPos.Z)  
                end  

                local padding = 15  
                local clampedX = math.clamp(screenPos.X, padding, viewportSize.X - padding)  
                local clampedY = math.clamp(screenPos.Y, padding, viewportSize.Y - padding)  
                
                local endPos = Vector2.new(clampedX, clampedY)  
                local frame = TracerFrames[player]  

                if not frame then  
                    frame = Instance.new("Frame")  
                    frame.BorderSizePixel = 0  
                    frame.AnchorPoint = Vector2.new(0.5, 0.5)  
                    frame.Parent = TracerFolder  
                    TracerFrames[player] = frame  
                end  

                local distance = (endPos - startPos).Magnitude  
                frame.Size = UDim2.new(0, distance, 0, 2)  
                frame.Position = UDim2.new(0, (startPos.X + endPos.X) / 2, 0, (startPos.Y + endPos.Y) / 2)  
                frame.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X))  
                frame.BackgroundColor3 = GetActiveColor(player, "Tracer")  
                frame.Visible = true  
            else  
                if TracerFrames[player] then TracerFrames[player].Visible = false end  
            end  

            -- MANAGE OUTLINES
            if character and OutlineEnabled then  
                local hl = character:FindFirstChild("PlayerOutline")  
                if hl then hl.OutlineColor = GetActiveColor(player, "Outline") end  
            end  
        end  
    end

	-- AIMBOT CALCULATION ENGINE
	local finalTargetRoot = nil

	if shootLockEnabled and os.clock() < shootLockActiveUntil and currentShootLockTarget and currentShootLockTarget.Parent then
		local humanoid = currentShootLockTarget.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			-- Tambahan validasi Wall Check untuk Shoot Lock jika diaktifkan
			if not wallCheckEnabled or IsPlayerVisible(currentShootLockTarget, currentShootLockTarget.Parent) then
				finalTargetRoot = currentShootLockTarget
			end
		end
	elseif circleEnabled then
		finalTargetRoot = GetClosestTarget(circleRadius)
	end

	if finalTargetRoot then
		local character = finalTargetRoot.Parent
		local cameraLookPosition = finalTargetRoot.Position

		if targetBodyPart == "Head" then
			local head = character:FindFirstChild("Head")
			if head then cameraLookPosition = head.Position end
		elseif targetBodyPart == "Torso" then
			local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
			if torso then cameraLookPosition = torso.Position end
		end

		Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, cameraLookPosition)
	end

	-- REAL-TIME ADAPTIVE FOV CIRCLE VISIBILITY MANAGEMENT
	if circleEnabled then
		if AimbotIsRainbow then
			CircleStroke.Transparency = 0
			CircleStroke.Color = Color3.fromHSV((os.clock() * 0.4) % 1, 1, 1)
		elseif AimbotIsInvisibleColor then
			-- Bener-bener disembunyikan dari layar tanpa mematikan fungsi deteksi Aimbot
			CircleStroke.Transparency = 1
		else
			CircleStroke.Transparency = 0
		end
	end
end)
----------------------------------------------------
-- INTERFACE FOOTER ACTIONS & DRAG REGISTRATION
----------------------------------------------------
local ExecuteAllBtn = Instance.new("TextButton")
ExecuteAllBtn.Size = UDim2.new(0.7,0,0,40)
ExecuteAllBtn.Position = UDim2.new(0,15,1,-50)
ExecuteAllBtn.BackgroundColor3 = Color3.fromRGB(0,90,180)
ExecuteAllBtn.Text = "EXECUTE SELECTED SCRIPTS"
ExecuteAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
ExecuteAllBtn.TextSize = 14
ExecuteAllBtn.Font = Enum.Font.GothamBold
ExecuteAllBtn.Parent = MainFrame

Instance.new("UICorner", ExecuteAllBtn).CornerRadius = UDim.new(0,6)
local ExecGradient = Instance.new("UIGradient")
ExecGradient.Color = ColorSequence.new(Color3.fromRGB(0,100,220), Color3.fromRGB(0,150,255))
ExecGradient.Parent = ExecuteAllBtn

local PastebinBtn = Instance.new("TextButton")
PastebinBtn.Size = UDim2.new(0.23,0,0,40)
PastebinBtn.Position = UDim2.new(0.74,0,1,-50)
PastebinBtn.BackgroundColor3 = Color3.fromRGB(20,40,70)
PastebinBtn.Text = "PASTE BIN"
PastebinBtn.TextColor3 = Color3.fromRGB(0,200,255)
PastebinBtn.TextSize = 13
PastebinBtn.Font = Enum.Font.GothamBold
PastebinBtn.Parent = MainFrame

Instance.new("UICorner", PastebinBtn).CornerRadius = UDim.new(0,6)
local PasteStroke = Instance.new("UIStroke")
PasteStroke.Color = Color3.fromRGB(0,130,220)
PasteStroke.Parent = PastebinBtn

local RoundToggleBtn = Instance.new("TextButton")
RoundToggleBtn.Name = "RoundToggleBtn"
RoundToggleBtn.Size = UDim2.new(0,60,0,60)
RoundToggleBtn.Position = UDim2.new(0,20,0.5,-30)
RoundToggleBtn.BackgroundColor3 = Color3.fromRGB(10,25,50)
RoundToggleBtn.Text = "AS"
RoundToggleBtn.TextColor3 = Color3.fromRGB(0,180,255)
RoundToggleBtn.TextSize = 20
RoundToggleBtn.Font = Enum.Font.GothamBold
RoundToggleBtn.Visible = false
RoundToggleBtn.Parent = ScreenGui

Instance.new("UICorner", RoundToggleBtn).CornerRadius = UDim.new(1,0)
local RoundStroke = Instance.new("UIStroke")
RoundStroke.Color = Color3.fromRGB(0,150,255)
RoundStroke.Thickness = 2
RoundStroke.Parent = RoundToggleBtn

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false RoundToggleBtn.Visible = true end)
RoundToggleBtn.MouseButton1Click:Connect(function() RoundToggleBtn.Visible = false MainFrame.Visible = true end)

local function MakeDraggable(uiElement)
    local dragging, dragInput, dragStart, startPos
    uiElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = uiElement.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    uiElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            uiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(MainFrame)
MakeDraggable(RoundToggleBtn)

MainFrame.Size = UDim2.new(0,0,0,0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0,550,0,400)}):Play()
