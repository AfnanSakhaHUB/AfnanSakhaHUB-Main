--// AFNANSAKHA HUB LOADER + MAIN GUI WITH UI IDENTIFIER
--// Tempatkan di: StarterGui -> LocalScript
--// Nama File: AfnanSakhaHub_UIIdentifier.lua

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
Background.Parent = LoadingGui

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

	Tab.BackgroundColor3 =
		posIdx == 1
		and Color3.fromRGB(15,45,80)
		or Color3.fromRGB(15,30,50)

	Tab.Text = name

	Tab.TextColor3 =
		posIdx == 1
		and Color3.fromRGB(0,230,255)
		or Color3.fromRGB(150,180,210)

	Tab.TextSize = 14
	Tab.Font = Enum.Font.GothamBold
	Tab.Parent = TabContainer

	Instance.new("UICorner", Tab).CornerRadius = UDim.new(0,6)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color =
		posIdx == 1
		and Color3.fromRGB(0,180,255)
		or Color3.fromRGB(0,90,150)

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
ScrollList.CanvasSize = UDim2.new(0,0,0,350)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(0,180,255)
ScrollList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ScrollList

----------------------------------------------------
-- NEW: CODE VIEWER UI (Layar Hitam Tulisan Putih)
----------------------------------------------------
local CodeViewerFrame = Instance.new("Frame")
CodeViewerFrame.Name = "CodeViewerFrame"
CodeViewerFrame.Size = UDim2.new(0, 320, 0, 400)
CodeViewerFrame.Position = UDim2.new(0.5, 285, 0.5, -200) -- Sebelah kanan AfnanSakha HUB
CodeViewerFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
CodeViewerFrame.BackgroundTransparency = 0.05
CodeViewerFrame.Visible = false
CodeViewerFrame.Parent = ScreenGui

Instance.new("UICorner", CodeViewerFrame).CornerRadius = UDim.new(0, 10)

local CodeStroke = Instance.new("UIStroke")
CodeStroke.Color = Color3.fromRGB(255, 255, 255)
CodeStroke.Thickness = 1
CodeStroke.Parent = CodeViewerFrame

local CodeTitle = Instance.new("TextLabel")
CodeTitle.Size = UDim2.new(1, -40, 0, 30)
CodeTitle.Position = UDim2.new(0, 12, 0, 5)
CodeTitle.BackgroundTransparency = 1
CodeTitle.Text = "GUI SCRIPT IDENTIFIER"
CodeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeTitle.TextSize = 14
CodeTitle.Font = Enum.Font.GothamBold
CodeTitle.TextXAlignment = Enum.TextXAlignment.Left
CodeTitle.Parent = CodeViewerFrame

local CodeCloseBtn = Instance.new("TextButton")
CodeCloseBtn.Size = UDim2.new(0, 20, 0, 20)
CodeCloseBtn.Position = UDim2.new(1, -30, 0, 7)
CodeCloseBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
CodeCloseBtn.Text = "X"
CodeCloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CodeCloseBtn.TextSize = 12
CodeCloseBtn.Font = Enum.Font.GothamBold
CodeCloseBtn.Parent = CodeViewerFrame
Instance.new("UICorner", CodeCloseBtn).CornerRadius = UDim.new(0, 4)

local CodeScroll = Instance.new("ScrollingFrame")
CodeScroll.Size = UDim2.new(1, -20, 1, -50)
CodeScroll.Position = UDim2.new(0, 10, 0, 40)
CodeScroll.BackgroundTransparency = 1
CodeScroll.ScrollBarThickness = 5
CodeScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
CodeScroll.Parent = CodeViewerFrame

local CodeText = Instance.new("TextLabel")
CodeText.Size = UDim2.new(1, -10, 0, 0)
CodeText.AutomaticSize = Enum.AutomaticSize.Y
CodeText.BackgroundTransparency = 1
CodeText.Text = "-- Klik UI manapun untuk generate code..."
CodeText.TextColor3 = Color3.fromRGB(240, 240, 240)
CodeText.TextSize = 12
CodeText.Font = Enum.Font.Code
CodeText.TextXAlignment = Enum.TextXAlignment.Left
CodeText.TextYAlignment = Enum.TextYAlignment.Top
CodeText.Parent = CodeScroll

CodeCloseBtn.MouseButton1Click:Connect(function()
	CodeViewerFrame.Visible = false
end)

----------------------------------------------------
-- SCRIPT ROW SYSTEM
----------------------------------------------------
_G.EspBendaDekatActive = false -- Status Global ESP
_G.UIIdentifierActive = false   -- Status Global UI Identifier

local function CreateScriptRow(name, defaultState)

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1,-10,0,45)
	Row.BackgroundColor3 = Color3.fromRGB(18,32,55)
	Row.Parent = ScrollList

	Instance.new("UICorner", Row).CornerRadius = UDim.new(0,8)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0,100,180)
	Stroke.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7,0,1,0)
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
	ToggleBtn.Position = UDim2.new(1,-70,0.5,-13)
	ToggleBtn.BackgroundColor3 =
		defaultState
		and Color3.fromRGB(0,180,255)
		or Color3.fromRGB(35,50,75)

	ToggleBtn.Text = ""
	ToggleBtn.Parent = Row

	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0.5,0)

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0,20,0,20)

	Circle.Position =
		defaultState
		and UDim2.new(1,-23,0.5,-10)
		or UDim2.new(0,3,0.5,-10)

	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.Parent = ToggleBtn

	Instance.new("UICorner", Circle).CornerRadius = UDim.new(0.5,0)

	local isOn = defaultState

	ToggleBtn.MouseButton1Click:Connect(function()

		isOn = not isOn

		Label.Text =
			name .. (isOn and " (ON)" or " (OFF)")

		local targetPos =
			isOn
			and UDim2.new(1,-23,0.5,-10)
			or UDim2.new(0,3,0.5,-10)

		local targetColor =
			isOn
			and Color3.fromRGB(0,180,255)
			or Color3.fromRGB(35,50,75)

		TweenService:Create(
			Circle,
			TweenInfo.new(0.2),
			{Position = targetPos}
		):Play()

		TweenService:Create(
			ToggleBtn,
			TweenInfo.new(0.2),
			{BackgroundColor3 = targetColor}
		):Play()

		-- PENGAKTIFAN FITUR
		if name == "Detector ESP (Radius 5)" then
			_G.EspBendaDekatActive = isOn
		elseif name == "UI Identifier" then
			_G.UIIdentifierActive = isOn
			if not isOn then
				CodeViewerFrame.Visible = false
			end
		end
	end)
end

elseif name == "Speed Monitor" then
    _G.SpeedMonitorActive = isOn
    
    if isOn then
        local RunService = game:GetService("RunService")
        
        -- Loop ringan menggunakan Heartbeat (berjalan di setiap frame fisika)
        task.spawn(function()
            while _G.SpeedMonitorActive do
                local mySpeed = ambilKecepatan(LocalPlayer)
                
                -- Cari tahu juga setelan WalkSpeed asli dari game untuk perbandingan
                local maxWalkSpeed = 0
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    maxWalkSpeed = math.round(LocalPlayer.Character.Humanoid.WalkSpeed)
                end
                
                -- Mengubah teks label row UI kamu secara real-time
                -- Catatan: Sesuaikan 'Label' dengan nama variabel teks pada fungsi CreateScriptRow kamu
                Label.Text = string.format("Speed Monitor [Real: %d | Max: %d]", mySpeed, maxWalkSpeed)
                
                task.wait(0.1) -- Di-refresh setiap 0.1 detik agar tidak lag dan tetap responsif
            end
        end)
    else
        -- Jika dimatikan, kembalikan teks ke nama semula
        Label.Text = "Speed Monitor (OFF)"
    end

-- Menambahkan Fitur Ke Daftar Hub
CreateScriptRow("Detector ESP (Radius 5)", false)
CreateScriptRow("UI Identifier", false)
CreateScriptRow("Speed Monitor", false)

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
ExecGradient.Color = ColorSequence.new(
	Color3.fromRGB(0,100,220),
	Color3.fromRGB(0,150,255)
)
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
	CodeViewerFrame.Visible = false
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

	local dragging
	local dragInput
	local dragStart
	local startPos

	uiElement.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = uiElement.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	uiElement.InputChanged:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if input == dragInput and dragging then

			local delta = input.Position - dragStart

			uiElement.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			
			-- Ikuti pergeseran jika CodeViewer terbuka agar tetap berada di samping
			if uiElement == MainFrame then
				CodeViewerFrame.Position = UDim2.new(
					MainFrame.Position.X.Scale, 
					MainFrame.Position.X.Offset + MainFrame.Size.X.Offset + 15, 
					MainFrame.Position.Y.Scale, 
					MainFrame.Position.Y.Offset
				)
			elseif uiElement == RoundToggleBtn then
				CodeViewerFrame.Position = UDim2.new(
					RoundToggleBtn.Position.X.Scale, 
					RoundToggleBtn.Position.X.Offset + RoundToggleBtn.Size.X.Offset + 15, 
					RoundToggleBtn.Position.Y.Scale, 
					RoundToggleBtn.Position.Y.Offset
				)
			end
		end
	end)
end

MakeDraggable(MainFrame)
MakeDraggable(RoundToggleBtn)

----------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------
MainFrame.Size = UDim2.new(0,0,0,0)

TweenService:Create(
	MainFrame,
	TweenInfo.new(0.4, Enum.EasingStyle.Back),
	{
		Size = UDim2.new(0,550,0,400)
	}
):Play()


----------------------------------------------------
-- LUA ENGINE: SYSTEM ESP DETECTOR OPTIMIZED (5 STUDS)
----------------------------------------------------
local function bersihkanESP(objek)
	local espLama = objek:FindFirstChild("AfnanSakha_Esp5Studs")
	if espLama then espLama:Destroy() end
end

local function buatTagESP(objek, partUtama, teks)
	local dataESP = objek:FindFirstChild("AfnanSakha_Esp5Studs")
	if dataESP then
		local bGui = dataESP:FindFirstChildOfClass("BillboardGui")
		if bGui and bGui:FindFirstChildOfClass("TextLabel") then
			bGui.TextLabel.Text = teks
		end
		return
	end

	local folderESP = Instance.new("Folder")
	folderESP.Name = "AfnanSakha_Esp5Studs"
	folderESP.Parent = objek

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "TagGui"
	billboard.Size = UDim2.new(0, 130, 0, 40)
	billboard.AlwaysOnTop = true
	billboard.Adornee = partUtama
	billboard.Parent = folderESP

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	textLabel.TextSize = 13
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Text = teks
	textLabel.Parent = billboard
end

task.spawn(function()
	while true do
		if _G.EspBendaDekatActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local rootPlayer = LocalPlayer.Character.HumanoidRootPart.Position

			for _, objek in ipairs(Workspace:GetDescendants()) do
				if not _G.EspBendaDekatActive then break end

				if (objek:IsA("Model") or objek:IsA("BasePart")) and not objek:IsDescendantOf(LocalPlayer.Character) then
					if objek.Name ~= "Terrain" and objek.Name ~= "Baseplate" then
						
						local partUtama = objek:IsA("Model") and (objek.PrimaryPart or objek:FindFirstChildWhichIsA("BasePart", true)) or objek
						if partUtama and partUtama:IsA("BasePart") then
							
							local jarak = (partUtama.Position - rootPlayer).Magnitude

							if jarak <= 5 then
								local isiTeks = "Nama: " .. objek.Name
								
								local prompt = objek:FindFirstChildOfClass("ProximityPrompt") or objek:FindFirstChildWhichIsA("ProximityPrompt", true)
								if prompt then
									isiTeks = isiTeks .. "\n[PC Key: " .. prompt.KeyboardKeyCode.Name .. "]"
								end
								
								buatTagESP(objek, partUtama, isiTeks)
							else
								bersihkanESP(objek)
							end
						end
					end
				end
			end
		else
			for _, objek in ipairs(Workspace:GetDescendants()) do
				bersihkanESP(objek)
			end
		end
		task.wait(0.15)
	end
end)


----------------------------------------------------
-- LUA ENGINE: UI IDENTIFIER CORE SYSTEM
----------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if _G.UIIdentifierActive and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		local x, y = input.Position.X, input.Position.Y
		local foundGuis = PlayerGui:GetGuiObjectsAtPosition(x, y)
		
		local targetGui = nil
		for _, gui in ipairs(foundGuis) do
			-- Abaikan UI buatan Hub kita sendiri biar ga bentrok
			if not gui:IsDescendantOf(ScreenGui) and not gui:IsDescendantOf(LoadingGui) then
				targetGui = gui
				break
			end
		end
		
		if targetGui then
			local path = targetGui:GetFullName()
			local className = targetGui.ClassName
			
			-- 1. Efek memunculkan Key PC / Info langsung di atas UI yang diklik (Fungsi Key PC simulator)
			local oldKeyTag = targetGui:FindFirstChild("AfnanKeyTag")
			if oldKeyTag then oldKeyTag:Destroy() end
			
			local keyTag = Instance.new("TextLabel")
			keyTag.Name = "AfnanKeyTag"
			keyTag.Size = UDim2.new(1, 0, 1, 0)
			keyTag.BackgroundTransparency = 0.3
			keyTag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			keyTag.TextColor3 = Color3.fromRGB(0, 255, 255)
			keyTag.TextSize = 14
			keyTag.Font = Enum.Font.GothamBold
			keyTag.Text = "[PC KEY: E / CLICKED]"
			keyTag.ZIndex = targetGui.ZIndex + 5
			keyTag.Parent = targetGui
			
			-- Hilangkan tag otomatis setelah 2 detik
			task.delay(2, function()
				if keyTag then keyTag:Destroy() end
			end)
			
			-- 2. Generate struktur kode lengkap untuk dimasukkan ke Code Viewer hitam-putih
			local scriptText = "--// AFNANSAKHA UI IDENTIFIER CODE RESULT //--\n"
			scriptText = scriptText .. "-- Object Path: " .. path .. "\n"
			scriptText = scriptText .. "-- Class Name: " .. className .. "\n\n"
			scriptText = scriptText .. "local TargetUI = " .. path .. "\n\n"
			
			if targetGui:IsA("TextButton") or targetGui:IsA("ImageButton") then
				scriptText = scriptText .. "-- Fungsi Trigger untuk Button Click\n"
				scriptText = scriptText .. "TargetUI.MouseButton1Click:Connect(function()\n"
				scriptText = scriptText .. "    print('Button " .. targetGui.Name .. " Sukses Dieksekusi!')\n"
				scriptText = scriptText .. "    -- Masukkan script custom kamu di bawah ini:\n\n"
				scriptText = scriptText .. "end)\n"
			elseif targetGui:IsA("TextBox") then
				scriptText = scriptText .. "-- Fungsi Trigger untuk Input TextBox\n"
				scriptText = scriptText .. "TargetUI.FocusLost:Connect(function(enterPressed)\n"
				scriptText = scriptText .. "    if enterPressed then\n"
				scriptText = scriptText .. "        print('User mengetik:', TargetUI.Text)\n"
				scriptText = scriptText .. "    end\n"
				scriptText = scriptText .. "end)\n"
			else
				scriptText = scriptText .. "-- Properti Standar Komponen GUI\n"
				scriptText = scriptText .. "TargetUI.Visible = true\n"
				scriptText = scriptText .. "TargetUI.BackgroundTransparency = 0\n"
			end
			
			-- Update isi teks pada Code Viewer hitam
			CodeText.Text = scriptText
			
			-- Mengatur posisi Code Viewer agar muncul tepat di sebelah UI Hub yang sedang aktif
			if MainFrame.Visible then
				CodeViewerFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + MainFrame.Size.X.Offset + 15, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
			else
				CodeViewerFrame.Position = UDim2.new(RoundToggleBtn.Position.X.Scale, RoundToggleBtn.Position.X.Offset + RoundToggleBtn.Size.X.Offset + 15, RoundToggleBtn.Position.Y.Scale, RoundToggleBtn.Position.Y.Offset)
			end
			
			CodeViewerFrame.Visible = true
		end
	end
end)
