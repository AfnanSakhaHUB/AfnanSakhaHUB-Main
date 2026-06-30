--// AFNANSAKHA HUB LOADER + MAIN GUI (FULLY FIXED & OPTIMIZED ESP SYSTEM)
--// Tempatkan di: StarterGui -> LocalScript atau langsung jalankan di Executor

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera


---

-- AUTO CLEANUP

local oldUI1 = PlayerGui:FindFirstChild("AfnanSakhaLoadingScreen")
if oldUI1 then oldUI1:Destroy() end

local oldUI2 = PlayerGui:FindFirstChild("AfnanSakhaHubUI")
if oldUI2 then oldUI2:Destroy() end


---

-- STATE CONFIGURATIONS & COLOR CONTROLS

local OutlineEnabled = false
local BoxesEnabled = false
local TracersEnabled = false
local NameESPEnabled = false
local HealthESPEnabled = false

-- Color Customizations
local OutlineColor = Color3.fromRGB(0, 230, 255)
local BoxColor = Color3.fromRGB(0, 230, 255)
local TracerColor = Color3.fromRGB(0, 230, 255)
local NameColor = Color3.fromRGB(255, 255, 255)

-- Team Color Mode Flags (True = Ikut warna tim, False = Pakai warna kustom)
local OutlineUseTeam = true
local BoxUseTeam = true
local TracerUseTeam = true
local NameUseTeam = true

local TeamColors = {
Color3.fromRGB(0, 120, 255),   -- Tim 1: Biru
Color3.fromRGB(255, 40, 40),   -- Tim 2: Merah
Color3.fromRGB(40, 255, 40),   -- Tim 3: Hijau
Color3.fromRGB(255, 230, 0),   -- Tim 4: Kuning
Color3.fromRGB(180, 40, 255),  -- Tim 5: Ungu
Color3.fromRGB(255, 255, 255), -- Tim 6: Putih
Color3.fromRGB(25, 25, 25),    -- Tim 7: Hitam (FIXED: Typo 25' dibuang)
}

local function getPlayerTeamColor(player)
if player.Team then
local currentTeams = Teams:GetTeams()
table.sort(currentTeams, function(a, b) return a.Name < b.Name end)
local idx = table.find(currentTeams, player.Team)
if idx then
return TeamColors[((idx - 1) % #TeamColors) + 1]
end
end
return Color3.fromRGB(170, 170, 170) -- Default color
end

local function GetActiveColor(player, feature)
if feature == "Outline" then
return OutlineUseTeam and getPlayerTeamColor(player) or OutlineColor
elseif feature == "Box" then
return BoxUseTeam and getPlayerTeamColor(player) or BoxColor
elseif feature == "Tracer" then
return TracerUseTeam and getPlayerTeamColor(player) or TracerColor
elseif feature == "Name" then
return NameUseTeam and getPlayerTeamColor(player) or NameColor
end
return Color3.fromRGB(255,255,255)
end


---

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


---

-- MAIN GUI BUILDER

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
ScrollList.CanvasSize = UDim2.new(0,0,0,420)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(0,180,255)
ScrollList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ScrollList

local TracerFolder = Instance.new("Folder", ScreenGui)
TracerFolder.Name = "TracerFolder"
local TracerFrames = {}


---

-- SYSTEM LOGIC: OUTLINES CONTROL

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


---

-- MULTI-FUNCTION BILLBOARD ESP ENGINE

local function SetupCharacter(character)
	local player = Players:GetPlayerFromCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	local hrp = character:WaitForChild("HumanoidRootPart", 5)
	
	if not humanoid or not hrp or not player or player == LocalPlayer then return end

	-- Bersihkan jika ada sisa ESP lama
	local oldBox = hrp:FindFirstChild("PlayerBoxESP")
	if oldBox then oldBox:Destroy() end

	-- Master Billboard Gui
	local boxBillboard = Instance.new("BillboardGui")
	boxBillboard.Name = "PlayerBoxESP"
	boxBillboard.Adornee = hrp
	boxBillboard.Size = UDim2.new(4, 0, 5, 0)
	boxBillboard.StudsOffset = Vector3.new(0, 0.5, 0)
	boxBillboard.AlwaysOnTop = true
	boxBillboard.Enabled = (BoxesEnabled or NameESPEnabled or HealthESPEnabled)
	boxBillboard.Parent = hrp

	-- 1. Bounding Box Frame
	local boxFrame = Instance.new("Frame")
	boxFrame.Name = "BoxFrame"
	boxFrame.Size = UDim2.new(1, 0, 1, 0)
	boxFrame.BackgroundTransparency = 1
	boxFrame.Visible = BoxesEnabled
	boxFrame.Parent = boxBillboard

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = GetActiveColor(player, "Box")
	boxStroke.Thickness = 2
	boxStroke.Parent = boxFrame

	-- 2. Name ESP Frame (SUSUNAN & SCALE MILIKMU)  
	local nameLabel = Instance.new("TextLabel")  
	nameLabel.Name = "NameLabel"  
	nameLabel.Size = UDim2.new(1, 0, 0.1, 0)       -- Menggunakan Scale  
	nameLabel.Position = UDim2.new(0, 0, -0.12, 0)  -- Menggunakan Scale agar pas di atas kepala  
	nameLabel.BackgroundTransparency = 1  
	nameLabel.Text = player.Name  
	nameLabel.TextColor3 = GetActiveColor(player, "Name")  
	nameLabel.TextSize = 13  
	nameLabel.Font = Enum.Font.GothamBold  
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center -- Diubah ke Center agar lebih rapi  
	nameLabel.TextStrokeTransparency = 0  
	nameLabel.Visible = NameESPEnabled  
	nameLabel.Parent = boxBillboard  

	-- 3. Side Vertical Health ESP Bar Background (SUSUNAN & SCALE MILIKMU)  
	local healthBarBG = Instance.new("Frame")  
	healthBarBG.Name = "HealthBarBG"  
	healthBarBG.Size = UDim2.new(0.06, 0, 1, 0)      -- Menggunakan Scale (6% dari lebar kotak)  
	healthBarBG.Position = UDim2.new(-0.09, 0, 0, 0)  -- Menggunakan Scale (Digeser rapi ke kiri kotak)  
	healthBarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
	healthBarBG.BorderSizePixel = 0  
	healthBarBG.Visible = HealthESPEnabled  
	healthBarBG.Parent = boxBillboard

	-- ========================================================
	-- ISI BAR DARAH (Wajib ada di dalam healthBarBG agar warna darahnya muncul)
	-- ========================================================
	local healthBarFill = Instance.new("Frame")
	healthBarFill.Name = "HealthBarFill"
	healthBarFill.Size = UDim2.new(1, 0, math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), 0)
	healthBarFill.AnchorPoint = Vector2.new(0, 1) -- Pengurangan dari atas ke bawah
	healthBarFill.Position = UDim2.new(0, 0, 1, 0)
	healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	healthBarFill.BorderSizePixel = 0
	healthBarFill.Parent = healthBarBG

	-- UPDATE ISI DARAH SECARA REALTIME SAAT MUSUH SEKARAT
	humanoid.HealthChanged:Connect(function()
		local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
		healthBarFill.Size = UDim2.new(1, 0, hpPercent, 0)
		-- Transisi warna: Hijau (Sehat) -> Kuning -> Merah (Sekarat)
		healthBarFill.BackgroundColor3 = Color3.fromRGB(255, 30, 30):Lerp(Color3.fromRGB(30, 255, 30), hpPercent)
	end)
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


---

-- MAIN CORE RENDER LOOP

RunService.RenderStepped:Connect(function()
	Camera = workspace.CurrentCamera
	local viewportSize = Camera.ViewportSize
	local startPos = Vector2.new(viewportSize.X / 2, viewportSize.Y)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local character = player.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChild("Humanoid")

			--------------------------------------------------
			-- BILLBOARD ESP UPDATE
			--------------------------------------------------
			if hrp and humanoid then
				local boxESP = hrp:FindFirstChild("PlayerBoxESP")

				if boxESP then
					boxESP.Enabled = (BoxesEnabled or NameESPEnabled or HealthESPEnabled)

					-- BOX
					local boxFrame = boxESP:FindFirstChild("BoxFrame")
					if boxFrame then
						boxFrame.Visible = BoxesEnabled

						local stroke = boxFrame:FindFirstChildOfClass("UIStroke")
						if stroke then
							stroke.Color = GetActiveColor(player, "Box")
						end
					end

					-- NAME
					local nameLabel = boxESP:FindFirstChild("NameLabel")
					if nameLabel then
						nameLabel.Visible = NameESPEnabled
						nameLabel.Text = player.Name
						nameLabel.TextColor3 = GetActiveColor(player, "Name")
					end

					-- HEALTH
					local healthBG = boxESP:FindFirstChild("HealthBarBG")
					if healthBG then
						healthBG.Visible = HealthESPEnabled

						local fill = healthBG:FindFirstChild("HealthBarFill")
						if fill then
							local hp = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)

							fill.Size = UDim2.new(1,0,hp,0)
							fill.Position = UDim2.new(0,0,1,0)
							fill.AnchorPoint = Vector2.new(0,1)

							fill.BackgroundColor3 =
								Color3.fromRGB(255,30,30):Lerp(
									Color3.fromRGB(30,255,30),
									hp
								)
						end
					end
				end
			end

			--------------------------------------------------
			-- TRACER
			--------------------------------------------------
			if TracersEnabled and hrp and humanoid and humanoid.Health > 0 then
				local screenPos = Camera:WorldToViewportPoint(hrp.Position)

				local padding = 15
				local endPos = Vector2.new(
					math.clamp(screenPos.X, padding, viewportSize.X - padding),
					math.clamp(screenPos.Y, padding, viewportSize.Y - padding)
				)

				local frame = TracerFrames[player]

				if not frame then
					frame = Instance.new("Frame")
					frame.BorderSizePixel = 0
					frame.AnchorPoint = Vector2.new(0.5,0.5)
					frame.Parent = TracerFolder
					TracerFrames[player] = frame
				end

				local distance = (endPos - startPos).Magnitude

				frame.Size = UDim2.new(0,distance,0,2)
				frame.Position = UDim2.new(
					0,(startPos.X + endPos.X)/2,
					0,(startPos.Y + endPos.Y)/2
				)

				frame.Rotation = math.deg(math.atan2(
					endPos.Y - startPos.Y,
					endPos.X - startPos.X
				))

				frame.BackgroundColor3 = GetActiveColor(player,"Tracer")
				frame.Visible = true
			else
				if TracerFrames[player] then
					TracerFrames[player].Visible = false
				end
			end

			--------------------------------------------------
			-- OUTLINE
			--------------------------------------------------
			if character and OutlineEnabled then
				local hl = character:FindFirstChild("PlayerOutline")
				if hl then
					hl.OutlineColor = GetActiveColor(player,"Outline")
				end
			end
		end
	end
end)

---

-- COMPONENT: DYNAMIC DROPDOWN INTERFACE ROW SYSTEM

local function CreateScriptRow(name, defaultState)
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
Label.Size = UDim2.new(0.7,0,0,45)  
Label.Position = UDim2.new(0,15,0,0)  
Label.BackgroundTransparency = 1  
Label.Text = name .. (defaultState and " (ON)" or " (OFF)")  
Label.TextColor3 = Color3.fromRGB(240,245,255)  
Label.TextSize = 15  
Label.Font = Enum.Font.GothamMedium  
Label.TextXAlignment = Enum.TextXAlignment.Left  
Label.Parent = Row  

local ToggleBtn = Instance.new("TextButton")  
ToggleBtn.Size = UDim2.new(0,55,0,26)  
ToggleBtn.Position = UDim2.new(1,-70,0,9)  
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

-- COLOR CONTAINER (Hanya dibuat untuk modul yang membutuhkan modifikasi warna kustom)  
local ColorContainer  
if name ~= "Side Health ESP" then  
	ColorContainer = Instance.new("Frame")  
	ColorContainer.Size = UDim2.new(1, 0, 0, 40)  
	ColorContainer.Position = UDim2.new(0, 0, 0, 45)  
	ColorContainer.BackgroundTransparency = 1  
	ColorContainer.Visible = defaultState  
	ColorContainer.Parent = Row  

	local ColorLabel = Instance.new("TextLabel")  
	ColorLabel.Size = UDim2.new(0, 90, 1, 0)  
	ColorLabel.Position = UDim2.new(0, 15, 0, 0)  
	ColorLabel.BackgroundTransparency = 1  
	ColorLabel.Text = "Warna ESP:"  
	ColorLabel.TextColor3 = Color3.fromRGB(150, 180, 210)  
	ColorLabel.TextSize = 13  
	ColorLabel.Font = Enum.Font.GothamMedium  
	ColorLabel.TextXAlignment = Enum.TextXAlignment.Left  
	ColorLabel.Parent = ColorContainer  

	local ColorsFrame = Instance.new("Frame")  
	ColorsFrame.Size = UDim2.new(1, -115, 1, 0)  
	ColorsFrame.Position = UDim2.new(0, 105, 0, 0)  
	ColorsFrame.BackgroundTransparency = 1  
	ColorsFrame.Parent = ColorContainer  

	local ColorsLayout = Instance.new("UIListLayout")  
	ColorsLayout.FillDirection = Enum.FillDirection.Horizontal  
	ColorsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left  
	ColorsLayout.VerticalAlignment = Enum.VerticalAlignment.Center  
	ColorsLayout.Padding = UDim.new(0, 6)  
	ColorsLayout.Parent = ColorsFrame  

	-- Tombol Khusus "TEAM" untuk mode penyesuaian tim dinamis  
	local TeamToggleBtn = Instance.new("TextButton")  
	TeamToggleBtn.Size = UDim2.new(0, 48, 0, 22)  
	TeamToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)  
	TeamToggleBtn.Text = "TEAM"  
	TeamToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)  
	TeamToggleBtn.Font = Enum.Font.GothamBold  
	TeamToggleBtn.TextSize = 10  
	TeamToggleBtn.Parent = ColorsFrame  
	Instance.new("UICorner", TeamToggleBtn).CornerRadius = UDim.new(0, 4)  

	TeamToggleBtn.MouseButton1Click:Connect(function()  
		if name == "Player Outline" then OutlineUseTeam = true  
		elseif name == "Team Box ESP" then BoxUseTeam = true  
		elseif name == "Team Tracer ESP" then TracerUseTeam = true  
		elseif name == "Team Name ESP" then NameUseTeam = true end  
		if OutlineEnabled then UpdatePlayerOutlines() end  
	end)  

	local colorPresets = {  
		Color3.fromRGB(0, 230, 255),   -- Cyan  
		Color3.fromRGB(255, 30, 30),   -- Merah  
		Color3.fromRGB(30, 255, 30),   -- Hijau  
		Color3.fromRGB(255, 255, 30),  -- Kuning  
		Color3.fromRGB(255, 255, 255)  -- Putih  
	}  

	for _, color in ipairs(colorPresets) do  
		local ColorBtn = Instance.new("TextButton")  
		ColorBtn.Size = UDim2.new(0, 22, 0, 22)  
		ColorBtn.BackgroundColor3 = color  
		ColorBtn.Text = ""  
		ColorBtn.Parent = ColorsFrame  
		Instance.new("UICorner", ColorBtn).CornerRadius = UDim.new(1, 0)  

		ColorBtn.MouseButton1Click:Connect(function()  
			if name == "Player Outline" then OutlineUseTeam = false OutlineColor = color  
			elseif name == "Team Box ESP" then BoxUseTeam = false BoxColor = color  
			elseif name == "Team Tracer ESP" then TracerUseTeam = false TracerColor = color  
			elseif name == "Team Name ESP" then NameUseTeam = false NameColor = color end  
			if OutlineEnabled then UpdatePlayerOutlines() end  
		end)  
	end  
end  

local isOn = defaultState  
ToggleBtn.MouseButton1Click:Connect(function()  
	isOn = not isOn  
	Label.Text = name .. (isOn and " (ON)" or " (OFF)")  

	local targetPos = isOn and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)  
	local targetColor = isOn and Color3.fromRGB(0,180,255) or Color3.fromRGB(35,50,75)  

	TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()  
	TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()  

	local targetRowHeight = (isOn and name ~= "Side Health ESP") and 85 or 45  
	TweenService:Create(Row, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, targetRowHeight)}):Play()  
	if ColorContainer then ColorContainer.Visible = isOn end  

	if name == "Player Outline" then  
		OutlineEnabled = isOn  
		UpdatePlayerOutlines()  
	elseif name == "Team Box ESP" then  
		BoxesEnabled = isOn  
	elseif name == "Team Tracer ESP" then  
		TracersEnabled = isOn  
		if not isOn then for _, f in pairs(TracerFrames) do f.Visible = false end end  
	elseif name == "Team Name ESP" then  
		NameESPEnabled = isOn  
	elseif name == "Side Health ESP" then  
		HealthESPEnabled = isOn  
	end  
end)

end

CreateScriptRow("Player Outline", false)
CreateScriptRow("Team Box ESP", false)
CreateScriptRow("Team Tracer ESP", false)
CreateScriptRow("Team Name ESP", false)
CreateScriptRow("Side Health ESP", false)


---

-- INTERFACE CORE ACTIONS & DRAG REGISTRATION

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
