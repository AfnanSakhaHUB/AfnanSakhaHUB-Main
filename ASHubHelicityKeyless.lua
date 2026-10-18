--// ===================================================
--// BAGIAN 1: SYSTEM UI & FRAMEWORK
--// ===================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- AUTO CLEANUP
local oldUI1 = PlayerGui:FindFirstChild("AfnanSakhaLoadingScreen")
if oldUI1 then oldUI1:Destroy() end

local oldUI2 = PlayerGui:FindFirstChild("AfnanSakhaHubUI")
if oldUI2 then oldUI2:Destroy() end

-- LOADING SCREEN
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "AfnanSakhaLoadingScreen"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,100,255)),
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

-- ANIMASI LOADING
local totalAssets = 100
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(0.5)

for i = 1, totalAssets do
	local progress = i / totalAssets
	TweenService:Create(BarFill, tweenInfo, {Size = UDim2.new(progress,0,1,0)}):Play()
	StatusLabel.Text = i .. "/" .. totalAssets .. " assets loaded"

	if i < 20 or i > 80 then task.wait(0.01)
	elseif i == 50 or i == 75 then task.wait(0.2)
	else task.wait(0.02) end
end

StatusLabel.Text = "Selesai!"
task.wait(0.3)

-- FADE OUT
local fadeTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(Background, fadeTweenInfo, {BackgroundTransparency = 1}):Play()

for _, child in ipairs(MainContainer:GetChildren()) do
	if child:IsA("TextLabel") then
		TweenService:Create(child, fadeTweenInfo, {TextTransparency = 1}):Play()
	elseif child:IsA("Frame") then
		TweenService:Create(child, fadeTweenInfo, {BackgroundTransparency = 1}):Play()
		local stroke = child:FindFirstChildOfClass("UIStroke")
		if stroke then TweenService:Create(stroke, fadeTweenInfo, {Transparency = 1}):Play() end
	end
end
task.wait(0.4)
LoadingGui:Destroy()

-- MAIN GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AfnanSakhaHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

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
end

CreateTab("SCRIPTS",1)
CreateTab("SETTINGS",2)
CreateTab("HISTORY",3)

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1,-30,0,230)
ScrollList.Position = UDim2.new(0,15,0,95)
ScrollList.BackgroundTransparency = 1
ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(0,180,255)
ScrollList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ScrollList

-- MANAJER UI (GLOBAL AGAR BISA DIPAKAI DI BAGIAN 2)
_G.AfnanHub = {}

function _G.AfnanHub.AddToggle(name, defaultState, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1,-10,0,45)
	Row.BackgroundColor3 = Color3.fromRGB(18,32,55)
	Row.Parent = ScrollList
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0,8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.65,0,1,0)
	Label.Position = UDim2.new(0,15,0,0)
	Label.BackgroundTransparency = 1
	Label.Text = name .. (defaultState and " (ON)" or " (OFF)")
	Label.TextColor3 = Color3.fromRGB(240,245,255)
	Label.TextSize = 14
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0,55,0,26)
	ToggleBtn.Position = UDim2.new(1,-70,0.5,-13)
	ToggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0,180,255) or Color3.fromRGB(35,50,75)
	ToggleBtn.Text = ""
	ToggleBtn.Parent = Row
	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0.5,0)

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0,20,0,20)
	Circle.Position = defaultState and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)
	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.Parent = ToggleBtn
	Instance.new("UICorner", Circle).CornerRadius = UDim.new(0.5,0)

	local isOn = defaultState
	ToggleBtn.MouseButton1Click:Connect(function()
		isOn = not isOn
		Label.Text = name .. (isOn and " (ON)" or " (OFF)")
		local targetPos = isOn and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)
		local targetColor = isOn and Color3.fromRGB(0,180,255) or Color3.fromRGB(35,50,75)

		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
		TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

		if callback then task.spawn(callback, isOn) end
	end)

	if defaultState and callback then task.spawn(callback, true) end
end

function _G.AfnanHub.AddButton(name, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1,-10,0,45)
	Row.BackgroundColor3 = Color3.fromRGB(18,32,55)
	Row.Parent = ScrollList
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0,8)

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1,-20,0,30)
	Btn.Position = UDim2.new(0,10,0.5,-15)
	Btn.BackgroundColor3 = Color3.fromRGB(0,120,200)
	Btn.Text = name
	Btn.TextColor3 = Color3.fromRGB(255,255,255)
	Btn.TextSize = 14
	Btn.Font = Enum.Font.GothamBold
	Btn.Parent = Row
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)

	Btn.MouseButton1Click:Connect(function()
		if callback then task.spawn(callback) end
	end)
end

-- SYSTEM DRAG & TOGGLE UI
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

CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	RoundToggleBtn.Visible = true
end)

RoundToggleBtn.MouseButton1Click:Connect(function()
	RoundToggleBtn.Visible = false
	MainFrame.Visible = true
end)

local function MakeDraggable(uiElement)
	local dragging, dragInput, dragStart, startPos
	uiElement.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = uiElement.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	uiElement.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
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
--// ===================================================
--// BAGIAN 2: TORNADO ESP, VEHICLE BOOSTER, INTERCEPTOR, & TP
--// ===================================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Status Toggle Terpisah
local highlightEnabled = false
local tracerEnabled = false
local predictorEnabled = false
local vehicleSpeedEnabled = false
local interceptorEnabled = false

-- Konfigurasi Penguat Kecepatan & Rem Otomatis (Bisa Diatur via UI)
local BOOST_MULTIPLIER = 2.5   -- Multiplier kecepatan
local MAX_ORIGINAL_SPEED = 200 -- Batas kecepatan asli maksimal

-- Status Tombol UI (Touch / Click)
local isGasPressed = false
local isBrakePressed = false

-- Variabel UI
local predictorHudGui = nil
local vehicleControlGui = nil
local playerListGui = nil
local hudDistLabel, hudDirLabel, hudThreatLabel = nil, nil, nil

-- Tabel untuk menyimpan referensi ESP & Prediksi per Tornado
local activeTornadoes = {}

-- ===================================================
-- FUNGSI BANTUAN ARAH & ANCAMAN
-- ===================================================
local function getCardinalDirection(v)
    if v.Magnitude < 0.5 then return "Diam (Stationary)" end
    local x, z = v.X, v.Z
    local deg = math.deg(math.atan2(x, -z))
    if deg < 0 then deg = deg + 360 end
    
    if deg >= 337.5 or deg < 22.5 then return "Utara (North)"
    elseif deg >= 22.5 and deg < 67.5 then return "Timur Laut (Northeast)"
    elseif deg >= 67.5 and deg < 112.5 then return "Timur (East)"
    elseif deg >= 112.5 and deg < 157.5 then return "Tenggara (Southeast)"
    elseif deg >= 157.5 and deg < 202.5 then return "Selatan (South)"
    elseif deg >= 202.5 and deg < 247.5 then return "Barat Daya (Southwest)"
    elseif deg >= 247.5 and deg < 292.5 then return "Barat (West)"
    elseif deg >= 292.5 and deg < 337.5 then return "Barat Laut (Northwest)"
    end
    return "Utara (North)"
end

-- ===================================================
-- MANAJEMEN UI KONTROL VEHICLE (GAS & REM + SETTING)
-- ===================================================
local function createVehicleControlUI()
    if vehicleControlGui then return end
    local playerGui = player:WaitForChild("PlayerGui")
    
    vehicleControlGui = Instance.new("ScreenGui")
    vehicleControlGui.Name = "AfnanVehicleControlUI"
    vehicleControlGui.ResetOnSpawn = false
    vehicleControlGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 160)
    frame.Position = UDim2.new(1, -230, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = vehicleControlGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Text = "🚗 VEHICLE SPEED CONTROLLER"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 12
    title.Font = Enum.Font.SourceSansBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    local multLabel = Instance.new("TextLabel")
    multLabel.Size = UDim2.new(0, 100, 0, 20)
    multLabel.Position = UDim2.new(0, 10, 0, 30)
    multLabel.Text = "Multiplier (x):"
    multLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    multLabel.TextSize = 12
    multLabel.Font = Enum.Font.SourceSans
    multLabel.TextXAlignment = Enum.TextXAlignment.Left
    multLabel.BackgroundTransparency = 1
    multLabel.Parent = frame
    
    local multBox = Instance.new("TextBox")
    multBox.Size = UDim2.new(0, 90, 0, 20)
    multBox.Position = UDim2.new(0, 110, 0, 30)
    multBox.Text = tostring(BOOST_MULTIPLIER)
    multBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    multBox.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
    multBox.TextSize = 12
    multBox.Font = Enum.Font.SourceSansBold
    multBox.Parent = frame
    
    multBox.FocusLost:Connect(function()
        local val = tonumber(multBox.Text)
        if val then BOOST_MULTIPLIER = val else multBox.Text = tostring(BOOST_MULTIPLIER) end
    end)
    
    local maxLabel = Instance.new("TextLabel")
    maxLabel.Size = UDim2.new(0, 100, 0, 20)
    maxLabel.Position = UDim2.new(0, 10, 0, 55)
    maxLabel.Text = "Max Speed:"
    maxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    maxLabel.TextSize = 12
    maxLabel.Font = Enum.Font.SourceSans
    maxLabel.TextXAlignment = Enum.TextXAlignment.Left
    maxLabel.BackgroundTransparency = 1
    maxLabel.Parent = frame
    
    local maxBox = Instance.new("TextBox")
    maxBox.Size = UDim2.new(0, 90, 0, 20)
    maxBox.Position = UDim2.new(0, 110, 0, 55)
    maxBox.Text = tostring(MAX_ORIGINAL_SPEED)
    maxBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    maxBox.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
    maxBox.TextSize = 12
    maxBox.Font = Enum.Font.SourceSansBold
    maxBox.Parent = frame
    
    maxBox.FocusLost:Connect(function()
        local val = tonumber(maxBox.Text)
        if val then MAX_ORIGINAL_SPEED = val else maxBox.Text = tostring(MAX_ORIGINAL_SPEED) end
    end)
    
    local gasBtn = Instance.new("TextButton")
    gasBtn.Size = UDim2.new(0, 95, 0, 65)
    gasBtn.Position = UDim2.new(0, 10, 0, 85)
    gasBtn.Text = "GAS ⚡"
    gasBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gasBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    gasBtn.Font = Enum.Font.SourceSansBold
    gasBtn.TextSize = 16
    gasBtn.Parent = frame
    
    local gasCorner = Instance.new("UICorner")
    gasCorner.CornerRadius = UDim.new(0, 6)
    gasCorner.Parent = gasBtn
    
    local brakeBtn = Instance.new("TextButton")
    brakeBtn.Size = UDim2.new(0, 95, 0, 65)
    brakeBtn.Position = UDim2.new(0, 115, 0, 85)
    brakeBtn.Text = "REM 🛑"
    brakeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    brakeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    brakeBtn.Font = Enum.Font.SourceSansBold
    brakeBtn.TextSize = 16
    brakeBtn.Parent = frame
    
    local brakeCorner = Instance.new("UICorner")
    brakeCorner.CornerRadius = UDim.new(0, 6)
    brakeCorner.Parent = brakeBtn
    
    gasBtn.MouseButton1Down:Connect(function() isGasPressed = true end)
    gasBtn.MouseButton1Up:Connect(function() isGasPressed = false end)
    gasBtn.MouseLeave:Connect(function() isGasPressed = false end)
    
    brakeBtn.MouseButton1Down:Connect(function() isBrakePressed = true end)
    brakeBtn.MouseButton1Up:Connect(function() isBrakePressed = false end)
    brakeBtn.MouseLeave:Connect(function() isBrakePressed = false end)
end

local function destroyVehicleControlUI()
    if vehicleControlGui then
        vehicleControlGui:Destroy()
        vehicleControlGui = nil
    end
    isGasPressed = false
    isBrakePressed = false
end

-- ===================================================
-- MANAJEMEN UI HUD PREDICTOR
-- ===================================================
local function createPredictorHUD()
    if predictorHudGui then return end
    local playerGui = player:WaitForChild("PlayerGui")
    
    predictorHudGui = Instance.new("ScreenGui")
    predictorHudGui.Name = "AfnanTornadoPredictorHUD"
    predictorHudGui.ResetOnSpawn = false
    predictorHudGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 115)
    frame.Position = UDim2.new(0.5, -130, 0, 15)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = predictorHudGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.Text = "🌪️ TORNADO PREDICTOR HUD"
    title.TextColor3 = Color3.fromRGB(255, 165, 0)
    title.TextSize = 13
    title.Font = Enum.Font.SourceSansBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    hudDistLabel = Instance.new("TextLabel")
    hudDistLabel.Size = UDim2.new(1, -20, 0, 20)
    hudDistLabel.Position = UDim2.new(0, 10, 0, 30)
    hudDistLabel.Text = "Jarak Terdekat: -"
    hudDistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    hudDistLabel.TextSize = 13
    hudDistLabel.Font = Enum.Font.SourceSans
    hudDistLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudDistLabel.BackgroundTransparency = 1
    hudDistLabel.Parent = frame
    
    hudDirLabel = Instance.new("TextLabel")
    hudDirLabel.Size = UDim2.new(1, -20, 0, 20)
    hudDirLabel.Position = UDim2.new(0, 10, 0, 52)
    hudDirLabel.Text = "Arah Gerak: -"
    hudDirLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
    hudDirLabel.TextSize = 13
    hudDirLabel.Font = Enum.Font.SourceSans
    hudDirLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudDirLabel.BackgroundTransparency = 1
    hudDirLabel.Parent = frame
    
    hudThreatLabel = Instance.new("TextLabel")
    hudThreatLabel.Size = UDim2.new(1, -20, 0, 25)
    hudThreatLabel.Position = UDim2.new(0, 10, 0, 78)
    hudThreatLabel.Text = "Menuju Ke Kita?: Mencari..."
    hudThreatLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    hudThreatLabel.TextSize = 13
    hudThreatLabel.Font = Enum.Font.SourceSansBold
    hudThreatLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudThreatLabel.BackgroundTransparency = 1
    hudThreatLabel.Parent = frame
end

local function destroyPredictorHUD()
    if predictorHudGui then
        predictorHudGui:Destroy()
        predictorHudGui = nil
    end
end

-- ===================================================
-- FUNGSI ESP & PREDICTOR UTAMA
-- ===================================================
local function createTornadoData(obj)
    if activeTornadoes[obj] then return end
    
    local data = {
        lastPos = nil,
        lastTime = nil,
        velocity = Vector3.zero
    }
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "TornadoHighlight"
    highlight.Adornee = obj
    highlight.FillColor = Color3.fromRGB(0, 150, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = highlightEnabled
    highlight.Parent = obj
    data.highlight = highlight
    
    if Drawing then
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(0, 170, 255)
        tracer.Thickness = 1.5
        tracer.Transparency = 0.8
        data.tracer = tracer
        
        local predLine = Drawing.new("Line")
        predLine.Visible = false
        predLine.Color = Color3.fromRGB(255, 165, 0)
        predLine.Thickness = 2
        predLine.Transparency = 0.9
        data.predLine = predLine
        
        local predCircle = Drawing.new("Circle")
        predCircle.Visible = false
        predCircle.Color = Color3.fromRGB(255, 100, 0)
        predCircle.Thickness = 2
        predCircle.NumSides = 16
        predCircle.Radius = 8
        predCircle.Filled = false
        data.predCircle = predCircle
    end
    
    activeTornadoes[obj] = data
end

local function removeTornadoData(obj)
    local data = activeTornadoes[obj]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.tracer then data.tracer:Remove() end
        if data.predLine then data.predLine:Remove() end
        if data.predCircle then data.predCircle:Remove() end
        activeTornadoes[obj] = nil
    end
end

local function clearAllTornadoes()
    for obj, _ in pairs(activeTornadoes) do
        removeTornadoData(obj)
    end
    activeTornadoes = {}
end

local function updateHighlightState()
    for _, data in pairs(activeTornadoes) do
        if data.highlight then
            data.highlight.Enabled = highlightEnabled
        end
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    local anyEnabled = highlightEnabled or tracerEnabled or predictorEnabled
    if anyEnabled and obj.Name == "Tornado" and (obj:IsA("BasePart") or obj:IsA("Model")) then
        createTornadoData(obj)
    end
end)

task.spawn(function()
    while true do
        local anyEnabled = highlightEnabled or tracerEnabled or predictorEnabled
        if anyEnabled then
            local currentTornadoes = {}
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name == "Tornado" and (obj:IsA("BasePart") or obj:IsA("Model")) then
                    currentTornadoes[obj] = true
                    if not activeTornadoes[obj] then
                        createTornadoData(obj)
                    end
                end
            end
            
            for obj, _ in pairs(activeTornadoes) do
                if not currentTornadoes[obj] or not obj.Parent then
                    removeTornadoData(obj)
                end
            end
        else
            if next(activeTornadoes) then
                clearAllTornadoes()
            end
        end
        task.wait(1)
    end
end)

RunService.RenderStepped:Connect(function()
    local currentTime = os.clock()
    local closestDist = math.huge
    local closestInfo = nil
    
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position or camera.CFrame.Position
    
    for obj, data in pairs(activeTornadoes) do
        if obj and obj.Parent then
            local pos = Vector3.zero
            if obj:IsA("Model") then
                pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end
            
            local distToPlayer = (pos - playerPos).Magnitude
            if distToPlayer < closestDist then
                closestDist = distToPlayer
                local dirText = getCardinalDirection(data.velocity)
                local toPlayer = (playerPos - pos)
                toPlayer = Vector3.new(toPlayer.X, 0, toPlayer.Z)
                local velXZ = Vector3.new(data.velocity.X, 0, data.velocity.Z)
                
                local isApproaching = false
                if velXZ.Magnitude > 0.5 and toPlayer.Magnitude > 0 then
                    if velXZ:Dot(toPlayer) > 0 then
                        isApproaching = true
                    end
                end
                
                closestInfo = {
                    distance = math.floor(distToPlayer),
                    direction = dirText,
                    approaching = isApproaching
                }
            end
            
            if data.lastPos and data.lastTime then
                local dt = currentTime - data.lastTime
                if dt > 0 then
                    local instantVel = (pos - data.lastPos) / dt
                    data.velocity = data.velocity:Lerp(instantVel, 0.2)
                end
            end
            data.lastPos = pos
            data.lastTime = currentTime
            
            if tracerEnabled and data.tracer then
                local screenPos, onScreen = camera:WorldToViewportPoint(pos)
                if onScreen then
                    data.tracer.Visible = true
                    data.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    data.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                else
                    data.tracer.Visible = false
                end
            elseif data.tracer then
                data.tracer.Visible = false
            end
            
            if predictorEnabled and data.predLine and data.predCircle then
                local predictionTime = 4 
                local predictedPos = pos + (Vector3.new(data.velocity.X, 0, data.velocity.Z) * predictionTime)
                local screenPos, onScreen = camera:WorldToViewportPoint(pos)
                local predScreenPos, predOnScreen = camera:WorldToViewportPoint(predictedPos)
                
                if onScreen or predOnScreen then
                    data.predLine.Visible = true
                    data.predLine.From = Vector2.new(screenPos.X, screenPos.Y)
                    data.predLine.To = Vector2.new(predScreenPos.X, predScreenPos.Y)
                    data.predCircle.Visible = true
                    data.predCircle.Position = Vector2.new(predScreenPos.X, predScreenPos.Y)
                else
                    data.predLine.Visible = false
                    data.predCircle.Visible = false
                end
            else
                if data.predLine then data.predLine.Visible = false end
                if data.predCircle then data.predCircle.Visible = false end
            end
        else
            if data.tracer then data.tracer.Visible = false end
            if data.predLine then data.predLine.Visible = false end
            if data.predCircle then data.predCircle.Visible = false end
        end
    end
    
    if predictorEnabled and hudDistLabel and hudDirLabel and hudThreatLabel then
        if closestInfo then
            hudDistLabel.Text = "Jarak Terdekat: " .. closestInfo.distance .. " Studs"
            hudDirLabel.Text = "Arah Gerak: " .. closestInfo.direction
            if closestInfo.approaching then
                hudThreatLabel.Text = "Menuju Ke Kita?: YA ⚠️ (BAHAYA!)"
                hudThreatLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            else
                hudThreatLabel.Text = "Menuju Ke Kita?: TIDAK (Aman/Menjauh)"
                hudThreatLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        else
            hudDistLabel.Text = "Jarak Terdekat: -"
            hudDirLabel.Text = "Arah Gerak: -"
            hudThreatLabel.Text = "Menuju Ke Kita?: Tidak ada tornado"
            hudThreatLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end)

-- ===================================================
-- LOGIKA INTERCEPTOR MODE (SOLID MUTLAK SPEED 0)
-- ===================================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local interceptorEnabled = false
local lockedCFrame = nil

-- Logika Penguncian Mutlak (Tanpa bisa bergerak sedikit pun)
RunService.Heartbeat:Connect(function()
    if not interceptorEnabled then 
        lockedCFrame = nil
        return 
    end
    
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local targetPart = hrp
    
    -- Mendukung karakter maupun saat sedang duduk di dalam kendaraan
    if humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        if seat.Parent and seat.Parent:IsA("Model") then
            targetPart = seat.Parent.PrimaryPart or seat
        end
    end
    
    if targetPart then
        -- Simpan posisi awal saat pertama kali Interceptor diaktifkan
        if not lockedCFrame then
            lockedCFrame = targetPart.CFrame
        end
        
        -- Kunci mati posisi dan rotasi secara mutlak (tidak bisa digeser angin/gravitasi)
        targetPart.CFrame = lockedCFrame
        targetPart.AssemblyLinearVelocity = Vector3.zero
        targetPart.AssemblyAngularVelocity = Vector3.zero
    end
end)

-- ===================================================
-- LOGIKA VEHICLE SPEED BOOSTER (INTERAKTIF UTAMA)
-- ===================================================
RunService.Heartbeat:Connect(function()
    if not vehicleSpeedEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local seatPart = humanoid.SeatPart
    if seatPart and seatPart:IsA("VehicleSeat") then
        local model = seatPart.Parent
        if model and model:IsA("Model") then
            local primaryPart = model.PrimaryPart or seatPart
            if primaryPart then
                local currentVel = primaryPart.AssemblyLinearVelocity
                local lookVector = primaryPart.CFrame.LookVector
                local currentSpeed = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
                local originalSpeed =currentSpeed / BOOST_MULTIPLIER
                
                local gasActive = isGasPressed or (seatPart.Throttle > 0)
                
                if gasActive and originalSpeed < MAX_ORIGINAL_SPEED then
                    local targetSpeed = math.max(currentSpeed * BOOST_MULTIPLIER, 15 * BOOST_MULTIPLIER)
                    local safeY = math.clamp(currentVel.Y, -10, 2)
                    
                    primaryPart.AssemblyLinearVelocity = Vector3.new(
                        lookVector.X * targetSpeed,
                        safeY,
                        lookVector.Z * targetSpeed
                    )
                elseif isBrakePressed then
                    local reduceFactor = math.clamp(1 / BOOST_MULTIPLIER, 0.1, 0.5)
                    primaryPart.AssemblyLinearVelocity = Vector3.new(
                        currentVel.X * reduceFactor,
                        currentVel.Y,
                        currentVel.Z * reduceFactor
                    )
                else
                    local flatVel = Vector3.new(currentVel.X, 0, currentVel.Z)
                    if flatVel.Magnitude > 10 then
                        primaryPart.AssemblyLinearVelocity = Vector3.new(
                            currentVel.X * 0.6,
                            currentVel.Y,
                            currentVel.Z * 0.6
                        )
                    else
                        -- Jika kecepatan di bawah 10, rem otomatis dimatikan
                    end
                end
            end
        end
    end
end)

-- ===================================================
-- FUNGSI TELEPORT TO TORNADO (~1000 Studs di Depan)
-- ===================================================
local function teleportToTornado()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local closestObj = nil
    local minDist = math.huge
    local tornadoPos = nil
    local tornadoVel = Vector3.zero
    
    -- Scan langsung ke dalam Workspace (Meskipun tornado jauh/baru muncul)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Tornado" and (obj:IsA("BasePart") or obj:IsA("Model")) then
            local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
            local dist = (pos - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closestObj = obj
                tornadoPos = pos
            end
        end
    end
    
    if closestObj and tornadoPos then
        -- Coba estimasi kecepatan tornado jika memiliki bagian fisik
        local primaryPart = closestObj:IsA("Model") and (closestObj.PrimaryPart or closestObj:FindFirstChildWhichIsA("BasePart")) or closestObj
        if primaryPart and primaryPart:IsA("BasePart") then
            tornadoVel = primaryPart.AssemblyLinearVelocity
        end
        
        local dir = Vector3.new(tornadoVel.X, 0, tornadoVel.Z)
        if dir.Magnitude < 0.5 then
            dir = Vector3.new(0, 0, 1) -- Arah default jika tornado diam
        else
            dir = dir.Unit
        end
        
        -- Hitung titik target: 1000 studs di depan arah gerak tornado
        local rawTargetPos = tornadoPos + (dir * 1000)
        
        -- Sesuaikan ketinggian secara otomatis berdasarkan permukaan tanah (Anti melayang/nyelip)
        local safeTargetPos = getSafeGroundPosition(rawTargetPos)
        
        -- Eksekusi Teleportasi
        local targetPart = hrp
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart then
            local seat = humanoid.SeatPart
            if seat.Parent and seat.Parent:IsA("Model") then
                targetPart = seat.Parent.PrimaryPart or seat
            end
        end
        
        targetPart.CFrame = CFrame.new(safeTargetPos)
    end
end

-- ===================================================
-- 2. FUNGSI TELEPORT TO PLAYER (FIX KETINGGIAN & TARGET)
-- ===================================================
local function teleportToTargetPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetChar = targetPlayer.Character
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart") 
                   or targetChar:FindFirstChild("Torso") 
                   or targetChar:FindFirstChild("UpperTorso")
                   
    if not targetHrp then return end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Ambil posisi target, lalu ratakan dengan permukaan tanah di bawahnya agar tidak melayang di udara
    local rawTargetPos = targetHrp.Position
    local safeTargetPos = getSafeGroundPosition(rawTargetPos)
    
    local targetPart = hrp
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        if seat.Parent and seat.Parent:IsA("Model") then
            targetPart = seat.Parent.PrimaryPart or seat
        end
    end
    
    targetPart.CFrame = CFrame.new(safeTargetPos)
end

--// ===================================================
--// FITUR: TELEPORT TO PLAYER (STANDALONE & FIXED)
--// ===================================================

local function openPlayerListUI()
    if playerListGui then
        playerListGui:Destroy()
        playerListGui = nil
        return
    end
    
    local playerGui = player:WaitForChild("PlayerGui")
    playerListGui = Instance.new("ScreenGui")
    playerListGui.Name = "AfnanPlayerTeleportUI"
    playerListGui.ResetOnSpawn = false
    playerListGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 230, 0, 300)
    frame.Position = UDim2.new(0.5, -115, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = playerListGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Text = "👥 PILIH PLAYER UNTUK TP"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 13
    title.Font = Enum.Font.SourceSansBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = frame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollingFrame
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 13
            btn.Parent = scrollingFrame
            
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                teleportToTargetPlayer(p)
                playerListGui:Destroy()
                playerListGui = nil
            end)
        end
    end
end

-- ===================================================
-- REGISTRASI FITUR KE UI HUB (TOGGLE & BUTTON)
-- ===================================================
if _G.AfnanHub then
    _G.AfnanHub.AddToggle("Tornado Highlight", false, function(state)
        highlightEnabled = state
        updateHighlightState()
        if not highlightEnabled and not tracerEnabled and not predictorEnabled then
            clearAllTornadoes()
        end
    end)
    
    _G.AfnanHub.AddToggle("Tornado Tracer", false, function(state)
        tracerEnabled = state
        if not state then
            for _, data in pairs(activeTornadoes) do
                if data.tracer then data.tracer.Visible = false end
            end
        end
        if not highlightEnabled and not tracerEnabled and not predictorEnabled then
            clearAllTornadoes()
        end
    end)
    
    _G.AfnanHub.AddToggle("Tornado Predictor", false, function(state)
        predictorEnabled = state
        if state then
            createPredictorHUD()
        else
            destroyPredictorHUD()
            for _, data in pairs(activeTornadoes) do
                if data.predLine then data.predLine.Visible = false end
                if data.predCircle then data.predCircle.Visible = false end
            end
        end
        if not highlightEnabled and not tracerEnabled and not predictorEnabled then
            clearAllTornadoes()
        end
    end)

    _G.AfnanHub.AddToggle("Vehicle Speed Booster", false, function(state)
        vehicleSpeedEnabled = state
        if state then
            createVehicleControlUI()
        else
            destroyVehicleControlUI()
        end
    end)

    _G.AfnanHub.AddToggle("Interceptor Mode", false, function(state)
        interceptorEnabled = state
    end)

    if _G.AfnanHub.AddButton then
        _G.AfnanHub.AddButton("TP to Tornado", function()
            teleportToTornado()
        end)
    else
        _G.AfnanHub.AddToggle("TP to Tornado", false, function(state)
            if state then
                teleportToTornado()
            end
        end)
    end

    if _G.AfnanHub.AddButton then
        _G.AfnanHub.AddButton("TP to Player", function()
            openPlayerListUI()
        end)
    else
        _G.AfnanHub.AddToggle("TP to Player", false, function(state)
            if state then
                openPlayerListUI()
            end
        end)
    end
end
