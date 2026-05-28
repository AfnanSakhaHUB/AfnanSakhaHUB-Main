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
					local cooldown = 0
					while isOn do
						pcall(function()
							if humPart and char then
								local isLobby = LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby"
								
								if isLobby or cooldown <= 0 then
									local obbyEnd = workspace:FindFirstChild("ObbyEndPart", true)
									local hardObbyEnd = workspace:FindFirstChild("HardObbyEndPart", true)
									
									if obbyEnd then
										humPart.CFrame = obbyEnd.CFrame + Vector3.new(0, 2, 0)
										task.wait(1)
									end
									
									if hardObbyEnd and isOn then
										humPart.CFrame = hardObbyEnd.CFrame + Vector3.new(0, 2, 0)
									end
									
									cooldown = 330
									task.wait(5)
								end
							end
						end)
						
						task.wait(1)
						if cooldown > 0 then
							cooldown = cooldown - 1
						end
					end
				end)
             end -- PERBAIKAN: Menutup blok Auto Obby dengan benar agar tidak bocor ke bawah

elseif name == "Auto Task" then
	if isOn then
		task.spawn(function()
			local visitedTasks = {}
			local blacklistedHitboxes = {} -- Menyimpan 4 Hitbox terjauh ronde ini
			local lastTeam = nil           -- Untuk mendeteksi perubahan tim
			local vim = game:GetService("VirtualInputManager") -- Service untuk simulasi keyboard fisik
			
			while isOn do
				pcall(function()
					-- JIKA SHERIFF DEKAT: Berhenti dulu demi keamanan
					if _G.SheriffNear then 
						task.wait(0.5) 
						return 
					end

					-- Ambil nama tim saat ini (Jika nil, anggap di Lobby)
					local currentTeam = (LocalPlayer.Team and LocalPlayer.Team.Name) or "Lobby"

					-- [SISTEM DETEKSI TRANSISI]: Berubah dari Lobby menjadi Criminals
					if currentTeam == "Criminals" and lastTeam ~= "Criminals" then
						if humPart then
							blacklistedHitboxes = {} -- Reset blacklist ronde sebelumnya
							local allHitboxes = {}
							
							-- Scan seluruh Hitbox yang ada di map saat baru spawn
							for _, v in pairs(workspace:GetDescendants()) do
								if v:IsA("BasePart") and v.Name == "Hitbox" then
									table.insert(allHitboxes, v)
								end
							end
							
							-- Cari dan kunci 4 Hitbox paling jauh dari lokasi awal spawn kita
							if #allHitboxes > 4 then
								local spawnPos2D = Vector3.new(humPart.Position.X, 0, humPart.Position.Z)
								
								table.sort(allHitboxes, function(a, b)
									local posA2D = Vector3.new(a.Position.X, 0, a.Position.Z)
									local posB2D = Vector3.new(b.Position.X, 0, b.Position.Z)
									return (spawnPos2D - posA2D).Magnitude < (spawnPos2D - posB2D).Magnitude
								end)
								
								-- 4 Hitbox terjauh (berada di urutan paling belakang) dimasukkan ke Blacklist
								for i = #allHitboxes, #allHitboxes - 3, -1 do
									local farHitbox = allHitboxes[i]
									if farHitbox then
										blacklistedHitboxes[farHitbox] = true
									end
								end
							end
						end
					end
					
					-- Catat tim saat ini untuk deteksi di loop berikutnya
					lastTeam = currentTeam

					-- EXECUTE TASK: Hanya berjalan jika berstatus "Criminals"
					if currentTeam == "Criminals" then
						if humPart and char then
							local targetHitbox = nil
							local availableTasks = {}

							-- 1. Scan Hitbox yang belum dikunjungi DAN tidak ada di daftar Blacklist Terjauh
							for _, v in pairs(workspace:GetDescendants()) do
								if v:IsA("BasePart") and v.Name == "Hitbox" then
									if not visitedTasks[v] and not blacklistedHitboxes[v] then
										table.insert(availableTasks, v)
									end
								end
							end
							
							-- 2. Reset memori kunjungan jika semua Hitbox aman sudah habis
							if #availableTasks == 0 then
								visitedTasks = {}
								for _, v in pairs(workspace:GetDescendants()) do
									if v:IsA("BasePart") and v.Name == "Hitbox" then
										if not blacklistedHitboxes[v] then
											table.insert(availableTasks, v)
										end
									end
								end
							end

							-- 3. Urutkan sisa Hitbox yang aman berdasarkan yang PALING DEKAT dari posisi player sekarang
							if #availableTasks > 0 then
								local playerPos2D = Vector3.new(humPart.Position.X, 0, humPart.Position.Z)

								table.sort(availableTasks, function(a, b)
									local posA2D = Vector3.new(a.Position.X, 0, a.Position.Z)
									local posB2D = Vector3.new(b.Position.X, 0, b.Position.Z)
									return (playerPos2D - posA2D).Magnitude < (playerPos2D - posB2D).Magnitude
								end)
								
								targetHitbox = availableTasks[1]
							end
							
							-- 4. Eksekusi Teleport dan Tekan E Murni
							if targetHitbox then
								visitedTasks[targetHitbox] = true
								humPart.CFrame = targetHitbox.CFrame + Vector3.new(0, 2, 0)
								task.wait(0.3) -- Jeda stabilisasi posisi
								
								-- Cek ulang kondisi sebelum menekan E
								if isOn and not _G.SheriffNear and (LocalPlayer.Team and LocalPlayer.Team.Name == "Criminals") then
									vim:SendKeyEvent(true, Enum.KeyCode.E, false, game) -- Tahan E
									
									local timeElapsed = 0
									while timeElapsed < 5.5 and isOn and not _G.SheriffNear and (LocalPlayer.Team and LocalPlayer.Team.Name == "Criminals") do
										task.wait(0.1)
										timeElapsed = timeElapsed + 0.1
									end
									
									vim:SendKeyEvent(false, Enum.KeyCode.E, false, game) -- Lepas E
									task.wait(0.2) 
								else
									task.wait(0.5) 
								end
							end
						end
					else
						-- Jika kembali ke Lobby atau Mati, bersihkan blacklist agar siap untuk ronde depan
						blacklistedHitboxes = {}
						task.wait(1)
					end
				end)
				task.wait(0.1)
			end
		end)
	end
											
elseif name == "Auto Run when Sherrif is near" then
	if isOn then
		task.spawn(function()
			while isOn do
				pcall(function()
					-- 1. VALIDASI TIM: Hanya berjalan jika pemain adalah "Criminals"
					if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Criminals") then
						return 
					end

					if humPart and char then
						local maxDistance = 60 
						local sheriffNear = false
						local detectedSheriffPart = nil
						
						-- 2. Deteksi Keberadaan, Arah Pandang, & Penghalang (Raycast)
						for _, p in pairs(game:GetService("Players"):GetPlayers()) do
							if p ~= game:GetService("Players").LocalPlayer then
								local isSheriff = false
								
								if p.Team and string.find(p.Team.Name:lower(), "sheriff") then
									isSheriff = true
								elseif p.Character and (p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") or p.Character:FindFirstChildWhichIsA("Tool")) then
									isSheriff = true
								end
								
								if isSheriff and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
									local sPart = p.Character.HumanoidRootPart
									local dist = (humPart.Position - sPart.Position).Magnitude
									
									-- Jika Sheriff masuk dalam radius jarak maksimal
									if dist <= maxDistance then
										local sheriffLook = sPart.CFrame.LookVector 
										local directionToMe = (humPart.Position - sPart.Position).Unit 
										local dotProduct = sheriffLook:Dot(directionToMe) 
										
										-- [PRESISI]: Nilai 0.8 berarti Sheriff melihat sangat presisi ke arahmu
										if dotProduct > 0.8 then
											
											-- [FITUR BARU]: Pengecekan Garis Pandang (Line of Sight) lewat Raycast
											local raycastParams = RaycastParams.new()
											raycastParams.FilterType = Enum.RaycastFilterType.Exclude
											raycastParams.FilterDescendantsInstances = {p.Character} -- Abaikan tubuh Sheriff sendiri agar laser tidak terhalang badannya
											
											-- Tembakkan laser dari posisi Sheriff ke posisi Player
											local raycastResult = workspace:Raycast(sPart.Position, humPart.Position - sPart.Position, raycastParams)
											
											-- Jika laser menabrak sesuatu, pastikan yang tertabrak adalah bagian dari karakter kita (artinya TANPA HALANGAN)
											if raycastResult and raycastResult.Instance:IsDescendantOf(char) then
												sheriffNear = true
												detectedSheriffPart = sPart
												break
											end
										end
									end
								end
							end
						end
						
						-- Sinkronisasi data posisi Sheriff ke global agar dibaca script Auto Task
						_G.SheriffPart = detectedSheriffPart
						
						-- 3. Proses Evakuasi Darurat
						if sheriffNear then
							_G.SheriffNear = true -- Mengunci Auto Task agar berhenti menekan E
							
							local oldPos = humPart.Position -- Simpan posisi koordinat terakhir di tanah
							
							-- [SISTEM DETEKSI]: Cari tau Hitbox mana yang sedang kita tempati saat ini sebelum kabur
							local currentHitbox = nil
							local shortestDistToMe = math.huge
							for _, v in pairs(workspace:GetDescendants()) do
								if v:IsA("BasePart") and v.Name == "Hitbox" then
									local dist = (oldPos - v.Position).Magnitude
									if dist < shortestDistToMe then
										shortestDistToMe = dist
										currentHitbox = v -- Mengunci target Hitbox saat ini
									end
								end
							end
							
							-- Ke langit instan: X dan Z tetap sama, Y diubah ke 4000
							humPart.CFrame = CFrame.new(oldPos.X, 4000, oldPos.Z)
							task.wait(0.4) -- Jeda sangat singkat di langit
							
							-- 4. Cari Hitbox alternatif yang paling dekat
							local availableHitboxes = {}
							for _, v in pairs(workspace:GetDescendants()) do
								if v:IsA("BasePart") and v.Name == "Hitbox" then
									
									-- FILTER LOBBY: Abaikan jika Hitbox berada di radius X/Z 50 (Biar gak ganti tim)
									if math.abs(v.Position.X) <= 50 and math.abs(v.Position.Z) <= 50 then
										continue 
									end
									
									-- FILTER UTAMA: Harus BUKAN Hitbox yang barusan kita tempati (currentHitbox)
									if v ~= currentHitbox then
										table.insert(availableHitboxes, v)
									end
								end
							end
							
							-- SORTIR JARAK: Cari yang PALING DEKAT dari posisi lama kita
							table.sort(availableHitboxes, function(a, b)
								local distA = (oldPos - a.Position).Magnitude
								local distB = (oldPos - b.Position).Magnitude
								return distA < distB -- Mengutamakan jarak terkecil (paling dekat)
							end)
							
							local targetHitbox = availableHitboxes[1]
							
							-- 5. Teleport Turun ke Hitbox Baru yang Paling Dekat
							if targetHitbox and isOn and humPart then
								humPart.CFrame = targetHitbox.CFrame + Vector3.new(0, 2, 0)
								task.wait(0.3)
							end
							
							_G.SheriffNear = false -- Membuka gembok agar Auto Task bisa lanjut kerja di tempat baru
						end
					end
				end)
				task.wait(0.1) 
			end
			_G.SheriffNear = false
			_G.SheriffPart = nil
		end)
	else
		_G.SheriffNear = false
		_G.SheriffPart = nil
	end
				
-- Pastikan untuk mengambil TweenService di awal script (biasanya di luar block if/else, tetapi jika tidak bisa, taruh di dalam block 'isOn')
local TweenService = game:GetService("TweenService")

elseif name == "Inf Stamina" then
	if isOn then
		-- Bersihkan UI, koneksi lama, dan tween jika ada untuk mencegah duplikasi/konflik
		if LocalPlayer.PlayerGui:FindFirstChild("InvisibleSprintGui") then
			LocalPlayer.PlayerGui.InvisibleSprintGui:Destroy()
		end
		if _G.SpeedLoop then _G.SpeedLoop:Disconnect() _G.SpeedLoop = nil end
		if _G.LayeringLoop then _G.LayeringLoop:Disconnect() _G.LayeringLoop = nil end
		if _G.BtnConnection then _G.BtnConnection:Disconnect() _G.BtnConnection = nil end
		if _G.KeyConnection then _G.KeyConnection:Disconnect() _G.KeyConnection = nil end
		
		-- Batalkan tween FOV lama jika ada
		if _G.SprintTween then _G.SprintTween:Cancel() _G.SprintTween = nil end
		if _G.NormalTween then _G.NormalTween:Cancel() _G.NormalTween = nil end

		-- 1. Membuat ScreenGui Baru dengan DisplayOrder Tinggi
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "InvisibleSprintGui"
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.DisplayOrder = 9999 -- Mengatur DisplayOrder ScreenGui agar sangat tinggi
		screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

		-- 2. Membuat Tombol Penutup dengan ZIndex Sangat Tinggi
		local overlayButton = Instance.new("TextButton")
		overlayButton.Name = "OverlayButton"
		
		-- Menggunakan Ukuran dan Posisi persis yang Anda berikan
		overlayButton.Size = UDim2.new(0, 66, 0, 66) 
		overlayButton.Position = UDim2.new(1, -143, 1, -47) 
		overlayButton.AnchorPoint = Vector2.new(0.5, 0.5)
		
		-- PENGATURAN AWAL: Tombol 100% Tidak Terlihat (Transparansi = 1)
		overlayButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlayButton.BackgroundTransparency = 1 
		overlayButton.Text = "" 
		overlayButton.BorderSizePixel = 0
		overlayButton.ZIndex = 999999999 -- Lapisan paling atas untuk memblock klik asli

		-- Membuat bentuk bulat seperti tombol bawaan
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(1, 0)
		uiCorner.Parent = overlayButton
		
		overlayButton.Parent = screenGui

		-- State awal status lari
		_G.Speed22Active = false

		-- --- Pengaturan Efek FOV ---
		-- Menyimpan FOV asli pemain
		local currentCamera = game.Workspace.CurrentCamera
		_G.OriginalFOV = currentCamera.FieldOfView
		-- FOV saat berlari (Asli + 20, bisa diubah)
		_G.SprintFOV = _G.OriginalFOV + 20 

		-- Info Tween (Durasi, Gaya Easing, Arah Easing)
		_G.SprintTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

		-- Membuat Tweens
		_G.SprintTween = TweenService:Create(currentCamera, _G.SprintTweenInfo, {FieldOfView = _G.SprintFOV})
		_G.NormalTween = TweenService:Create(currentCamera, _G.SprintTweenInfo, {FieldOfView = _G.OriginalFOV})
		-- --- Akhir Pengaturan Efek FOV ---

		-- 3. --- FIX LAYERING: Loop Constan untuk Memaksa Layering ---
		_G.LayeringLoop = game:GetService("RunService").Heartbeat:Connect(function()
			pcall(function()
				-- Memaksa DisplayOrder ScreenGui tetap tinggi
				if screenGui and screenGui.Parent then
					screenGui.DisplayOrder = 9999
				end
				-- Memaksa ZIndex tombol tetap sangat tinggi
				if overlayButton and overlayButton.Parent then
					overlayButton.ZIndex = 999999999
				end
			end)
		end)
		-- --- Akhir FIX LAYERING ---

		-- Fungsi AKTIF LARI: Kecepatan 22 & Efek FOV & Ubah Tombol jadi Muncul/Visible 0.3
		local function enableSpeed()
			_G.Speed22Active = true
			
			-- Mengubah tombol menjadi hitam transparan (Visible 0.3 artinya Transparansi 0.7)
			overlayButton.BackgroundTransparency = 0.7 

			-- Mainkan efek tarikan layar (FOV)
			_G.NormalTween:Cancel()
			_G.SprintTween:Play()
			
			if _G.SpeedLoop then _G.SpeedLoop:Disconnect() end
			
			-- Mengunci kecepatan konstan di angka 22
			_G.SpeedLoop = game:GetService("RunService").RenderStepped:Connect(function()
				pcall(function()
					local char = LocalPlayer.Character
					if char then
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hum and hum.WalkSpeed ~= 22 then
							hum.WalkSpeed = 22
						end
					end
				end)
			end)
		end

		-- Fungsi MATI LARI: Kembali Normal & Reset FOV & Ubah Tombol jadi 100% Tidak Terlihat
		local function disableSpeed()
			_G.Speed22Active = false
			
			-- Mengembalikan tombol menjadi 100% tidak terlihat (Transparansi = 1)
			overlayButton.BackgroundTransparency = 1 

			-- Kembali ke FOV normal
			_G.SprintTween:Cancel()
			_G.NormalTween:Play()
			
			if _G.SpeedLoop then
				_G.SpeedLoop:Disconnect()
				_G.SpeedLoop = nil
			end
			pcall(function()
				local char = LocalPlayer.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then
						hum.WalkSpeed = 16 -- Kecepatan normal
					end
				end
			end)
		end

		-- Fungsi Toggle Pemicu ganti status
		local function handleToggle()
			if _G.Speed22Active then
				disableSpeed()
			else
				enableSpeed()
			end
		end

		-- Deteksi Input Klik Tombol (Mobile/PC)
		_G.BtnConnection = overlayButton.MouseButton1Click:Connect(handleToggle)

		-- Deteksi Input Tekan Tombol Shift (Khusus PC)
		_G.KeyConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end 
			if input.KeyCode == Enum.KeyCode.LeftShift then
				handleToggle()
			end
		end)

	else
		-- JIKA FITUR DI-MATIKAN DARI MENU UTAMA (isOn == false)
		if _G.SpeedLoop then _G.SpeedLoop:Disconnect() _G.SpeedLoop = nil end
		if _G.LayeringLoop then _G.LayeringLoop:Disconnect() _G.LayeringLoop = nil end
		if _G.BtnConnection then _G.BtnConnection:Disconnect() _G.BtnConnection = nil end
		if _G.KeyConnection then _G.KeyConnection:Disconnect() _G.KeyConnection = nil end
		
		-- Batalkan tween dan reset variabel FOV global
		if _G.SprintTween then _G.SprintTween:Cancel() _G.SprintTween = nil end
		if _G.NormalTween then _G.NormalTween:Cancel() _G.NormalTween = nil end
		-- Kembalikan FOV ke normal (just in case)
		pcall(function()
			game.Workspace.CurrentCamera.FieldOfView = _G.OriginalFOV
		end)
		_G.OriginalFOV = nil
		_G.SprintFOV = nil
		_G.SprintTweenInfo = nil

		local existingGui = LocalPlayer.PlayerGui:FindFirstChild("InvisibleSprintGui")
		if existingGui then
			existingGui:Destroy()
		end
		
		-- Kembalikan kecepatan karakter menjadi normal seutuhnya
		pcall(function()
			local char = LocalPlayer.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.WalkSpeed = 16
				end
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

elseif name == "Immortality" then
	if isOn then
		-- Bersihkan koneksi lama agar tidak menumpuk/lag
		if _G.DeathConnection then _G.DeathConnection:Disconnect() _G.DeathConnection = nil end
		if _G.CharAddedConnection then _G.CharAddedConnection:Disconnect() _G.CharAddedConnection = nil end

		-- Fungsi utama mendeteksi kematian dan mengecek kelayakan tempat mati
		local function listenToDeath(char)
			local humanoid = char:WaitForChild("Humanoid", 5)
			local rootPart = char:WaitForChild("HumanoidRootPart", 5)
			
			if humanoid and rootPart then
				_G.DeathConnection = humanoid.Died:Connect(function()
					-- 1. Ambil tim saat ini tepat sebelum sistem game memindahkan ke Lobby
					local currentTeam = LocalPlayer.Team and LocalPlayer.Team.Name
					
					if currentTeam == "Criminals" or currentTeam == "Sheriffs" then
						local deathPos = rootPart.Position
						
						-- 2. Setup Raycast untuk mengecek lantai di bawah titik mati
						local raycastParams = RaycastParams.new()
						raycastParams.FilterType = Enum.RaycastFilterType.Exclude
						raycastParams.FilterDescendantsInstances = {char} -- Abaikan karakter sendiri
						
						-- Tembak garis lurus ke bawah sejauh 150 studs
						local raycastResult = workspace:Raycast(deathPos, Vector3.new(0, -150, 0), raycastParams)
						
						if raycastResult and raycastResult.Instance then
							local hitPart = raycastResult.Instance
							
							-- 3. VALIDASI: Hanya bekerja jika lantai terlihat (tidak transparan 100%) dan memiliki collide
							if hitPart.Transparency < 1 and hitPart.CanCollide then
								
								-- Jalankan thread terpisah untuk menunggu proses respawn
								task.spawn(function()
									-- Tunggu karakter baru muncul di lobby bawaan game
									local newChar = LocalPlayer.CharacterAdded:Wait()
									local newRoot = newChar:WaitForChild("HumanoidRootPart", 10)
									task.wait(0.6) -- Jeda tipis agar karakter siap/load sempurna
									
									if newRoot then
										-- 4. Teleport kembali ke posisi mati (diberi jarak +3 studs ke atas agar tidak amblas)
										newRoot.CFrame = CFrame.new(deathPos + Vector3.new(0, 3, 0))
										
										-- 5. Kembalikan Tim Pemain ke tim semula (Criminals / Sheriffs)
										pcall(function()
											local targetTeam = game.Teams:FindFirstChild(currentTeam)
											if targetTeam then
												LocalPlayer.Team = targetTeam
												
												-- [[ CATATAN PENTING ]]
												-- Jika tim tidak berubah secara server-side (hanya berubah di layar Anda),
												-- Anda harus mengganti baris "LocalPlayer.Team = targetTeam" di atas dengan 
												-- RemoteEvent bawaan game ini untuk join tim. Contohnya biasanya seperti:
												-- game.ReplicatedStorage.JoinTeamRemote:FireServer(currentTeam)
											end
										end)
									end
								end)
								
							end
						end
					end
				end)
			end
		end

		-- Jalankan fungsi jika karakter sudah hidup di dalam game
		if LocalPlayer.Character then
			listenToDeath(LocalPlayer.Character)
		end

		-- Jalankan otomatis setiap kali karakter respawn di round selanjutnya
		_G.CharAddedConnection = LocalPlayer.CharacterAdded:Connect(listenToDeath)

	else
		-- JIKA FITUR DIMATIKAN
		if _G.DeathConnection then _G.DeathConnection:Disconnect() _G.DeathConnection = nil end
		if _G.CharAddedConnection then _G.CharAddedConnection:Disconnect() _G.CharAddedConnection = nil end
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
CreateScriptRow("Immortality", false)

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
