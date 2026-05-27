--// UNIVERSAL AFNANSAKHA HUB (FULLY UNIVERSAL PROXIMITY/TASK AUTO-FARM)
--// Tempatkan di: StarterGui -> LocalScript atau langsung jalankan via Executor Anda

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------
-- SYSTEM CACHE KARAKTER UNIVERSAL (Anti Mati/Respawn)
----------------------------------------------------
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humPart = char:WaitForChild("HumanoidRootPart", 5)

LocalPlayer.CharacterAdded:Connect(function(newChar)
	char = newChar
	humPart = newChar:WaitForChild("HumanoidRootPart", 5)
	local hum = newChar:WaitForChild("Humanoid", 5)
	if hum then
		hum.UseJumpPower = true
	end
end)

----------------------------------------------------
-- AUTO CLEANUP UI LAMA
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

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(10,15,30)
Background.BorderSizePixel = 0
Background.Parent = LoadingGui

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0,500,0,150)
MainContainer.Position = UDim2.new(0.5,-250,0.5,-75)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = Background

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,0,0,30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Loading [AfnanSakha HUB - Npc Or Die]"
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

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(0,180,255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0.5,0)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1,0,0,30)
StatusLabel.Position = UDim2.new(0,0,0,95)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Menginisialisasi engine..."
StatusLabel.TextColor3 = Color3.fromRGB(200,220,255)
StatusLabel.TextSize = 22
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainContainer

task.wait(0.2)
for i = 1, 100 do
	local progress = i / 100
	TweenService:Create(BarFill, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(progress,0,1,0)}):Play()
	StatusLabel.Text = "Creating Npc Or Die Script: " .. i .. "%"
	task.wait(0.005)
end
LoadingGui:Destroy()

----------------------------------------------------
-- MAIN HUB INTERFACE
----------------------------------------------------
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
ExecTitle.Text = "AFNANSAKHA HUB v2 (Npc Or Die)"
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

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1,-30,0,265)
ScrollList.Position = UDim2.new(0,15,0,60)
ScrollList.BackgroundTransparency = 1
ScrollList.CanvasSize = UDim2.new(0,0,0,950)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(0,180,255)
ScrollList.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = ScrollList

----------------------------------------------------
-- UNIVERSAL SERVER HOP UTILITY FUNCTION
----------------------------------------------------
local function serverHop()
	local servers = {}
	local reqFunc = syn and syn.request or http and http.request or request or http_request
	if reqFunc then
		local req = reqFunc({
			Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
			Method = "GET"
		})
		if req.StatusCode == 200 then
			local body = HttpService:JSONDecode(req.Body)
			if body and body.data then
				for _, server in ipairs(body.data) do
					if server.playing < server.maxPlayers and server.id ~= game.JobId then
						table.insert(servers, server.id)
					end
				end
			end
		end
	end
	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
	end
end

----------------------------------------------------
-- LOGIC ROW TOGGLE & ACTION BUTTON
----------------------------------------------------
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
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = isOn and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)}):Play()
		TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = isOn and Color3.fromRGB(0,180,255) or Color3.fromRGB(35,50,75)}):Play()

		if name == "Super Speed" then
			if isOn then
				task.spawn(function()
					while isOn do if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 100 end task.wait() end
				end)
			else
				if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
			end

		elseif name == "Infinite Jump" then
			if isOn then
				task.spawn(function()
					while isOn do if char and char:FindFirstChild("Humanoid") then char.Humanoid.UseJumpPower = true char.Humanoid.JumpPower = 100 end task.wait() end
				end)
			else
				if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = 50 end
			end

		elseif name == "Cash Farm" then
			if isOn then
				task.spawn(function()
					while isOn do
						pcall(function()
							local collect = workspace:FindFirstChild("CollectableItems")
							if collect and humPart then
								for _, p in ipairs(collect:GetChildren()) do
									if not isOn then break end
									if not p:GetAttribute("CannotSee") and p:IsA("BasePart") then
										humPart.CFrame = p.CFrame
										task.wait(0.5)
										local humanoid = char:FindFirstChildWhichIsA("Humanoid")
										if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
									end
									task.wait(1)
								end
							end
						end)
						task.wait(0.5)
					end
				end)
			end

		elseif name == "Reset if Bag Full" then
			if isOn then
				task.spawn(function()
					while isOn do
						pcall(function()
							local timerGui = LocalPlayer.PlayerGui:FindFirstChild("Timer")
							local amt = timerGui and timerGui.Frame.Bags.CashBag.Bag.AmountCollected
							if amt and amt.Text == "FULL!" and LocalPlayer.Team and LocalPlayer.Team.Name == "Criminals" then
								local humanoid = char:FindFirstChildWhichIsA("Humanoid")
								if humanoid then humanoid.Health = 0 end
							end
						end)
						task.wait(1)
					end
				end)
			end

		elseif name == "Reset if Sheriff" then
			if isOn then
				task.spawn(function()
					while isOn do
						if LocalPlayer.Team and LocalPlayer.Team.Name == "Sheriffs" then
							local humanoid = char:FindFirstChildWhichIsA("Humanoid")
							if humanoid then humanoid.Health = 0 end
						end
						task.wait(1)
					end
				end)
			end

		elseif name == "Auto Server Hop" then
			if isOn then
				task.spawn(function()
					while isOn do
						if #Players:GetPlayers() <= 3 then
							serverHop()
						end
						task.wait(1)
					end
				end)
			end

		elseif name == "ESP" then
			if isOn then
				task.spawn(function()
					while isOn do
						for _, player in pairs(workspace:GetDescendants()) do
							if player:IsA("Model") and player:FindFirstChild("HumanoidRootPart") then
								if player:FindFirstChild("HumanoidRootPart").CollisionGroup == "Player" and player ~= char then
									local playerObject = Players:GetPlayerFromCharacter(player)
									if playerObject and playerObject.Team and playerObject.Team.Name == "Sheriffs" then
										if player:FindFirstChild("ESP") then
											player:FindFirstChild("ESP").Color3 = Color3.new(0, 0, 1)
										else
											local box = Instance.new("BoxHandleAdornment", player)
											box.Name = "ESP"
											box.Adornee = player
											box.AlwaysOnTop = true
											box.Size = Vector3.new(4, 5, 1)
											box.ZIndex = 0
											box.Transparency = 0.3
											box.Color3 = Color3.new(0, 0, 1)
										end
									else
										if not player:FindFirstChild("ESP") then
											local box = Instance.new("BoxHandleAdornment", player)
											box.Name = "ESP"
											box.Adornee = player
											box.AlwaysOnTop = true
											box.Size = Vector3.new(4, 5, 1)
											box.ZIndex = 0
											box.Transparency = 0.3
											box.Color3 = Color3.new(0, 1, 0)
										end
									end
								end
							end
						end
						task.wait(1)
					end
				end)
			else
				for _, e in pairs(workspace:GetDescendants()) do
					if e.Name == "ESP" then e:Destroy() end
				end
			end

				elseif name == "Auto Complete Obby" then
			if isOn then
				task.spawn(function()
					local cooldown = 0 -- Timer internal untuk fallback 5.5 menit
					while isOn do
						pcall(function()
							if humPart and char then
								-- Cek apakah saat ini pemain sedang berada di tim "Lobby"
								local isLobby = LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby"
								
								-- Pemicu: Jika kembali ke tim Lobby ATAU cooldown 5.5 menit sudah habis (cooldown <= 0)
								if isLobby or cooldown <= 0 then
									local obbyEnd = workspace:FindFirstChild("ObbyEndPart", true)
									local hardObbyEnd = workspace:FindFirstChild("HardObbyEndPart", true)
									
									-- 1. Teleport ke ObbyEndPart
									if obbyEnd then
										humPart.CFrame = obbyEnd.CFrame + Vector3.new(0, 2, 0)
										task.wait(1) -- Tunggu 1 detik
									end
									
									-- 2. Teleport ke HardObbyEndPart
									if hardObbyEnd and isOn then
										humPart.CFrame = hardObbyEnd.CFrame + Vector3.new(0, 2, 0)
									end
									
									-- Reset cooldown kembali ke 5.5 menit (330 detik)
									cooldown = 330
									
									-- Jeda aman 5 detik agar script tidak spam TP saat game sedang memproses perpindahan tim kamu
									task.wait(5)
								end
							end
						end)
						
						task.wait(1)
						-- Mengurangi timer cooldown setiap detiknya
						if cooldown > 0 then
							cooldown = cooldown - 1
						end
					end
				end)
			end

elseif name == "Auto Task" then
	if isOn then
		task.spawn(function()
			local visitedTasks = {}
			while isOn do
				pcall(function()
					-- JIKA SHERIFF DEKAT: Berhenti dan tunggu sampai aman
					if _G.SheriffNear then 
						task.wait(0.5) 
						return 
					end

					-- FIX 1: Ambil Character & HumanoidRootPart secara real-time di sini biar gak NIL
					local char = LocalPlayer.Character
					local humPart = char and char:FindFirstChild("HumanoidRootPart")

					if humPart and char then
						local targetHitbox = nil
						local yellowTasks = {}
						local whiteTasks = {}

						-- FIX 2: Fungsi pintar untuk membaca warna Part + warna Outline (Highlight/SelectionBox)
						local function kelompokkanHitbox(v)
							local c = v.Color
							local brickName = string.lower(v.BrickColor.Name)
							
							-- Cek apakah game memakai sistem Highlight outline seperti di screenshot
							local highlight = v:FindFirstChildOfClass("Highlight") 
								or v.Parent:FindFirstChildOfClass("Highlight") 
								or (v.Parent.Parent and v.Parent.Parent:FindFirstChildOfClass("Highlight"))
							local selection = v:FindFirstChildOfClass("SelectionBox") 
								or v.Parent:FindFirstChildOfClass("SelectionBox")
							
							if highlight then
								c = (highlight.FillTransparency < 1 and highlight.FillColor) or highlight.OutlineColor
							elseif selection then
								c = selection.Color3
							end

							-- Logika saringan warna (Kuning vs Putih)
							local isYellow = (c.R > 0.5 and c.G > 0.5 and c.B < 0.4) or string.find(brickName, "yellow") or string.find(brickName, "gold")
							local isWhite = (c.R > 0.8 and c.G > 0.8 and c.B > 0.8) or string.find(brickName, "white")

							if isYellow then
								table.insert(yellowTasks, v)
							elseif isWhite then
								table.insert(whiteTasks, v)
							end
						end

						-- SCAN 1: Cari Hitbox baru yang belum dikunjungi
						for _, v in pairs(workspace:GetDescendants()) do
							if v:IsA("BasePart") and v.Name == "Hitbox" then
								if not visitedTasks[v] then
									kelompokkanHitbox(v)
								end
							end
						end
						
						-- SCAN 2: Reset list kalau semua target valid sudah selesai dirampok
						if #yellowTasks == 0 and #whiteTasks == 0 then
							visitedTasks = {}
							for _, v in pairs(workspace:GetDescendants()) do
								if v:IsA("BasePart") and v.Name == "Hitbox" then
									kelompokkanHitbox(v)
								end
							end
						end

						-- PRIORITAS: Gas yang kuning dulu, kalau abis baru yang putih
						if #yellowTasks > 0 then
							targetHitbox = yellowTasks[1]
						elseif #whiteTasks > 0 then
							targetHitbox = whiteTasks[1]
						end
						
						-- Eksekusi Teleportasi dan Interaksi
						if targetHitbox then
							visitedTasks[targetHitbox] = true
							humPart.CFrame = targetHitbox.CFrame + Vector3.new(0, 2, 0)
							task.wait(0.3)
							
							local prompt = targetHitbox:FindFirstChildOfClass("ProximityPrompt") 
								or targetHitbox.Parent:FindFirstChildOfClass("ProximityPrompt")
								or targetHitbox.Parent:FindFirstChild("ProximityPrompt", true)
							
							if prompt and isOn and not _G.SheriffNear then
								prompt.HoldDuration = 0
								prompt:InputHoldBegin()
								
								local timeElapsed = 0
								while timeElapsed < 5.5 and isOn and not _G.SheriffNear do
									task.wait(0.1)
									timeElapsed = timeElapsed + 0.1
								end
								
								prompt:InputHoldEnd()
							else
								task.wait(0.5)
							end
						end
					end
				end)
				task.wait(0.5)
			end
		end)
	end	

		elseif name == "Auto Run when Sherrif is near" then
			if isOn then
				task.spawn(function()
					while isOn do
						pcall(function()
							if humPart and char then
								local maxDistance = 60 -- Jarak diperluas ke 60 studs agar lebih sigap kabur
								local sheriffNear = false
								
								-- 1. Deteksi Ganda Akurat (Nama Tim mengandung kata 'sheriff' ATAU memegang Senjata)
								for _, p in pairs(game:GetService("Players"):GetPlayers()) do
									if p ~= game:GetService("Players").LocalPlayer then
										local isSheriff = false
										
										if p.Team and string.find(p.Team.Name:lower(), "sheriff") then
											isSheriff = true
										elseif p.Character and (p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") or p.Character:FindFirstChildWhichIsA("Tool")) then
											isSheriff = true
										end
										
										if isSheriff and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
											local dist = (humPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
											if dist <= maxDistance then
												sheriffNear = true
												break
											end
										end
									end
								end
								
								-- 2. Proses Teleportasi Darurat
								if sheriffNear then
									_G.SheriffNear = true -- Mengunci Auto Task agar melepaskan tombol E
									
									local lobby = workspace:FindFirstChild("Lobby", true) 
										or workspace:FindFirstChild("SpawnLocation", true) 
										or workspace:FindFirstChild("Spawn", true)
									
									if lobby then
										local oldCFrame = humPart.CFrame -- Simpan posisi aman tempat kerja sebelumnya
										
										-- Pindah Instan ke Lobby
										if lobby:IsA("Model") then
											humPart.CFrame = lobby:GetPivot() + Vector3.new(0, 3, 0)
										else
											humPart.CFrame = lobby.CFrame + Vector3.new(0, 3, 0)
										end
										
										task.wait(3) -- Sembunyi di lobby selama 3 detik
										
										-- Kembali ke tempat kerja jika kondisi aman dan fitur masih aktif
										if isOn and humPart and not sheriffNear then
											humPart.CFrame = oldCFrame
										end
									end
									_G.SheriffNear = false -- Membuka kembali ijin jalan untuk Auto Task
								end
							end
						end)
						task.wait(0.1) -- PERBAIKAN FATAL: Deteksi dipercepat ke 0.1 detik (Instan / Refleks Dewa)
					end
					_G.SheriffNear = false
				end)
			else
				_G.SheriffNear = false
		end

		elseif name == "Inf Stamina" then
			if isOn then
				task.spawn(function()
					while isOn do
						pcall(function()
							local sprint = LocalPlayer.PlayerGui:FindFirstChild("Modules") and LocalPlayer.PlayerGui.Modules:FindFirstChild("Gameplay") and LocalPlayer.PlayerGui.Modules.Gameplay:FindFirstChild("Sprint")
							if sprint and sprint:FindFirstChild("Stamina") then
								sprint.Stamina.Value = 9e9
							end
						end)
						task.wait(0.6)
					end
				end)
			else
				pcall(function()
					local sprint = LocalPlayer.PlayerGui.Modules.Gameplay.Sprint
					if sprint and sprint:FindFirstChild("Stamina") then
						sprint.Stamina.Value = 6
					end
				end)
			end

		elseif name == "Noclip" then
			if isOn then
				local function NoclipLoop()
					if char then
						for _, child in pairs(char:GetDescendants()) do
							if child:IsA("BasePart") and child.CanCollide == true then
								child.CanCollide = false
							end
						end
					end
				end
				_G.NoclippingHook = RunService.Stepped:Connect(NoclipLoop)
			else
				if _G.NoclippingHook then
					_G.NoclippingHook:Disconnect()
					_G.NoclippingHook = nil
				end
			end
		end
	end)
end

local function CreateScriptButton(name, callback)
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
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(240,245,255)
	Label.TextSize = 15
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local ActionBtn = Instance.new("TextButton")
	ActionBtn.Size = UDim2.new(0,75,0,26)
	ActionBtn.Position = UDim2.new(1,-90,0.5,-13)
	ActionBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
	ActionBtn.Text = "RUN"
	ActionBtn.TextColor3 = Color3.fromRGB(255,255,255)
	ActionBtn.Font = Enum.Font.GothamBold
	ActionBtn.TextSize = 12
	ActionBtn.Parent = Row
	Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0,6)

	ActionBtn.MouseButton1Click:Connect(callback)
end

----------------------------------------------------
-- REGISTRASI FITUR MENU
----------------------------------------------------
CreateScriptRow("Super Speed", false)
CreateScriptRow("Infinite Jump", false)
CreateScriptRow("Cash Farm", false)
CreateScriptRow("Reset if Bag Full", false)
CreateScriptRow("Reset if Sheriff", false)
CreateScriptRow("Auto Server Hop", false)
CreateScriptRow("ESP", false)
CreateScriptRow("Auto Complete Obby", false)
CreateScriptRow("Auto Task", false)
CreateScriptRow("Auto Run when Sherrif is near", false)
CreateScriptRow("Inf Stamina", false)
CreateScriptRow("Noclip", false)

CreateScriptButton("Kill Nearest NPCs", function()
	for i, v in ipairs(Players:GetPlayers()) do
		if v == LocalPlayer and v.Character then
			Instance.new("Folder", v.Character).Name = "testt"
		end
	end
	task.wait(0.5)
	for i, v in ipairs(workspace:GetChildren()) do
		if v:FindFirstChild("testt") == nil and v:FindFirstChild("Died") == nil and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			local Magnitude = (humPart.Position - v.HumanoidRootPart.Position).Magnitude
			if Magnitude <= 50 then
				v.Humanoid.RigType = Enum.HumanoidRigType.R6
				v.Humanoid.Health = 0
				Instance.new("Folder", v).Name = "Died"
			end
		end
	end
	if char and char:FindFirstChild("testt") then char.testt:Destroy() end
end)

CreateScriptButton("Server Hop", function()
	serverHop()
end)

CreateScriptButton("FullBright", function()
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.GlobalShadows = false
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

----------------------------------------------------
-- BOTTOM CONTROLS & UTILITIES
----------------------------------------------------
local AntiAfkBtn = Instance.new("TextButton")
AntiAfkBtn.Size = UDim2.new(1,-30,0,40)
AntiAfkBtn.Position = UDim2.new(0,15,1,-50)
AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(20,40,70)
AntiAfkBtn.Text = "ACTIVATE ANTI AFK"
AntiAfkBtn.TextColor3 = Color3.fromRGB(0,200,255)
AntiAfkBtn.TextSize = 13
AntiAfkBtn.Font = Enum.Font.GothamBold
AntiAfkBtn.Parent = MainFrame
Instance.new("UICorner", AntiAfkBtn).CornerRadius = UDim.new(0,6)

local vu = game:GetService("VirtualUser")
AntiAfkBtn.MouseButton1Click:Connect(function()
	LocalPlayer.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end)
	AntiAfkBtn.Text = "ANTI AFK ACTIVE ✔"
	AntiAfkBtn.TextColor3 = Color3.fromRGB(0,255,150)
end)

----------------------------------------------------
-- BUNDARAN TOGGLE OPEN / CLOSE ("AS")
----------------------------------------------------
local RoundToggleBtn = Instance.new("TextButton")
RoundToggleBtn.Name = "RoundToggleBtn"
RoundToggleBtn.Size = UDim2.new(0,55,0,55)
RoundToggleBtn.Position = UDim2.new(0,20,0.5,-27)
RoundToggleBtn.BackgroundColor3 = Color3.fromRGB(10,25,50) -- Biru Tua asli Anda
RoundToggleBtn.Text = "AS"
RoundToggleBtn.TextColor3 = Color3.fromRGB(0,180,255) -- Biru Muda asli Anda
RoundToggleBtn.TextSize = 20
RoundToggleBtn.Font = Enum.Font.GothamBold
RoundToggleBtn.Visible = false
RoundToggleBtn.Parent = ScreenGui
Instance.new("UICorner", RoundToggleBtn).CornerRadius = UDim.new(1,0)

-- Logika Buka Tutup Utama
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false RoundToggleBtn.Visible = true end)
RoundToggleBtn.MouseButton1Click:Connect(function() RoundToggleBtn.Visible = false MainFrame.Visible = true end)

----------------------------------------------------
-- DRAGGABLE SYSTEM (Sistem Geser UI & Bundaran)
----------------------------------------------------
local function MakeDraggable(uiElement)
	local dragging, dragInput, dragStart, startPos
	uiElement.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true dragStart = input.Position startPos = uiElement.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	uiElement.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			uiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Mengaktifkan fungsi geser ke Main Menu dan Bundaran "AS"
MakeDraggable(MainFrame)
MakeDraggable(RoundToggleBtn)

-- Efek Animasi Muncul
MainFrame.Size = UDim2.new(0,0,0,0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,550,0,400)}):Play()
