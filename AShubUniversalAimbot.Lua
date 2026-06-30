--// AFNANSAKHA HUB LOADER + MAIN GUI (CIRCLE LOCK & SHOOT LOCK)
--// Tempatkan di: StarterGui -> LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

----------------------------------------------------
-- AUTO CLEANUP
----------------------------------------------------
local oldUI1 = PlayerGui:FindFirstChild("AfnanSakhaLoadingScreen")
if oldUI1 then oldUI1:Destroy() end

local oldUI2 = PlayerGui:FindFirstChild("AfnanSakhaHubUI")
if oldUI2 then oldUI2:Destroy() end

----------------------------------------------------
-- LOADING SCREEN
----------------------------------------------------
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "AfnanSakhaLoadingScreen"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.Parent = PlayerGui

-- Background
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(10,15,30)
Background.BorderSizePixel = 0
Background.Parent = Background

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10,20,45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5,10,25))
}
UIGradient.Rotation = 45
UIGradient.Parent = Background

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0,500,0,150)
MainContainer.Position = UDim2.new(0.5,-250,0.5,-75)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = Background

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,0,0,30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Loading [AfnanSakha HUB]"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainContainer

-- Bar BG
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

-- Fill
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

-- Status
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

----------------------------------------------------
-- LOADING ANIMATION
----------------------------------------------------
local totalAssets = 100
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

task.wait(1)

for i = 1, totalAssets do
	local progress = i / totalAssets

	local tween = TweenService:Create(
		BarFill,
		tweenInfo,
		{Size = UDim2.new(progress,0,1,0)}
	)

	tween:Play()

	StatusLabel.Text = i .. "/" .. totalAssets .. " assets loaded"

	if i < 20 or i > 80 then
		task.wait(0.02)
	elseif i == 50 or i == 75 then
		task.wait(0.4)
	else
		task.wait(0.05)
	end
end

StatusLabel.Text = "Selesai!"
task.wait(0.5)

----------------------------------------------------
-- FADE OUT
----------------------------------------------------
local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenService:Create(
	Background,
	fadeTweenInfo,
	{BackgroundTransparency = 1}
):Play()

for _, child in ipairs(MainContainer:GetChildren()) do
	if child:IsA("TextLabel") then
		TweenService:Create(child, fadeTweenInfo, {
			TextTransparency = 1
		}):Play()

	elseif child:IsA("Frame") then
		TweenService:Create(child, fadeTweenInfo, {
			BackgroundTransparency = 1
		}):Play()

		local stroke = child:FindFirstChildOfClass("UIStroke")
		if stroke then
			TweenService:Create(stroke, fadeTweenInfo, {
				Transparency = 1
			}):Play()
		end
	end
end

task.wait(0.6)

LoadingGui:Destroy()

----------------------------------------------------
-- MAIN GUI
----------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AfnanSakhaHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

----------------------------------------------------
-- LOGIKA VARIABEL UTAMA FITUR LOCK
----------------------------------------------------
local circleEnabled = false
local shootLockEnabled = false
local dontLockTeammate = false

local circleRadius = 100
local targetBodyPart = "Head"

local shootLockActiveUntil = 0
local currentShootLockTarget = nil

-- Tabel pelacak koordinat sentuhan mobile (Untuk memisahkan geser kamera vs klik)
local activeTouches = {}

-- Objek UI Lingkaran
local TargetCircle = Instance.new("Frame")
TargetCircle.Name = "AfnanSakhaTargetCircle"
TargetCircle.AnchorPoint = Vector2.new(0.5, 0.5)
TargetCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
TargetCircle.BackgroundTransparency = 1
TargetCircle.Size = UDim2.new(0, circleRadius * 2, 0, circleRadius * 2)
TargetCircle.Visible = false
TargetCircle.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = TargetCircle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 230, 255)
CircleStroke.Thickness = 1.5
CircleStroke.Parent = TargetCircle

local function UpdateCircleVisual()
	TargetCircle.Size = UDim2.new(0, circleRadius * 2, 0, circleRadius * 2)
end

----------------------------------------------------
-- MAIN PANEL
----------------------------------------------------
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

----------------------------------------------------
-- TITLE
----------------------------------------------------
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

----------------------------------------------------
-- CLOSE BUTTON
----------------------------------------------------
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

----------------------------------------------------
-- TABS
----------------------------------------------------
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

----------------------------------------------------
-- SCRIPT LIST
----------------------------------------------------
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1,-30,0,230)
ScrollList.Position = UDim2.new(0,15,0,95)
ScrollList.BackgroundTransparency = 1
ScrollList.CanvasSize = UDim2.new(0,0,0,330)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(0,180,255)
ScrollList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ScrollList

----------------------------------------------------
-- 1 FUNGSI ADAPTIF KONTROL TOMBOL & KUSTOMISASI
----------------------------------------------------
local function CreateScriptRow(rowType, name, configData)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1,-10,0,45)
	Row.BackgroundColor3 = Color3.fromRGB(18,32,55)
	Row.Parent = ScrollList

	Instance.new("UICorner", Row).CornerRadius = UDim.new(0,8)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0,100,180)
	Stroke.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.55,0,1,0)
	Label.Position = UDim2.new(0,15,0,0)
	Label.BackgroundTransparency = 1
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(240,245,255)
	Label.TextSize = 15
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	if rowType == "Toggle" then
		Label.Text = name .. " (OFF)"
		
		local ToggleBtn = Instance.new("TextButton")
		ToggleBtn.Size = UDim2.new(0,55,0,26)
		ToggleBtn.Position = UDim2.new(1,-70,0.5,-13)
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

		local isOn = false
		ToggleBtn.MouseButton1Click:Connect(function()
			isOn = not isOn
			Label.Text = name .. (isOn and " (ON)" or " (OFF)")

			local targetPos = isOn and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)
			local targetColor = isOn and Color3.fromRGB(0,180,255) or Color3.fromRGB(35,50,75)

			TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
			TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

			configData.Callback(isOn)
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

----------------------------------------------------
-- PENYUSUNAN DAFTAR MENU MENGGUNAKAN 1 FUNGSI DI ATAS
----------------------------------------------------
CreateScriptRow("Toggle", "Circle Lock-On", {
	Callback = function(isOn)
		circleEnabled = isOn
		TargetCircle.Visible = isOn
	end
})

CreateScriptRow("Toggle", "Shoot Lock", {
	Callback = function(isOn)
		shootLockEnabled = isOn
		if not isOn then shootLockActiveUntil = 0 end
	end
})

CreateScriptRow("Toggle", "Don't Lock to Teammate", {
	Callback = function(isOn)
		dontLockTeammate = isOn
	end
})

CreateScriptRow("TextBox", "Circle Radius", {
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

local colorPresets = {
	["Cyan Neon"] = Color3.fromRGB(0, 230, 255),
	["Merah"] = Color3.fromRGB(255, 50, 50),
	["Hijau"] = Color3.fromRGB(50, 255, 50),
	["Kuning"] = Color3.fromRGB(255, 255, 50)
}
CreateScriptRow("Cycle", "Circle Color", {
	List = {"Cyan Neon", "Merah", "Hijau", "Kuning"},
	Callback = function(selectedOption)
		CircleStroke.Color = colorPresets[selectedOption]
	end
})

CreateScriptRow("Cycle", "Camera Target", {
	List = {"Head", "Torso"},
	Callback = function(selectedOption)
		targetBodyPart = selectedOption
	end
})

----------------------------------------------------
-- LOGIKA UTAMA PENCARI TARGET (TERDEKAT DARI TENGAH LAYAR)
----------------------------------------------------
local function GetClosestTarget(maxDistance)
	local closestTarget = nil
	local shortestDistance = maxDistance or math.huge
	local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			
			if dontLockTeammate and player.Team == LocalPlayer.Team then
				continue
			end
			
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				local rootPart = player.Character.HumanoidRootPart
				local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

				if onScreen then
					local playerCoord = Vector2.new(screenPos.X, screenPos.Y)
					local distance = (playerCoord - screenCenter).Magnitude

					if distance < shortestDistance then
						shortestDistance = distance
						closestTarget = rootPart
					end
				end
			end
		end
	end
	return closestTarget
end

----------------------------------------------------
-- PERBAIKAN LOGIKA DETEKSI TOMBOL MOBILE & PC (FIX SWIPE LALU LOCK)
----------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not shootLockEnabled then return end

	-- A. DETEKSI UNTUK PEMAIN PC (Tetap di InputBegan karena menggunakan keyboard)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key ~= Enum.KeyCode.W and key ~= Enum.KeyCode.A and key ~= Enum.KeyCode.S and key ~= Enum.KeyCode.D and key ~= Enum.KeyCode.Space and key ~= Enum.KeyCode.Unknown then
			local target = GetClosestTarget()
			if target then
				currentShootLockTarget = target
				shootLockActiveUntil = os.clock() + 0.5
			end
		end

	-- B. MOBILE: CATAT KOORDINAT AWAL SAAT JARI MENYENTUH LAYAR
	elseif input.UserInputType == Enum.UserInputType.Touch then
		activeTouches[input] = {
			StartPosition = input.Position,
			StartTime = os.clock()
		}
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not shootLockEnabled then return end

	-- C. MOBILE ELEMEN PENENTU: Evaluasi sentuhan saat jari dilepas (InputEnded)
	if input.UserInputType == Enum.UserInputType.Touch then
		local touchData = activeTouches[input]
		if touchData then
			local startPos = touchData.StartPosition
			local endPos = input.Position
			local duration = os.clock() - touchData.StartTime
			
			-- Menghitung jarak pergeseran jari (Magnitude delta)
			local distanceMoved = (Vector2.new(endPos.X, endPos.Y) - Vector2.new(startPos.X, startPos.Y)).Magnitude
			
			-- Hapus data dari memori untuk mencegah memory leak
			activeTouches[input] = nil 

			-- VALIDASI SEBAGAI KLIK/TAP: Durasi sangat singkat (< 0.25 dtk) & Jari hampir tidak bergeser (< 15 piksel)
			if duration < 0.25 and distanceMoved < 15 then
				local screenSize = Camera.ViewportSize

				-- Filter area analog kiri dan tombol lompat kanan bawah
				local isJumpZone = (startPos.X > screenSize.X * 0.65 and startPos.Y > screenSize.Y * 0.55)
				local isMoveZone = (startPos.X < screenSize.X * 0.35 and startPos.Y > screenSize.Y * 0.5)

				-- Jika klik terjadi di luar analog/lompat (Berarti menekan tombol skill/tembak/layar)
				if not (isJumpZone or isMoveZone) then
					local target = GetClosestTarget()
					if target then
						currentShootLockTarget = target
						shootLockActiveUntil = os.clock() + 0.5
					end
				end
			end
		end
	end
end)

----------------------------------------------------
-- EXECUTION LOOP (RENDER STEPPED KAMERA)
----------------------------------------------------
RunService.RenderStepped:Connect(function()
	local finalTargetRoot = nil

	if shootLockEnabled and os.clock() < shootLockActiveUntil and currentShootLockTarget and currentShootLockTarget.Parent then
		local humanoid = currentShootLockTarget.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			finalTargetRoot = currentShootLockTarget
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
end)

----------------------------------------------------
-- EXECUTE BUTTON
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

----------------------------------------------------
-- PASTEBIN BUTTON
----------------------------------------------------
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

----------------------------------------------------
-- ROUND TOGGLE BUTTON
----------------------------------------------------
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

----------------------------------------------------
-- OPEN / CLOSE SYSTEM
----------------------------------------------------
CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	RoundToggleBtn.Visible = true
end)

RoundToggleBtn.MouseButton1Click:Connect(function()
	RoundToggleBtn.Visible = false
	MainFrame.Visible = true
end)

----------------------------------------------------
-- DRAGGABLE SYSTEM
----------------------------------------------------
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

----------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------
MainFrame.Size = UDim2.new(0,0,0,0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0,550,0,400)}):Play()