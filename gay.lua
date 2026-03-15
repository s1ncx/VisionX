repeat wait() until game:IsLoaded()
if game:IsLoaded() then
    print('game fully loaded')
end
wait(1)
local players = game:GetService("Players")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lplr = game.Players.LocalPlayer

local name = lplr.Name
local dname = lplr.DisplayName
local workspace = game.Workspace 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gravity = workspace.Gravity 
local executor = identifyexecutor() or "???"
local userid = lplr.UserId
local RunService = game:GetService("RunService")
local FPS = 0
local HTTP = game:GetService("HttpService")

local HttpService = game:GetService("HttpService")

local function getISOTime()
    return os.date("!%Y-%m-%dT%H:%M:%S.000Z", os.time()) -- Lấy UTC gốc
end



local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")

local player = players.LocalPlayer
local TweenService = game:GetService("TweenService")
local th = {}
local notifications = {} -- Lưu trữ danh sách thông báo hiện tại

function th.New(message, duration)
    duration = duration or 3 -- Thời gian hiển thị mặc định là 3 giây

    -- Tạo ScreenGui nếu chưa tồn tại
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("NotificationGui") or Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Tạo khung thông báo
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.35, 0, 0.08, 0) -- Kích thước khung thông báo
    frame.Position = UDim2.new(0.325, 0, 1, 0) -- Xuất hiện từ bên dưới màn hình
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu nền
    frame.BackgroundTransparency = 0.15 -- Độ trong suốt
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Bo góc mềm mại
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame

    -- Hiệu ứng gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 150))
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    -- Tạo văn bản thông báo
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.Parent = frame

    -- Thêm thông báo vào danh sách
    table.insert(notifications, frame)

    -- Tween để thông báo xuất hiện ở vị trí phù hợp
    local targetPosition = UDim2.new(0.325, 0, 0.1 + ((#notifications - 1) * 0.1), 0)
    local showTween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetPosition})
    showTween:Play()

    -- Xóa thông báo sau thời gian hiển thị với hiệu ứng mờ dần
    task.delay(duration, function()
        -- Fade out `TextLabel`
        local fadeTweenText = TweenService:Create(textLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 1
        })
        fadeTweenText:Play()

        -- Fade out `Frame`
        local fadeTweenFrame = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        fadeTweenFrame:Play()

        -- Sau khi fade hoàn tất, xóa thông báo
        fadeTweenFrame.Completed:Connect(function()
            frame:Destroy()
            table.remove(notifications, table.find(notifications, frame))

            -- Dịch chuyển các thông báo còn lại lên trên
            for i, notif in ipairs(notifications) do
                local newPosition = UDim2.new(0.325, 0, 0.1 + ((i - 1) * 0.1), 0)
                local moveTween = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPosition})
                moveTween:Play()
            end
        end)
    end)
end
local function formatNumber(value)
    if value >= 1e9 then
        return string.format("%.1fB", value / 1e9)
    elseif value >= 1e6 then
        return string.format("%.1fM", value / 1e6)
    elseif value >= 1e3 then
        return string.format("%.1fK", value / 1e3)
    else
        return tostring(value)
    end
    end
getgenv().start = true

task.spawn(function()
    local player = game.Players.LocalPlayer
    local startTime = tick() -- Lấy thời gian bắt đầu

    while getgenv().start do 
        task.wait(2)
        pcall(function()
            local playerGui = player:FindFirstChild("PlayerGui")

            -- Kiểm tra và xử lý màn hình tải
            if playerGui and playerGui:FindFirstChild("LoadingGUI") then
                local loadingGui = playerGui.LoadingGUI
                if loadingGui:FindFirstChild("Play") then
                    local args = {
                        [1] = "EnterTheGame",
                        [2] = {}
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("EtcFunction"):InvokeServer(unpack(args))
                    -- Chờ nhân vật xuất hiện rồi tự sát
                    repeat task.wait() until player.Character and player.Character:FindFirstChild("Humanoid")
                    player.Character.Humanoid.Health = 0
                end
            end

            -- Kiểm tra và chọn chế độ "Hard"
            if playerGui and playerGui:FindFirstChild("ChooseMap") then
                game:GetService("ReplicatedStorage"):WaitForChild("ChooseMapRemote"):FireServer("Hard")
            end

            if not player:FindFirstChild("DataLoaded") and (tick() - startTime >= 10) then
                warn("Nhân vật chưa load sau 10 giây, dịch chuyển")
                game:GetService("TeleportService"):Teleport(4520749081, player)
                return -- Thoát vòng lặp sau khi dịch chuyển
            end
        end)
    end
end)

local function sea(value)
    if value == 3 and game.PlaceId == 15759515082 then
        return true
    elseif value == 1 and game.PlaceId == 4520749081 then
        return true
    elseif value == 2 and game.PlaceId == 6381829480 then
        return true
    elseif value == 4 and game.PlaceId == 5931540094 then
        return true
    else 
        return false
    end
end
local function updateFPS() 
        FPS += 1 
end 
local player = game.Players.LocalPlayer
local workspace = game.Workspace
local RunService = game:GetService("RunService")
local teleportService = game:GetService("TeleportService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local effectsFolder = game.Workspace:FindFirstChild("Effects")
local mobFolder = game.Workspace:WaitForChild("MOB")
local HttpService = game:GetService("HttpService")
task.spawn(function()
    if game.PlaceId ~= 9821272782 then
        getgenv().Press = function(v)
            return game:GetService("VirtualInputManager"):SendKeyEvent(true, v, false, game);
        end
        while true do wait(500)
            Press("RightBracket");
        end
    else
        while true do wait(500)
            keypress(0xDD);
        end
    end
end)
local FilePath = "TestHubSaveKingLegacy"
local SettingsFile = FilePath .. "/CombinedSettings.json"  -- Đảm bảo sử dụng đúng ký tự phân cách thư mục

local combinedData = {}

-- Kiểm tra và tạo thư mục nếu chưa tồn tại
if not isfolder(FilePath) then
    makefolder(FilePath)
end

-- Khởi tạo combinedData với giá trị mặc định
combinedData = {
    Settings = {
        autoDeleteEffects = false,
        teleraid = false,
        start = true,
        opeskill = true,
        kioru = true,
        eff = true,
        bankin = 100,
        autoDodgeEnabled = true,
        autoTeleport = false,
        maxDistanceFromBoss = 190,
        docao = 50,
        autoWhitelist = false,
        fpsbut = true,
        jobId = "",
        Webhook_URL2 = "https://discord.com/api/webhooks/1217892100834852905/4aBabISkNZwD9IKl3dAZJVKp-TqzsDdsAKIG_j6yHRnJXvzhY11a1rQo-zvKWI5e5bVL",
        AutoRejoin = false,
        hub = 0.2,
        alime = 0.7,
        giaodien = false,
        autobuy = true,
        chonkey = "Copper Key",
        KL = 1,
        slkey = 10,
        autoskhd = true,
        autoskillsea = true,
        autoskhdhop = true,
        autocat = true,
        HopThreshold = 70,
        dropfruit = false,
        SpecialTraders = {""},
        autochapnhan = false,
        autotrade = false
        
        
    }
}

local Settings = combinedData.Settings

-- Hàm tải dữ liệu đã lưu
local function loadSavedData()
    if isfile(SettingsFile) then
        local success, json = pcall(readfile, SettingsFile)
        if success then
            local decodeSuccess, decodedData = pcall(function()
                return HttpService:JSONDecode(json)
            end)
            if decodeSuccess and type(decodedData) == "table" then
                combinedData = decodedData
                Settings = combinedData.Settings  -- Cập nhật lại Settings sau khi tải dữ liệu
            else
                warn("Failed to decode settings: " .. tostring(decodedData))
            end
        else
            warn("Failed to read settings file: " .. tostring(json))
        end
    end
end

-- Hàm lưu dữ liệu vào tệp
local function SaveSettings()
    local success, json = pcall(function()
        return HttpService:JSONEncode(combinedData)
    end)
    
    if not success then
        warn("Failed to encode settings: " .. tostring(json))
        return
    end
    
    -- Ghi tệp với dữ liệu đã mã hóa
    local successWrite = pcall(function()
        writefile(SettingsFile, json)
    end)
    
end

-- Đảm bảo rằng loadSavedData được gọi để tải dữ liệu
loadSavedData()


local function getServerUptime(servers, currentJobId)
    for _, server in pairs(servers) do
        if type(server) == "table" and server.JobId == currentJobId and server.ServerOsTime then
            local uptime = os.time() - server.ServerOsTime -- Tính thời gian server đã hoạt động
            return uptime, server.ServerName, server.JobId
        end
    end
    return nil, nil, nil -- Không tìm thấy server hiện tại
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hàm chuyển đổi giây thành dạng ngày, giờ, phút, giây
local function formatTime(seconds)
    local days = math.floor(seconds / 86400) -- 1 ngày = 86400 giây
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600) -- 1 giờ = 3600 giây
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60) -- 1 phút = 60 giây
    seconds = seconds % 60
    return string.format("%d:%d:%d:%d", days, hours, minutes, seconds)
end

-- Lấy danh sách server
local networkModule = game.ReplicatedStorage.Chest.Assets.Modules.Network
local servers = networkModule.ClientNetwork.GetServerLists:InvokeServer()
local currentJobId = game.JobId

-- Gọi hàm để lấy thời gian hoạt động của server hiện tại
local uptime, serverName, jobId = getServerUptime(servers, currentJobId)

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NamG2657/Scripting/refs/heads/main/OrionLib.lua?t=" .. os.time(), true))()

local pe = game:GetService("Players").LocalPlayer.Name
local Window = OrionLib:MakeWindow({
    Name = "TestHubV2",
    IntroEnabled = false,
    IntroText = "Welcome to TestHubV2, "..pe.."!",
    IntroIcon = "rbxassetid://6031094686",
    HidePremium = true, 
    SaveConfig = false, 
    ConfigFolder = "TestHubV2"
})

function stop()
    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and not root:FindFirstChild("FreezeVelocity") then
        local freeze = Instance.new("BodyVelocity")
        freeze.Name = "FreezeVelocity"
        freeze.Parent = root
        freeze.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- Lực cực lớn
        freeze.Velocity = Vector3.new(0, 0, 0) -- Vận tốc bằng 0
    end
end

function ngungstop()
    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("FreezeVelocity") then
        root.FreezeVelocity:Destroy()
    end
end

if sea(2) then
local sTab = Window:MakeTab({
    Name = "Sea Hop Beta ",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
if servers then
local Section = sTab:AddSection({Name = serverName})
         end
local function getBossRoot()
    local workspace = game:GetService("Workspace")
    local bossFolders = {workspace.SeaMonster, workspace.GhostMonster}
    local bosses = {"SeaKing", "HydraSeaKing", "Ghost Ship"}

    for _, folder in ipairs(bossFolders) do
        if folder then
            for _, bossName in ipairs(bosses) do
                local boss = folder:FindFirstChild(bossName)
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    
                    return boss.HumanoidRootPart
                end
            end
        end
    end
    return nil
end

sTab:AddToggle({
    Name = "Auto Aim Skill HD+SK+GS",
    Default = Settings.autoskillsea,
    Callback = function(value)
        getgenv().AutoS = value
        Settings.autoskillsea = value
        SaveSettings()
        if not value then return end

        task.spawn(function()
            while Settings.autoskillsea do
                task.wait(0.3)
                pcall(function()
                    local workspace = game:GetService("Workspace")
                    local player = game.Players.LocalPlayer
                    local skillAction = game:GetService("ReplicatedStorage").Chest.Remotes.Functions.SkillAction
                    
                    -- Lấy root của boss
                    local skRoot = getBossRoot()
                    if not skRoot then return end

                    local function sendSkill(toolName, prefix, skill)
                        local args = {
                            [1] = prefix.."_"..toolName.."_"..skill,
                            [2] = {["MouseHit"] = skRoot.CFrame, ["Type"] = skill == "M1" and "Click" or "Down"}
                        }
                        skillAction:InvokeServer(unpack(args))
                        if skill ~= "M1" then
                            task.wait(0.05)
                            args[2].Type = "Up"
                            skillAction:InvokeServer(unpack(args))
                        end
                    end

                    -- Kiểm tra Ope V2
                    local hasOpOp = player.Backpack:FindFirstChild("Kioru V2") ~= nil

                    -- Quản lý Ope Room
                    local opeRoom = workspace:FindFirstChild("OpeRoom" .. player.Name)
                    if opeRoom then
                        local roomCFrame, roomSize = opeRoom.CFrame, opeRoom.Size
                        local bossOutsideCount, totalBosses = 0, 0

                        for _, boss in pairs(workspace.SeaMonster:GetChildren()) do
                            if boss:FindFirstChild("HumanoidRootPart") and boss.Name ~= "Hydra's Minion" then
                                totalBosses += 1
                                local bossPos = boss.HumanoidRootPart.Position
                                local isInside = 
                                    math.abs(bossPos.X - roomCFrame.Position.X) <= roomSize.X / 2 and
                                    math.abs(bossPos.Y - roomCFrame.Position.Y) <= roomSize.Y / 2 and
                                    math.abs(bossPos.Z - roomCFrame.Position.Z) <= roomSize.Z / 2
                                
                                if not isInside then
                                    bossOutsideCount += 1
                                end
                            end
                        end

                        if totalBosses > 0 and (bossOutsideCount / totalBosses) > 0.5 then
                            task.spawn(function()
                                skillAction:InvokeServer("DF_OpOp_Z", {["MouseHit"] = CFrame.new(), ["Type"] = "Down"})
                                task.wait(0.05)
                                skillAction:InvokeServer("DF_OpOp_Z", {["MouseHit"] = CFrame.new(), ["Type"] = "Up"})
                            end)
                        end
                    else
                        task.spawn(function()
                            skillAction:InvokeServer("DF_OpOp_Z", {["MouseHit"] = CFrame.new(), ["Type"] = "Down"})
                            task.wait(0.05)
                            skillAction:InvokeServer("DF_OpOp_Z", {["MouseHit"] = CFrame.new(), ["Type"] = "Up"})
                        end)
                    end

                    -- Sử dụng skill
                    if not hasOpOp then
                        local skills = {"M1", "Z", "X", "C", "V", "E"}
                        for _, tool in ipairs(player.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and not tool:FindFirstChild("DevilFruit") and tool.Name ~= "Cyborg" then
                                player.Character.Humanoid:EquipTool(tool)
                                task.wait(0.2)
                                for _, skill in ipairs(skills) do
                                    task.spawn(function()
                                        sendSkill(tool.Name, "SW", skill)
                                        sendSkill(tool.Name, "DF", skill)
                                    end)
                                end
                            end
                        end
                    else
                        -- Skill cho Ope V2 và Kioru V2
                        local opeSkills = {"X", "C", "V"}
                        local kioruSkills = {"M1", "Z", "X"}
                        
                        for _, skill in ipairs(opeSkills) do
                            task.spawn(function() sendSkill("OpOp", "DF", skill) end)
                        end
                        for _, skill in ipairs(kioruSkills) do
                            task.spawn(function() sendSkill("Kioru V2", "SW", skill) end)
                        end
                    end
                end)
            end
        end)
    end
})
getgenv().AutoSeaKing = false

sTab:AddToggle({
    Name = "Auto Teleport SK+HD+GS",
    Default = Settings.autoskhd,
    Callback = function(value)
        getgenv().AutoSeaKing = value
        Settings.autoskhd = value
        SaveSettings()
        if not value then ngungstop() return end
        
        spawn(function()
            while getgenv().AutoSeaKing do
                pcall(function()
                    stop()
                    local player = game.Players.LocalPlayer
                    local workspaceIsland = game:GetService("Workspace").Island
                    local workspace = game:GetService("Workspace")
                    local seaKing = workspace.SeaMonster:FindFirstChild("SeaKing")
                    local hydra = workspace.SeaMonster:FindFirstChild("HydraSeaKing")
                    local gs = workspace.GhostMonster:FindFirstChild("Ghost Ship")

                    local skHealth = seaKing and seaKing:FindFirstChild("Humanoid") and seaKing.Humanoid.Health or 0
                    local hydraHealth = hydra and hydra:FindFirstChild("Humanoid") and hydra.Humanoid.Health or 0
                    local gsHealth = gs and gs:FindFirstChild("Humanoid") and gs.Humanoid.Health or 0

                    -- 🔹 Nếu tất cả đều chết hoặc không tồn tại, dịch chuyển đến các vị trí loot
                    if (not seaKing or skHealth <= 0) and (not hydra or hydraHealth <= 0) and (not gs or gsHealth <= 0) then
                        
                        -- 🔹 Dịch chuyển vào Hydra Stand
                        for _, name in ipairs({"Sea King Thunder", "Sea King Water", "Sea King Lava"}) do
                            local island = workspaceIsland:FindFirstChild(name)
                            if island and island:FindFirstChild("HydraStand") then
                                
                                player.Character.HumanoidRootPart.CFrame = island.HydraStand.CFrame*CFrame.new(0,0,0)
                                
                            end
                        end                     

                        -- 🔹 Dịch chuyển vào Sea King ChestSpawner
                        local legacyIslands = {"Legacy Island1", "Legacy Island2", "Legacy Island3", "Legacy Island4"}
                        for _, islandName in ipairs(legacyIslands) do
                            local island = workspaceIsland:FindFirstChild(islandName)
                            if island and island:FindFirstChild("ChestSpawner") then
                                player.Character.HumanoidRootPart.CFrame = island.ChestSpawner.CFrame*CFrame.new(0,0,0)
                                
                            end
                        end

local totalChests = 0
for i = 1, 5 do
    if workspace:FindFirstChild("Chest" .. i) then
        totalChests = totalChests + 1
    end
end

local collected = 0
for i = 1, 5 do
    local chest = workspace:FindFirstChild("Chest" .. i)
    if chest and chest:FindFirstChild("Top") then
        player.Character.HumanoidRootPart.CFrame = chest.Top.CFrame
        task.wait(1)
        collected = collected + 1
    end
end

if collected == totalChests then
    return -- Chỉ thoát khi đã nhặt tất cả rương có trong game
end
                    else
                        -- 🔹 Nếu có Boss, dịch chuyển lên trên đầu Sea King
                        if getBossRoot() then
                            player.Character.HumanoidRootPart.CFrame = getBossRoot().CFrame * CFrame.new(0, -10, 100)
                        end
                    end
                end)
                task.wait(1) -- Để tránh treo vòng lặp
            
            end
        end)
    end
})
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fileName = "teleported_servers.txt"
local visitedServers = {}
local serverList = {}

if isfile(fileName) then
    for id in string.gmatch(readfile(fileName), "[^\n]+") do
        visitedServers[id] = true
        table.insert(serverList, id)
    end
end

local function saveTeleportedServers(jobId)
    if not visitedServers[jobId] then
        visitedServers[jobId] = true
        table.insert(serverList, jobId)
        writefile(fileName, table.concat(serverList, "\n"))
    end
end

local function removeOldestServer()
    if #serverList > 0 then
        local removedId = table.remove(serverList, 1)
        visitedServers[removedId] = nil
        writefile(fileName, table.concat(serverList, "\n"))
    end
end

local function getServerUptime(server)
    return os.time() - server.CreatedAt
end

local function findValidServer()

    local networkModule = game.ReplicatedStorage.Chest.Assets.Modules.Network
    local servers = networkModule.ClientNetwork.GetServerLists:InvokeServer()

    if type(servers) ~= "table" or not next(servers) then
        return nil
    end

    local validServers = {
        group1={},group2={},group3={},group4={},group5={},group6={},
        group7={},group8={},group9={},group10={},group11={},group12={}
    }

    local currentJobId = game.JobId
    local currentPlaceId = game.PlaceId

    for _, server in pairs(servers) do
        if type(server) == "table"
        and server.CreatedAt
        and server.JobId
        and server.PlayerCount
        and server.PlaceId then

            local uptime = getServerUptime(server)
            local jobId = server.JobId
            local players = server.PlayerCount

            if server.PlaceId == currentPlaceId
            and jobId ~= currentJobId
            and not visitedServers[jobId]
            and players > 0
            and players < 13 then

                if uptime >= 4*60*60 + 21*60 and uptime <= 4*60*60 + 30*60 then
                    table.insert(validServers.group1, server)

                elseif uptime >= 8*60*60 + 52*60 and uptime <= 9*60*60 + 1*60 then
                    table.insert(validServers.group2, server)

                elseif uptime >= 59*60 + 1 and uptime <= 1*60*60 + 7*60 then
                    table.insert(validServers.group3, server)

                elseif uptime >= 2*60*60 + 7*60 and uptime <= 2*60*60 + 14*60 then
                    table.insert(validServers.group4, server)

                elseif uptime >= 3*60*60 + 14*60 and uptime <= 3*60*60 + 21*60 then
                    table.insert(validServers.group5, server)

                elseif uptime >= 5*60*60 + 31*60 and uptime <= 5*60*60 + 37*60 then
                    table.insert(validServers.group6, server)

                elseif uptime >= 13*60*60 + 28*60 and uptime <= 13*60*60 + 35*60 then
                    table.insert(validServers.group7, server)

                elseif uptime >= 18*60*60 + 10*60 and uptime <= 18*60*60 + 17*60 then
                    table.insert(validServers.group8, server)

                elseif uptime >= 7*60*60 + 45*60 and uptime <= 7*60*60 + 52*60 then
                    table.insert(validServers.group9, server)

                elseif uptime >= 6*60*60 + 38*60 and uptime <= 6*60*60 + 45*60 then
                    table.insert(validServers.group10, server)

                elseif uptime >= 10*60*60 + 3*60 and uptime <= 10*60*60 + 9*60 then
                    table.insert(validServers.group11, server)

                elseif uptime >= 11*60*60 + 11*60 and uptime <= 11*60*60 + 17*60 then
                    table.insert(validServers.group12, server)
                end
            end
        end
    end

    math.randomseed(tick())

    local priorityGroups = {
        "group1","group2","group3","group4","group5","group6",
        "group7","group8","group9","group10","group11","group12"
    }

    for _, group in ipairs(priorityGroups) do
        if #validServers[group] > 0 then
            return validServers[group][math.random(#validServers[group])]
        end
    end

    return nil
end

-- 🏆 Hàm Teleport() mới
local function Teleport()
    
        local selectedServer = findValidServer()
        if selectedServer then
            saveTeleportedServers(selectedServer.JobId)
            th.New("Đang Tìm Server")
            TeleportService:TeleportToPlaceInstance(selectedServer.PlaceId, selectedServer.JobId, game.Players.LocalPlayer)
            
        else
            removeOldestServer()
            
            th.New("Đang Tìm Server Nâng Cao",5)
         
        
    end
end

local waitedOnce = false -- Đánh dấu đã chờ 10s chưa
local initialBeli = game.Players.LocalPlayer:WaitForChild("PlayerStats"):WaitForChild("beli").Value
 local initialGem = game.Players.LocalPlayer:WaitForChild("PlayerStats"):WaitForChild("Gem").Value
sTab:AddToggle({
    Name = "Auto Hop Thông Minh | Beta (Sea King, Hydra)",
    Default = Settings.autoskhdhop,
    Callback = function(value)
        getgenv().SeaKinghop = value
        Settings.autoskhdhop = value
        SaveSettings()
        if not value then return end

        spawn(function()
            while getgenv().SeaKinghop do
                task.wait(0.6) -- Giảm xuống 0.1 giây để kiểm tra nhanh hơn

                local Workspace = game:GetService("Workspace")
                local workspaceIsland = Workspace.Island -- Định nghĩa workspaceIsland
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local PlayerStats = LocalPlayer.PlayerStats
                local MainGui = LocalPlayer.PlayerGui.MainGui
                local SecondSea = MainGui.StarterFrame.LegacyPoseFrame.SecondSea
                -- Lấy đối tượng trong game
                local seaKing = Workspace.SeaMonster:FindFirstChild("SeaKing")
                local hydra = Workspace.SeaMonster:FindFirstChild("HydraSeaKing")
                local gs = Workspace.GhostMonster:FindFirstChild("Ghost Ship")

                -- Lấy thời gian spawn từ GUI
                local skTimeLabel = SecondSea:FindFirstChild("SKTimeLabel")
                local gsTimeLabel = SecondSea:FindFirstChild("GSTimeLabel")

                local function ConvertTimeToSeconds(timeStr)
                    local h, m, s = timeStr:match("(%d+):(%d+):(%d+)")
                    if h and m and s then
                        return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
                    end
                    return 9999
                end

                local skSpawnTime = skTimeLabel and ConvertTimeToSeconds(skTimeLabel.Text) or 9999
                local gsSpawnTime = gsTimeLabel and ConvertTimeToSeconds(gsTimeLabel.Text) or 9999

local function spamTeleport()
    coroutine.wrap(function()
        while getgenv().SeaKinghop do
            local success = pcall(function()
                -- Gọi hàm Teleport ở đây
                Teleport()
            end)
            
            -- Nếu teleport thành công, thoát vòng lặp
            if success then
                break
            end

            task.wait(0.2)
        end
    end)()
end
                -- Kiểm tra thời gian spawn và quyết định hop
                if skSpawnTime < Settings.HopThreshold then
                    th.New("Sea King hoặc Hydra spawn sau " .. skSpawnTime .. " giây, không hop!", 1)
                    task.wait()
                elseif gsSpawnTime < Settings.HopThreshold then
                    th.New("Ghost Ship spawn sau " .. gsSpawnTime .. " giây, không hop!", 1)
                    task.wait()
                elseif gs and gs:FindFirstChild("HumanoidRootPart") then
                    th.New("Ghost Ship đang hiện diện, không hop!", 1)
                    task.wait()
                elseif getBossRoot() then
                    th.New("Boss đang hiện diện, không hop!", 1)
                    task.wait()
                else

                    local hasSeaKing = false
                    
                    for _, islandName in ipairs({"Legacy Island1", "Legacy Island2", "Legacy Island3", "Legacy Island4"}) do
                        local island = workspaceIsland:FindFirstChild(islandName)
                        if island and island:FindFirstChild("ChestSpawner") then
                            hasSeaKing = true -- Có ChestSpawner
                
                        end
                    
                    end

                    local hasHydraStand = false
                    
                    for _, name in ipairs({"Sea King Thunder", "Sea King Water", "Sea King Lava"}) do
                        local island = workspaceIsland:FindFirstChild(name)
                        if island then
                            if island:FindFirstChild("HydraStand") then
                                hasHydraStand = true -- Có HydraStand
                            end
                            
                        end
                        
                    end

                    local hasGhostShipChest = false
                    local ghostShipChest = Workspace:FindFirstChild("Chest1")
                    if ghostShipChest then
                        hasGhostShipChest = true
                    end

                    -- Kiểm tra ngoài hasCollectedChest
                    if not hasSeaKing and not hasHydraStand and not hasGhostShipChest and not hydra and (not gs or not gs:FindFirstChild("HumanoidRootPart") or not seaKing:FindFirstChild("HumanoidRootPart")) then

                            spamTeleport()
                     
                    else
                        -- Nếu có Sea King, Hydra hoặc rương, kiểm tra thu thập trong hasCollectedChest
                        local function hasCollectedChest()
                            
                            local timeout = 220 -- Timeout 5 giây
                            local elapsedTime = 0

                            -- Chờ nhặt rương
                            while elapsedTime < timeout do
                                task.wait(0.1)
                                elapsedTime = elapsedTime + 0.1

                                local currentBeli = PlayerStats.beli.Value
                                local currentGem = PlayerStats.Gem.Value

                                -- Kiểm tra nếu nhặt được rương (dựa trên Beli/Gem)
                                if (hasSeaKing or hasSeaKingChest or hasHydraStand or hasHydraChest) and currentBeli > initialBeli and currentGem > initialGem then
                                    
                                    return true
                                elseif hasGhostShipChest then
                                    th.New("Đã nhặt rương Ghost Ship!", 2)
                                    
                                    return true
                                end

                                -- Kiểm tra lại Sea King, Hydra, và rương để thoát sớm nếu đảo chìm
                                hasSeaKing = false
                                hasSeaKingChest = false
                                for _, islandName in ipairs({"Legacy Island1", "Legacy Island2", "Legacy Island3", "Legacy Island4"}) do
                                    local island = workspaceIsland:FindFirstChild(islandName)
                                    if island and island:FindFirstChild("ChestSpawner") then
                                        hasSeaKing = true
                                        for _, v in pairs(island.ChestSpawner:GetChildren()) do
                                            if v:IsA("Model") and v.Name:match("Chest$") then
                                                hasSeaKingChest = true
                                                break
                                            end
                                        end
                                    end
                                    if hasSeaKingChest then break end
                                end

                                hasHydraStand = false
                                hasHydraChest = false
                                for _, name in ipairs({"Sea King Thunder", "Sea King Water", "Sea King Lava"}) do
                                    local island = workspaceIsland:FindFirstChild(name)
                                    if island then
                                        if island:FindFirstChild("HydraStand") then
                                            hasHydraStand = true
                                        end
                                        for _, chest in ipairs(island:GetChildren()) do
                                            if chest:IsA("Model") and chest.Name:match("Chest$") then
                                                hasHydraChest = true
                                                break
                                            end
                                        end
                                    end
                                    if hasHydraChest then break end
                                end

                                local ghostShipChestCheck = Workspace:FindFirstChild("Chest1")
                                if ghostShipChestCheck and ghostShipChestCheck:FindFirstChild("Top") then
                                    hasGhostShipChest = true
                                end

                                local seaKingCheck = Workspace.SeaMonster:FindFirstChild("SeaKing")
                                local hydraCheck = Workspace.SeaMonster:FindFirstChild("HydraSeaKing")
                                local gsCheck = Workspace.GhostMonster:FindFirstChild("Ghost Ship")

                                -- Thoát sớm nếu không còn rương hoặc boss (đảo chìm)
                                if not hasSeaKing and not hasSeaKingChest and not hasHydraStand and not hasHydraChest and not hasGhostShipChest and not seaKingCheck and not hydraCheck and (not gsCheck or not gsCheck:FindFirstChild("HumanoidRootPart")) then
                                    
                                    return false
                                end
                            end

                            
                            return false
                        end

                        -- Thực hiện hop dựa trên kết quả nhặt rương
                        if hasCollectedChest() then
                        
                            
                            spamTeleport() -- Bỏ  để hop ngay
                        else
                            th.New("Không nhặt được rương, dịch chuyển ngay!", 2)
                            spamTeleport()
                        end
                    end
                end
            end
        end)
    end
})
sTab:AddSlider({
    Name = "Thời gian Chờ GS+HD+SK (giây)",
    Min = 0,
    Max = 300,
    Default = Settings.HopThreshold,
    Increment = 5,
    ValueName = "giây",
    Callback = function(value)
        Settings.HopThreshold = value
        SaveSettings()
    end
})


local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local fruitStorage = replicatedStorage:FindFirstChild("Chest") and replicatedStorage.Chest:FindFirstChild("Fruits")

getgenv().AutoStoreFruit = false -- Biến toggle chính


function ClickButton(path)
    if path then
        game:GetService("GuiService").SelectedObject = path
        if game:GetService("GuiService").SelectedObject == path then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, 13, false, game)
            task.wait()
            game:GetService("VirtualInputManager"):SendKeyEvent(false, 13, false, game)
        end
        task.wait()
        game:GetService("GuiService").SelectedObject = nil
    end
end



-- Hàm ăn trái cây (nếu đang cầm)
local function EatFruit()
    local character = player.Character
    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function()
            local button = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EatFruitBecky") 
                and game.Players.LocalPlayer.PlayerGui.EatFruitBecky:FindFirstChild("Dialogue") 
                and player.PlayerGui.EatFruitBecky.Dialogue:FindFirstChild("Collect")

            if button then
                ClickButton(button)
          
            end
        end)
    end
end

-- Hàm kiểm tra và cất trái cây vào kho
local function StoreFruit()
    spawn(function()
        while getgenv().AutoStoreFruit do
            task.wait(.5)

            local fruitStore = player.PlayerStats:FindFirstChild("FruitStore")
            local fruitStorageLimit = player.PlayerStats:FindFirstChild("FruitStorage")

            if not fruitStore or not fruitStorageLimit then
                warn("Không tìm thấy FruitStore hoặc FruitStorage!")
                return
            end

            local storedFruits = game:GetService("HttpService"):JSONDecode(fruitStore.Value)
            local storageLimit = fruitStorageLimit.Value
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character

            if not backpack or not character then return end

            -- Kiểm tra các trái cây trong storage
            for _, fruit in ipairs(fruitStorage:GetChildren()) do
                if not getgenv().AutoStoreFruit then return end

                local fruitName = fruit.Name
                local currentAmount = storedFruits[fruitName] or 0

                if currentAmount < storageLimit then
                    local foundFruit = backpack:FindFirstChild(fruitName)

                    if foundFruit then
                    

                        -- Chỉ cầm 1 trái duy nhất
                        foundFruit.Parent = character
                        task.wait(0.5) -- Đợi cập nhật

                        -- Mở giao diện cất fruit
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(300, 300))
                        task.wait(1.5) -- Đợi giao diện mở ra

                        -- Cất Fruit (hàm EatFruit thực hiện việc cất)
                        EatFruit()
game:GetService("VirtualUser"):ClickButton1(Vector2.new(300, 300))
                        task.wait(1.5) -- Đợi giao diện mở ra
                        -- Đợi đến khi trái được cất hoàn toàn mới tiếp tục
                        local startTime = tick()
                        while (backpack:FindFirstChild(fruitName) or character:FindFirstChild(fruitName)) and (tick() - startTime < 5) do
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)
end

sTab:AddToggle({
    Name = "Auto Cất Fruit",
    Default = Settings.autocat,
    Callback = function(Value)
        Settings.autocat = Value
        SaveSettings()
        getgenv().AutoStoreFruit = Value
        if Value then
            StoreFruit()
        end
    end
})
end
if not sea(4) then 
local TradeTab = Window:MakeTab({Name = "Auto TradeV1 | Beta", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local AutoSendEnabled = false
local AutoAcceptEnabled = false
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TradeRequester = ReplicatedStorage.Chest.Remotes.Functions.TradeRequester
local TradeFunction = ReplicatedStorage.Chest.Remotes.Functions.TradeFunction

TradeTab:AddTextbox({
    Name = "Thêm Tư Bản",
    Default = "", -- Hiển thị danh sách hiện tại
    TextDisappear = true,
    Callback = function(Value)
        if Value ~= "" and not table.find(Settings.SpecialTraders, Value) then
            table.insert(Settings.SpecialTraders, Value)
            SaveSettings()
            StarterGui:SetCore("SendNotification", {
                Title = "Thông báo",
                Text = "Đã thêm " .. Value,
                Duration = 3
            })
        end
    end
})

TradeTab:AddButton({
    Name = "Hiển Thị Các Tư Bản",
    Callback = function()
        if #Settings.SpecialTraders == 0 then
            StarterGui:SetCore("SendNotification", {
                Title = "Thông báo",
                Text = "Danh sách trống!",
                Duration = 3
            })
            return
        end

        local Func = Instance.new("BindableFunction")
        function Func.OnInvoke()
        --[[
            table.clear(Settings.SpecialTraders) -- Xóa danh sách
             -- Cập nhật file lưu trữ
            ]]
            
            Settings.SpecialTraders = {}
            SaveSettings()
            StarterGui:SetCore("SendNotification", {
                Title = "Thông báo",
                Text = "Đã xóa tất cả người đặc biệt!",
                Duration = 3
            })
        end

        StarterGui:SetCore("SendNotification", {
            Title = "Tư Bản",
            Text = table.concat(Settings.SpecialTraders, ", "),
            Duration = 5,
            Callback = Func,
            Button1 = "Xóa tất cả"
        })
    end
})
TradeTab:AddToggle({
    Name = "Auto Chấp Nhận Trade từ bạn bè",
    Default = Settings.autochapnhan,
    Callback = function(State)
        AutoAcceptEnabled = State
        Settings.autochapnhan = State
        SaveSettings()
        if State then
            task.spawn(function()
                while AutoAcceptEnabled do
                    task.wait(3)
                    local tradeRequests = TradeRequester:InvokeServer("Get")
                    if tradeRequests then
                        for playerName, isRequesting in pairs(tradeRequests) do
                            if isRequesting then
                                local player = Players:FindFirstChild(playerName)
                                if player and Players.LocalPlayer:IsFriendsWith(player.UserId) then
                                    TradeRequester:InvokeServer("Accept", {["TargetName"] = playerName})
                                    StarterGui:SetCore("SendNotification", {
                                        Title = "Auto Accept",
                                        Text = "Đã chấp nhận trade từ " .. playerName,
                                        Duration = 3
                                    })
                                    
                                    -- Kiểm tra và ready nếu chưa
                                    task.spawn(function()
                                        while Players.LocalPlayer.TradeWith.Value == playerName do
                                            local readyFrame = Players.LocalPlayer.PlayerGui.MainGui.StarterFrame.TradingFrame.MainFrame.Ready1
                                            if not readyFrame.Visible then
                                                pcall(function()
                                                    TradeFunction:InvokeServer("Ready")
                                                end)
                                            end
                                            task.wait(1)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})


local requiredItems = {"Hydra's Tail", "Sea King's Fin", "Sea's Wraith", "Sea King's Blood"}

local function CheckInventory()
    local Inventory
    local success = pcall(function()
        Inventory = HttpService:JSONDecode(Players.LocalPlayer.PlayerStats.Material.Value)
    end)

    if not success or not Inventory then
        warn("Không thể đọc Inventory hoặc Inventory rỗng!")
        return false
    end

    for _, item in ipairs(requiredItems) do
        if Inventory[item] and Inventory[item] > 0 then
            return true -- Có ít nhất một item trong danh sách
        end
    end

    return false -- Không có item nào
end

local function IsItemAdded(itemName)
    local tradeFrame = Players.LocalPlayer.PlayerGui.MainGui.StarterFrame.TradingFrame.MainFrame.Player1_Offer
    return tradeFrame:FindFirstChild(itemName) ~= nil
end

local function IsReady()
    local readyFrame = Players.LocalPlayer.PlayerGui.MainGui.StarterFrame.TradingFrame.MainFrame.Ready1
    return readyFrame.Visible
end

local function ReadyTrade()
    while Players.LocalPlayer.TradeWith.Value ~= "" do
        if not IsReady() then
            pcall(function()
                TradeFunction:InvokeServer("Ready")
            end)
        end
        task.wait(1)
    end
end

local function AddItemsAndReady()
    if not AutoSendEnabled then return end

    local currentTrader = Players.LocalPlayer.TradeWith.Value
    if currentTrader == "" or not table.find(Settings.SpecialTraders, currentTrader) then return end

    local Inventory
    local invSuccess = pcall(function()
        Inventory = HttpService:JSONDecode(Players.LocalPlayer.PlayerStats.Material.Value)
    end)

    if not invSuccess or not Inventory then
        warn("Không thể đọc Inventory hoặc Inventory rỗng!")
        return
    end

    for _, item in ipairs(requiredItems) do
        if Inventory[item] and Inventory[item] > 0 and not IsItemAdded(item) then
            pcall(function()
                TradeFunction:InvokeServer("PutItem", {ItemName = item, Amt = math.huge, Add = true})
            end)
            task.wait(0.7)
        end
    end

    task.spawn(ReadyTrade)
end

TradeTab:AddToggle({
    Name = "Auto Gửi Trade Tư Bản Và Add Item",
    Default = Settings.autotrade,
    Callback = function(State)
        AutoSendEnabled = State
        Settings.autotrade = State
        SaveSettings()
        if State then
            task.spawn(function()
                while AutoSendEnabled do
                    task.wait(2)
                    if CheckInventory() then -- Kiểm tra kho trước khi gửi trade
                        for _, specialTrader in ipairs(Settings.SpecialTraders) do
                            if Players.LocalPlayer.TradeWith.Value == "" then
                                local success = pcall(function()
                                    TradeRequester:InvokeServer("Invite", {TargetName = specialTrader})
                                end)
                                if success then
                                    task.wait(2) -- Chờ để đảm bảo trade diễn ra
                                    AddItemsAndReady()
                                end
                            end
                        end
                    else
                        StarterGui:SetCore("SendNotification", {
                            Title = "Auto Trade",
                            Text = "Không có đủ item để trade!",
                            Duration = 3
                        })
                    end
                end
            end)
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoSendEnabled and Players.LocalPlayer.TradeWith.Value ~= "" then
            AddItemsAndReady()
        end
    end
end)
TradeTab:AddButton({
    Name = "Xoá File Save TestHubV2",
    Callback = function()
    if isfolder("TestHubSaveKingLegacy") then
    delfolder("TestHubSaveKingLegacy")
           StarterGui:SetCore("SendNotification", {
                            Title = "Thông báo",
                            Text = "Đã Xóa File Save",
                            Duration = 3
                        })
                        end
    end
    })
end
local Tab = Window:MakeTab({
    Name = "Raid",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Webhook_URL = "https://discord.com/api/webhooks/1217892100834852905/4aBabISkNZwD9IKl3dAZJVKp-TqzsDdsAKIG_j6yHRnJXvzhY11a1rQo-zvKWI5e5bVL" -- Thay URL Webhook của bạn
local HttpService = game:GetService("HttpService")
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local avatarUrls = {
    "https://i.imgur.com/CLXQeH6.jpeg",
    "https://i.imgur.com/XCawMZG.png",
    "https://i.imgur.com/h1iPjBY.jpeg",
    "https://i.imgur.com/gtePhRZ.jpeg"
}

-- Hàm chọn avatar ngẫu nhiên từ danh sách
local function getRandomAvatarUrl()
    local randomIndex = math.random(1, #avatarUrls) -- Chọn ngẫu nhiên chỉ số trong danh sách
    local selectedUrl = avatarUrls[randomIndex] -- Avatar ngẫu nhiên
    return selectedUrl
end
local player = players.LocalPlayer

    local autoRaidActive = false

-- Tạo TextBox để nhập JobId

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Hàm gửi Webhook
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Hàm gửi Webhook
local function sendWebhook(reason)
    local payload = {
        content = "``` " .. game.Players.LocalPlayer.Name .. " | ".. Settings.jobId.. " - " .. reason .. "```",
        username = "🔴 Lỗi Tele",
        avatar_url = getRandomAvatarUrl()
    }

    local jsonPayload = HttpService:JSONEncode(payload)
    local response = httprequest({
        Url = Webhook_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonPayload
    })

    if response and response.Success then
        print("✅ Webhook đã gửi thành công!")
    else
        print("❌ Lỗi khi gửi webhook.")
    end
end

-- Hàm xử lý khi dịch chuyển thất bại
local function onTeleportFailed(placeId, teleportResult, errorMessage)
if not autoRaidActive then return end
    warn("Dịch chuyển thất bại:", errorMessage)

    local reason = "❌ Xảy Ra Lỗi Bất Thường"
    local shouldDeleteJobId = true

    if teleportResult == Enum.TeleportResult.GameFull then
        reason = "🟡 Server Full Không Thể Join"
        shouldDeleteJobId = false  -- KHÔNG xóa JobId nếu server đầy

    elseif teleportResult == Enum.TeleportResult.GameNotFound then
        reason = "🚫 Server Không Tồn Tại Sẽ Xoá JobId"

    elseif teleportResult == Enum.TeleportResult.Failure then
        reason = "⚠️ Lỗi Không Rõ Nguyên Nhân Sẽ Xoá JobId"

    elseif teleportResult == Enum.TeleportResult.Unauthorized then
        reason = "⛔ Không Có Quyền Vào Server Này"

    elseif teleportResult == Enum.TeleportResult.TeleportInProgress then
        reason = "🔄 Đang Trong Quá Trình Dịch Chuyển"

    elseif teleportResult == Enum.TeleportResult.Denied then
        reason = "🚷 Dịch Chuyển Bị Chặn (Có Thể Bị Ban Hoặc Hạn Chế)"

    elseif teleportResult == Enum.TeleportResult.Timeout then
        reason = "⏳ Kết Nối Dịch Chuyển Quá Hạn"

    elseif teleportResult == Enum.TeleportResult.Restricted then
        reason = "🔒 Server Có Giới Hạn (Yêu Cầu Cấp Độ Hoặc Nhóm Đặc Biệt)"

    elseif teleportResult == Enum.TeleportResult.Flooded then
        reason = "🌊 Spam Dịch Chuyển Quá Nhiều"

    elseif teleportResult == Enum.TeleportResult.IncompatiblePlace then
        reason = "❗ Server Không Hỗ Trợ Phiên Bản Hiện Tại"

    end

    -- Gửi thông báo lỗi lên màn hình
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "TestHubV2",
        Text = "Dịch Chuyển Thất Bại! " .. reason,
        Duration = 5
    })

    -- Gửi Webhook
    local function sendWebhook()
        local payload = {
            content = "```" .. game.Players.LocalPlayer.Name .. " | " .. (Settings.jobId or "Không có JobId") .. " Lỗi: " .. reason .. "```",
            username = "🔴 Lỗi Tele",
            avatar_url = getRandomAvatarUrl()
        }

        local jsonPayload = game:GetService("HttpService"):JSONEncode(payload)
        local response = httprequest({
            Url = Webhook_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonPayload
        })

        if response and response.Success then
            print("✅ Webhook đã gửi thành công!")
        else
            print("❌ Lỗi khi gửi webhook.")
        end
    end

    sendWebhook()

    -- Nếu không phải lỗi server đầy, xóa JobId và lưu lại cài đặt
    if shouldDeleteJobId and Settings.jobId and Settings.jobId ~= "" then
        Settings.jobId = ""
        SaveSettings()
        -- Dịch chuyển về server mặc định
        game:GetService("TeleportService"):Teleport(4520749081)
    end
end

game:GetService("TeleportService").TeleportInitFailed:Connect(onTeleportFailed)

Tab:AddToggle({
    Name = "Auto Raid",
    Default = Settings.teleraid,
    Callback = function(value)
        Settings.teleraid = value
        SaveSettings()
        autoRaidActive = value



        spawn(function()
            while autoRaidActive do
                task.wait(0.5)
                if Settings.jobId and Settings.jobId ~= "" then
                    PerformAutoRaid()
                    -- Kiểm tra nếu JobId trùng với server hiện tại
                    if game.JobId == Settings.jobId then
                    local webhookSentFlag = ReplicatedStorage:FindFirstChild("WebhookSentFlag")
if not webhookSentFlag then
    webhookSentFlag = Instance.new("BoolValue")
    webhookSentFlag.Name = "WebhookSentFlag"
    webhookSentFlag.Parent = ReplicatedStorage
end


-- Hàm gửi webhook
local function sendWebhook2()
    if webhookSentFlag.Value then
   
        return
    end

    webhookSentFlag.Value = true



    if not httprequest then
        print("Executor của bạn không hỗ trợ HTTP requests!")
        return
    end

    
    local payload = {
        ["content"] = Settings.jobId,
        ["username"] = "Server",
        ["avatar_url"] = getRandomAvatarUrl(),
        
        ["embeds"] = {{
            ["author"] = {
                ["name"] = game.Players.LocalPlayer.Name .. " | Age: " .. (game.Players.LocalPlayer.AccountAge or "???")
            },
            ["title"] = "🛜 Chung Server",
            ["description"] = description,
            ["color"] = color,
            ["fields"] = {
                { ["name"] = "Time Server And Code:", ["value"] = "```"..serverName.." | "..formatTime(uptime).."```", ["inline"] = true }
            }

        }}
    }

        

    local jsonPayload = HttpService:JSONEncode(payload)
    local response = httprequest({
        Url = Webhook_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonPayload
    })

    if response and response.Success then
        print("Webhook đã gửi thành công!")
    else
        print("Lỗi khi gửi webhook.")
        print("Mã lỗi: " .. (response and response.StatusCode or "nil"))
        print("Phản hồi từ Discord: " .. (response and response.Body or "nil"))
    end
end

-- Thực thi
sendWebhook2()
                        PerformAutoRaid()
                    else
                        -- Nếu không trùng, thử dịch chuyển
                        local success, message = pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, Settings.jobId, player)
                        end)

                        if not success then
                            warn("Lỗi dịch chuyển:", message)
                            -- Không cần tự xóa JobId ở đây vì sự kiện `TeleportInitFailed` sẽ xử lý
                            break
                        end
                    end
                else
                    -- Nếu không có JobId, thực hiện Auto Raid bình thường
                    PerformAutoRaid()
                end
            end
        end)
    end
})

-- Hàm thực hiện Auto Raid
function PerformAutoRaid()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if sea(3) then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(2060.04834, 52.2012825, 819.725769)
        elseif sea(1) then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-608.27124, 72.6492844, -3599.53467)
        elseif sea(2) then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-4590.01855, 222.165771, -71.6240616)
        end
    else
        repeat task.wait(0.5) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    end

    if Settings.jobId and Settings.jobId ~= "" and not hasSentNotification then
        
        StarterGui:SetCore("SendNotification", {
            Title = "TestHubV2",
            Text = "Auto Raid Chung Server JobId: " .. Settings.jobId,
            Duration = 5
        })
        hasSentNotification = true
    end
end
local hasSentNotification = false  -- Biến này đảm bảo thông báo chỉ gửi một lần




-- Reset lại biến hasSentNotification sau một khoảng thời gian
game:GetService("RunService").Heartbeat:Connect(function()
    if not autoRaidActive then
        hasSentNotification = false  -- Reset lại nếu Auto Raid không còn hoạt động
    end
end)

Tab:AddTextbox({
    Name = "Nhập JobId Hoặc Code Server Để Raid Chung",
    Default = "",
    TextDisappear = false,
    Callback = function(inputValue)
        if Settings.jobId and Settings.jobId ~= "" then
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Bạn đã có JobId! Hãy xóa trước khi nhập mới.",
                Duration = 5
            })
            return
        end

        local networkModule = game.ReplicatedStorage.Chest.Assets.Modules.Network
        local servers = networkModule.ClientNetwork.GetServerLists:InvokeServer()
        local foundJobId = nil

        -- Kiểm tra nếu nhập là JobId (chuỗi dài hơn 10 ký tự, chỉ gồm chữ cái/số)
        if string.match(inputValue, "^[%w-]+$") and #inputValue > 10 then
            Settings.jobId = inputValue
            SaveSettings()
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Đã lưu JobId: " .. inputValue,
                Duration = 5
            })
            return
        end

        -- Kiểm tra nếu nhập là 4 số cuối (#1234)
        if string.match(inputValue, "^%d%d%d%d$") then
            local last4Digits = inputValue:gsub("#", "")  -- Lấy 4 số cuối
            for _, server in pairs(servers) do
                if type(server) == "table" and server.ServerName:match("#"..last4Digits.."$") then
                    foundJobId = server.JobId
                    break
                end
            end
        else
            -- Kiểm tra nếu nhập cả tên server + số (#1234)
            for _, server in pairs(servers) do
                if type(server) == "table" and server.ServerName == inputValue then
                    foundJobId = server.JobId
                    break
                end
            end
        end

        -- Nếu tìm thấy JobId của server, lưu vào Settings
        if foundJobId then
            Settings.jobId = foundJobId
            SaveSettings()
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Đã tìm thấy JobId của server: " .. inputValue,
                Duration = 5
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Không tìm thấy server: " .. inputValue,
                Duration = 5
            })
        end
    end
})
Tab:AddButton({
    Name = "Xoá JobId Server Raid Chung",
    Callback = function()
        if Settings.jobId ~= "" then
            -- Tạo một BindableFunction để xử lý phản hồi từ người dùng
            local Func = Instance.new("BindableFunction")

            function Func.OnInvoke(buttonClicked)
                if buttonClicked == "Có" then
                    -- Xóa JobId nếu người dùng chọn "Có"
                    Settings.jobId = ""
                    SaveSettings()
                    StarterGui:SetCore("SendNotification", {
                        Title = "Thông Báo",
                        Text = "Đã xoá JobId thành công!",
                        Duration = 3
                    })
                else
                    -- Nếu chọn "Không"
                    StarterGui:SetCore("SendNotification", {
                        Title = "Thông Báo",
                        Text = "Hủy xoá JobId.",
                        Duration = 3
                    })
                end
            end

            -- Hiển thị thông báo xác nhận với hai nút
            StarterGui:SetCore("SendNotification", {
                Title = "Xác Nhận Xoá",
                Text = "Bạn có chắc muốn xóa JobId này?\n" .. Settings.jobId,
                Duration = 5,
                Callback = Func,
                Button1 = "Có",
                Button2 = "Không"
            })
        else
            -- Không có JobId để xóa
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Không có JobId để xóa.",
                Duration = 3
            })
        end
    end
})

local Section = Tab:AddSection({
	Name = "White List"
})
local whitelistFile = "whitelist.json"
local whitelist = {}
local targetPlaceId = 4520749081
local warningTriggered = false
local canceled = false
local checking = false
local autoTeleportRunning = false
local autoWhitelistEnabled = false

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Hàm lưu danh sách whitelist vào file
local function saveWhitelist()
    local jsonData = HttpService:JSONEncode(whitelist)
    writefile(whitelistFile, jsonData)
end

-- Hàm tải danh sách whitelist từ file
local function loadWhitelist()
    if isfile(whitelistFile) then
        local jsonData = readfile(whitelistFile)
        whitelist = HttpService:JSONDecode(jsonData)
    else
        whitelist = {}
    end
end

-- Hàm thêm người vào whitelist
local function addToWhitelist(playerName)
    if not table.find(whitelist, playerName) then
        table.insert(whitelist, playerName)
        saveWhitelist()
    end
end

-- Hàm xóa người khỏi whitelist
local function removeFromWhitelist(playerName)
    for i, name in ipairs(whitelist) do
        if name == playerName then
            table.remove(whitelist, i)
            saveWhitelist()
            return true
        end
    end
    return false
end

-- Hàm hiển thị danh sách whitelist
local function showWhitelist()
    if #whitelist == 0 then
        StarterGui:SetCore("SendNotification", {
            Title = "Whitelist",
            Text = "Không có người nào trong whitelist.",
            Duration = 5
        })
        return
    end

    for _, playerName in ipairs(whitelist) do
        local Func = Instance.new("BindableFunction")

        function Func.OnInvoke(buttonClicked)
            if buttonClicked == "Xóa" then
                local removed = removeFromWhitelist(playerName)
                if removed then
                    StarterGui:SetCore("SendNotification", {
                        Title = "Whitelist",
                        Text = playerName .. " đã bị xóa khỏi whitelist.",
                        Duration = 5
                    })
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "Lỗi",
                        Text = "Không thể xóa " .. playerName .. " khỏi whitelist.",
                        Duration = 5
                    })
                end
            end
        end

        StarterGui:SetCore("SendNotification", {
            Title = "Người Trong Whitelist",
            Text = playerName,
            Duration = 4,
            Button1 = "Xóa",
            Callback = Func
        })
    end
end

-- Hàm kiểm tra "Live"
local function checkLive()
    local success, liveValue = pcall(function()
        return player:FindFirstChild("Live") and player.Live.Value
    end)
    return success and liveValue == 0 -- Trả về true nếu "Live" là 0
end

-- Hàm kiểm tra người chơi khác trong server
local function checkOtherPlayers()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and not table.find(whitelist, otherPlayer.Name) then
            return true -- Phát hiện người chơi khác không trong whitelist
        end
    end
    return false -- Không có người chơi khác
end

local function autoWhitelistFriends()
    while autoWhitelistEnabled do
        task.wait(3) -- Kiểm tra mỗi 3 giây
        pcall(function()
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer:IsFriendsWith(player.UserId) then
                    if not table.find(whitelist, otherPlayer.Name) then
                        addToWhitelist(otherPlayer.Name)

                        -- Lấy URL avatar từ Roblox
                        local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. otherPlayer.UserId .. "&width=150&height=150&format=png"

                        -- Hiển thị thông báo với avatar
                        StarterGui:SetCore("SendNotification", {
                            Title = "Whitelist",
                            Text = "Bạn bè " .. otherPlayer.Name .. " đã được thêm vào whitelist.",
                            Duration = 5,
                            Icon = avatarUrl -- Executor có thể hiển thị ảnh với cách này
                        })
                    end
                end
            end
        end)
    end
end
-- Hàm dịch chuyển đến PlaceId
local function teleportToPlace()
    TeleportService:Teleport(targetPlaceId, player)
end

-- Vòng lặp kiểm tra điều kiện
local function autoCheck()
    if checking then return end
    if not sea(4) then return end
    checking = true
    autoTeleportRunning = true

    spawn(function()
        while getgenv().autoTeleport do
            task.wait(1)
            pcall(function()
                if canceled then
                    checking = false
                    autoTeleportRunning = false
                    return
                end

                if (checkOtherPlayers() or checkLive()) and not warningTriggered then
                    warningTriggered = true
                    canceled = false
                    local reason = checkOtherPlayers() and "Phát hiện người chơi khác không trong whitelist." or "Live của bạn bằng 0."

                    -- Hiện thông báo cảnh báo
                    StarterGui:SetCore("SendNotification", {
                        Title = "Cảnh Báo!",
                        Text = reason .. " Sẽ dịch chuyển sau 5 giây.",
                        Duration = 5
                    })

                    for i = 1, 5 do
                        task.wait(1)
                        if canceled then
                            warningTriggered = false
                            checking = false
                            autoTeleportRunning = false
                            return
                        end
                    end

                    if not canceled then
                        teleportToPlace()
                    end
                elseif not checkOtherPlayers() and not checkLive() then
                    warningTriggered = false
                end
            end)
        end

        checking = false
        autoTeleportRunning = false
    end)
end

-- Tải danh sách whitelist từ file khi script khởi động
loadWhitelist()

-- Tạo UI để thêm tên vào whitelist
Tab:AddTextbox({
    Name = "Thêm Người Vào Whitelist (Thủ Công)",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        if value and value ~= "" then
            addToWhitelist(value)
            StarterGui:SetCore("SendNotification", {
                Title = "Whitelist",
                Text = value .. " đã được thêm vào whitelist.",
                Duration = 5
            })
        end
    end
})

-- Tạo Button để hiển thị danh sách whitelist
Tab:AddButton({
    Name = "Hiển Thị Người Trong Whitelist",
    Callback = function()
        showWhitelist()
    end
})

-- Tạo Toggle Auto Whitelist bạn bè
Tab:AddToggle({
    Name = "Tự Động Thêm Bạn Bè Vào Whitelist",
    Default = Settings.autoWhitelist,
    Callback = function(value)
        Settings.autoWhitelist = value
        getgenv().autoWhitelist = value
        SaveSettings()

        autoWhitelistEnabled = value
        if value then
            spawn(autoWhitelistFriends)
        end
    end
})

-- Tạo Toggle Auto Teleport
Tab:AddToggle({
    Name = "Tự Động Dịch Chuyển Khi Chết Hoặc Có Người Lạ",
    Default = Settings.autoTeleport,
    Callback = function(value)
        Settings.autoTeleport = value
        getgenv().autoTeleport = value
        SaveSettings()

        if value then
            warningTriggered = false
            canceled = false
            if not autoTeleportRunning then
                autoCheck()
            end
        else
            canceled = true
            checking = false
            autoTeleportRunning = false
        end
    end
})
local Section = Tab:AddSection({
	Name = "Boost FPS Và Effect"
})
--[[
if not sea(1) then
local workspace = game.Workspace
local lighting = game:GetService("Lighting")
local renderSettings = settings().Rendering
local terrain = workspace.Terrain
local originalStates = {} -- Lưu trạng thái gốc
local descendantConnection -- Biến để lưu kết nối DescendantAdded

local function optimizeObject(v)
    pcall(function()
        if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
            originalStates[v] = originalStates[v] or { Transparency = v.Transparency }
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            originalStates[v] = originalStates[v] or { Enabled = v.Enabled }
            v.Enabled = false
        elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            originalStates[v] = originalStates[v] or { Enabled = v.Enabled }
            v.Enabled = false
        end
    end)
end

local function applyBoostFPS(state)
    if state then
        -- Bật tối ưu FPS
        for _, v in ipairs(workspace:GetDescendants()) do
            optimizeObject(v)
        end

        -- Tắt hiệu ứng đồ họa toàn cục
        workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
        workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
        renderSettings.EagerBulkExecution = false
        workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
        renderSettings.QualityLevel = Enum.QualityLevel.Level01

        -- Tắt nước
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0

        -- Cài đặt ánh sáng
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 0

        -- Tắt hiệu ứng ánh sáng
        for _, effect in ipairs(lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                originalStates[effect] = originalStates[effect] or { Enabled = effect.Enabled }
                effect.Enabled = false
            end
        end

        -- Theo dõi đối tượng mới
        if not descendantConnection then
            descendantConnection = workspace.DescendantAdded:Connect(optimizeObject)
        end
    else
        -- Tắt tối ưu, khôi phục trạng thái
        for v, state in pairs(originalStates) do
            pcall(function()
                if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = state.Transparency or 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = state.Enabled or true
                elseif v:IsA("PostEffect") then
                    v.Enabled = state.Enabled or true
                end
            end)
        end
        originalStates = {} -- Xóa trạng thái sau khi khôi phục

        -- Khôi phục cài đặt đồ họa
        workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Disabled
        workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Disabled
        renderSettings.EagerBulkExecution = true
        workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Enabled
        renderSettings.QualityLevel = Enum.QualityLevel.Automatic

        -- Khôi phục nước (giá trị mặc định Roblox)
        terrain.WaterWaveSize = 0.05
        terrain.WaterWaveSpeed = 10
        terrain.WaterReflectance = 0.3
        terrain.WaterTransparency = 0.5

        -- Khôi phục ánh sáng
        lighting.GlobalShadows = true
        lighting.FogEnd = 100000
        lighting.Brightness = 2

        -- Ngắt kết nối theo dõi
        if descendantConnection then
            descendantConnection:Disconnect()
            descendantConnection = nil
        end
    end
end

-- Cập nhật toggle
Tab:AddToggle({
    Name = "BOOST FPS",
    Default = Settings.fpsbut,
    Callback = function(value)
        Settings.fpsbut = value
        SaveSettings()
        applyBoostFPS(value)
    end
})

-- Đồng bộ trạng thái khi khởi động
task.defer(function()
    applyBoostFPS(Settings.fpsbut)
end)

end
]]
local deleteEffectConnection
local effectsFolder = game.Workspace:WaitForChild("Effects")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")  -- Dịch vụ Debris để tự động xóa đối tượng

Tab:AddToggle({
    Name = "Auto Giảm Effect",
    Default = Settings.autoDeleteEffects,
    Callback = function(value)
        Settings.autoDeleteEffects = value
        SaveSettings()  -- Lưu lại cài đặt sau khi thay đổi

        getgenv().autoDeleteEffects = value

        -- Nếu bật công tắc
        if getgenv().autoDeleteEffects then
            -- Kết nối với Heartbeat và kiểm tra mỗi giây
            deleteEffectConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    -- Kiểm tra nếu không tắt tính năng
                    if not getgenv().autoDeleteEffects then return end
                    
                    -- Thực hiện kiểm tra mỗi giây
                    if tick() % 0.2 < 0.1 then  -- Dùng tick() để kiểm tra mỗi giây
                        for _, effect in pairs(effectsFolder:GetChildren()) do
                            if effect:IsA("Part") and effect.Color ~= Color3.fromRGB(255, 0, 0) then
                                -- Thêm hiệu ứng vào Debris để xóa ngay lập tức
                                Debris:AddItem(effect, 0)
                            end
                        end
                    end
                end)
            end)
        -- Nếu tắt công tắc
        elseif deleteEffectConnection then
            deleteEffectConnection:Disconnect()
            deleteEffectConnection = nil
        end
    end
})
Tab:AddToggle({
    Name = "Xóa Effect",
    Default = Settings.eff, 
    Callback = function(state)
        Settings.eff = state
        SaveSettings() 
if state then
                   
            for _, v in pairs(game.ReplicatedStorage.Chest:GetChildren()) do
                if v.Name == "FruitEffect" or v.Name == "SwordEffect" then
                    v:Destroy()
                end
            end
        end
    end
})






Tab:AddToggle({
    Name = "Auto Start, Skip, Haki",
    Default = Settings.start,
    Callback = function(value)
    Settings.start = value
        
        SaveSettings()
        getgenv().start = value
        spawn(function()
        while getgenv().start do
        pcall(function()
            wait(1)
     if not value then return end
if game.Workspace.CharacterWorkshop:FindFirstChild(game.Players.LocalPlayer.Name.."ArmamentGroup") then

else
game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Armament"):FireServer()
end
if workspace.PlayerCharacters[game.Players.LocalPlayer.Name].Services.KenOpen.Value == false then

game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("KenEvent"):InvokeServer()

else

end
if sea(4) then
if game.Players.LocalPlayer.PlayerGui: WaitForChild("GoldenArena GUI"): FindFirstChild("StartButton")
then
game:GetService("ReplicatedStorage"):WaitForChild("GoldenArenaEvents"):WaitForChild("StartEvent"):FireServer()
end

            game:GetService("ReplicatedStorage"):WaitForChild("GoldenArenaEvents"):WaitForChild("SkipFunc"):InvokeServer() 
end
            end)
        end
        end)
    end
})
if not sea(4) then
local latTab = Window:MakeTab({
    Name = "Lặt Vặt",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Section = latTab:AddSection({
	Name = "Hoàng Anh"
})
latTab:AddTextbox({
    Name = "Webhook Theo Dõi Khi Gặp Rương Hoặc Khi Xong Raid",
    Default = Webhook_URL2,
    TextDisappear = false,
    Callback = function(value)
        if value and value:match("^https://discord.com/api/webhooks/") then
            Webhook_URL2 = value
            Settings.Webhook_URL2 = value
            SaveSettings()
            StarterGui:SetCore("SendNotification", {
                Title = "Webhook URL2",
                Text = "Đã lưu Webhook_URL2 thành công!",
                Duration = 5
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi Webhook",
                Text = "URL không hợp lệ!",
                Duration = 5
            })
        end
    end
})


latTab:AddToggle({
    Name = "Auto Vứt Fruit",
    Default = dropfruit,
    Callback = function(value)
        Settings.dropfruit = value
        SaveSettings()
        getgenv().AutoDrop = value
        local player = game:GetService("Players").LocalPlayer
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

local function DropFruit()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if not backpack or not humanoid or not character then return end

    local equippedTool = humanoid:FindFirstChildOfClass("Tool")

    -- Nếu không cầm Tool có "FakeHandle", thử trang bị từ Backpack
    if not (equippedTool and equippedTool:FindFirstChild("FakeHandle")) then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name ~= "LegacyPose" then
                humanoid:EquipTool(tool)
                task.wait(0.5)
                equippedTool = tool
                break
            end
        end
    end

    -- Nếu có Tool hợp lệ, nhấn chuột để mở giao diện
    if equippedTool and equippedTool:FindFirstChild("Handle") then
        print("Đang cầm:", equippedTool.Name)
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(50, 50))
        wait(1) -- Chờ UI xuất hiện
    end
if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(50, 50))
        wait(1) -- Chờ UI xuất hiện
    end

    -- Tìm và nhấn nút Drop
    local gui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("EatFruitBecky")
    local dropButton = gui and gui:FindFirstChild("Dialogue") and gui.Dialogue:FindFirstChild("Drop")

    if dropButton then
       
        ClickButton(dropButton)
    end

    wait(0.8)
end
        spawn(function()
            while getgenv().AutoDrop do
                DropFruit()
                wait()
            end
        end)
    end
})
latTab:AddButton({
    Name = "Unlock Passive",
    Callback = function()
    local player = game:GetService("Players").LocalPlayer
local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local passiveTree = game:GetService("Workspace"):FindFirstChild("AllNPC") and game.Workspace.AllNPC:FindFirstChild("PassiveTree")

local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage.Chest.Remotes.Functions.EtcFunction

if humanoidRootPart and passiveTree then
    -- Dịch chuyển đến cây
    humanoidRootPart.CFrame = passiveTree.CFrame*CFrame.new(10,10,0)
    wait(1) -- Chờ để đảm bảo dịch chuyển xong

    -- Gọi Remote
    local success, result = pcall(function()
        return remote:InvokeServer("Blessing Passive", {})
    end)

    
else
    th.New("Không Tìm Thấy PassiveTree",5)
end
    end
})
local selectedKey = "Copper Key"
local quantityToBuy = 1
local autoBuy = false

local keyTab = Window:MakeTab({
    Name = "Key Buying",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Dropdown chọn loại chìa khóa
keyTab:AddDropdown({
    Name = "Chọn Loại Chìa Khóa",
    Default = Settings.chonkey,
    Options = {"Copper Key", "Iron Key", "Gold Key","Platinum Key"},
    Callback = function(value)
    Settings.chonkey = value
    SaveSettings()
        selectedKey = value
    end
})

-- Slider điều chỉnh số lượng
keyTab:AddSlider({
    Name = "Số Lượng Cần Mua",
    Min = 1,
    Max = 100,
    Default = Settings.slkey,
    Color = Color3.fromRGB(255, 170, 0),
    Increment = 1,
    ValueName = "Số Lượng",
    Callback = function(value)
    Settings.slkey = value
    SaveSettings()
        quantityToBuy = value
    end
})

-- Nút nhấn mua chìa khóa
keyTab:AddButton({
    Name = "Mua Ngay",
    Callback = function()
    if selectedKey == "Platinum Key" then 
    th.New("Không Thể Mua Key Này❌")
    else
        local args = {
            [1] = selectedKey,
            [2] = quantityToBuy
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BuyKey"):InvokeServer(unpack(args))
end
    end
})

-- Công tắc tự động mua
keyTab:AddToggle({
    Name = "Tự Động Mua",
    Default = Settings.autobuy,
    Callback = function(state)
    if selectedKey == "Platinum Key" and state == true then 
    th.New("Không Thể Mua Key Này❌")
    end
        autoBuy = state
        Settings.autobuy = state
        SaveSettings()
        spawn(function()
            while task.wait(0.2) do
            if Settings.autobuy then
            if not state then return end
                local args = {
                    [1] = selectedKey,
                    [2] = quantityToBuy
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BuyKey"):InvokeServer(unpack(args))
                
            end
        end
    end)
    end
})
keyTab:AddToggle({
    Name = "Tự Động Mở Key Đã Chọn X10 ",
    Default = false,
    Callback = function(state)
    getgenv().autopen = state
        spawn(function()
            while task.wait() do
            if getgenv().autopen then
            if not state then return end
local args = {
    [1] = selectedKey,
    [2] = "Open10"
                }
game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("UseKey"):InvokeServer(unpack(args))

            end
        end
        end)
    end
})

-- 📌 Khai báo biến
local autoConvert = false -- Công tắc tự động chuyển đổi

-- 🏆 Lấy remote chuyển đổi Fruit sang Key
local remote = game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("DealFruit")

-- 📜 Lấy danh sách Fruit có thể chuyển đổi từ ReplicatedStorage
local availableFruits = {}
for _, fruit in ipairs(game:GetService("ReplicatedStorage").Chest.Fruits:GetChildren()) do
    table.insert(availableFruits, fruit.Name)
end

-- ❌ Danh sách Fruit cần loại trừ
local excludedFruits = {
    ["DoughFruit"] = true,
    ["GateFruit"] = true,
    ["DragonFruit"] = true,
    ["PhoenixFruit"] = true,
    ["ToyFruit"] = true,
    ["OpFruit"] = true
}

-- 🔍 Kiểm tra Backpack và tìm các Fruit hợp lệ
local function getFruitsInBackpack()
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return {} end

    local fruitsInBackpack = {}
    for _, item in ipairs(backpack:GetChildren()) do
        if table.find(availableFruits, item.Name) and not excludedFruits[item.Name] then
            table.insert(fruitsInBackpack, item.Name)
        end
    end

    return fruitsInBackpack
end

-- 🔄 Chuyển đổi Fruit sang Key
local function convertFruitsToKey()
    if not autoConvert then return end

    local fruitsToConvert = getFruitsInBackpack()
    if #fruitsToConvert > 0 then
        local args = {
            [1] = selectedKey, -- Chìa khóa đã chọn
            [2] = fruitsToConvert -- Danh sách Fruit hợp lệ
        }

        remote:InvokeServer(unpack(args))
        print("✅ Đã chuyển Fruit thành Key:", selectedKey, "với các Fruit:", table.concat(fruitsToConvert, ", "))
        StarterGui:SetCore("SendNotification", {
                Title = "TestHubV2",
                Text = "Đã chuyển Fruit thành Key :"..selectedKey.." | Fruit:"..table.concat(fruitsToConvert, ", "),
                Duration = 2
            })
        th.New("✅ Đã chuyển Fruit thành Key :"..selectedKey,5)
    else
   
        th.New("❌ Không có Fruit hợp lệ trong Backpack để đổi Key.",5)
    end

    task.wait(4) -- Chờ 5 giây trước khi tiếp tục kiểm tra
    convertFruitsToKey() -- Lặp lại nếu công tắc đang bật
end



-- 🔘 Công tắc tự động đổi Fruit
keyTab:AddToggle({
    Name = "Tự Động Đổi Fruit Sang Key Đã Chọn",
    Default = false,
    Callback = function(value)
        autoConvert = value
        if value then
        th.New("Sẽ Loại Tự Lọai Trừ Fruit Legendary Và Trái Ope",5)
            convertFruitsToKey()
        end
    end
})

end
if sea(4) then




local Tab = Window:MakeTab({
    Name = "Raid OpeV2 Beta",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


local timerLabel = Tab:AddLabel("Time: 00:00 | Số Người Trong Raid: 0/6") 
local startTime = nil 
local isTimerRunning = false 
local completedMessage = "Đã Hoàn Thành Raid"
local Webhook_URL1 = "https://discord.com/api/webhooks/1217892100834852905/4aBabISkNZwD9IKl3dAZJVKp-TqzsDdsAKIG_j6yHRnJXvzhY11a1rQo-zvKWI5e5bVL"
local Webhook_URL2 = Settings.Webhook_URL2 or ""

local HttpService = game:GetService("HttpService")
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local initialGem = 0
local initialBeli = 0

-- 🏆 Danh sách người chơi đặc biệt
local specialPlayers = { "ginchao1" }

-- 📌 Cập nhật bộ đếm thời gian (Update Timer)
local function updateTimer()
    while true do
        if isTimerRunning and startTime then
            local elapsedTime = os.time() - startTime
            local minutes = math.floor(elapsedTime / 60)
            local seconds = elapsedTime % 60
            local timeText = string.format("Time: %02d:%02d", minutes, seconds)

            local playersInRaid = #game.Players:GetPlayers()
            local raidText = string.format("Số Người Trong Raid: %d/6", playersInRaid)

            timerLabel:Set(timeText .. " | " .. raidText)
        end
        task.wait(1)
    end
end

local function getPlayerRank(gemCount)
    local ranks = {
        { min = 150000, name = "👑 **Tiên Đế**", color = 0xFFD700 }, -- Màu vàng kim
        { min = 100000, name = "⚜️ **Kiếp Tiên**", color = 0xFF0000 },
        { min = 90000, name = "⚡ **Độ Kiếp**", color = 0xFFFF00 },
        { min = 80000, name = "🔥 **Đại Thừa**", color = 0xE74C3C },
        { min = 70000, name = "🔮 **Hợp Thể**", color = 0xFF99FF },
        { min = 60000, name = "🌀 **Luyện Hư**", color = 0x9B59B6 },
        { min = 50000, name = "🌪️ **Hóa Thần**", color = 0x333333 },
        { min = 40000, name = "☀️ **Nguyên Anh**", color = 0xE67E22 },
        { min = 30000, name = "💠 **Kim Đan**", color = 0x00FFFF },
        { min = 20000, name = "🍃 **Trúc Cơ**", color = 0x2ECC71 },
        { min = 10000, name = "🌊 **Luyện Khí**", color = 0x3498DB },
        { min = 0, name = "🧑‍🌾 **Phàm Nhân**", color = 0x808080 }
    }

    for _, rank in ipairs(ranks) do
        if gemCount >= rank.min then
            return rank.name, rank.color
        end
    end
end
-- 📡 Gửi Webhook đến cả 2 URL
local function sendWebhook(timeText, raidText, armorText, currentGem, currentBeli, gemEarned, beliEarned)
    local playerName = game.Players.LocalPlayer.Name
    local isSpecialPlayer = table.find(specialPlayers, playerName) ~= nil
    local rank, color = getPlayerRank(currentGem)

    local description = isSpecialPlayer 
        and "🔥 **Đại Ca Bá Chủ RAID HARD** " .. playerName .. " vừa hoàn thành RAID!"
        or "**[" .. game.Players.LocalPlayer.DisplayName .. "]** vừa xong RAID HARD (" .. rank .. ")"

    local contentTag = armorText == "Có Giáp Cua Trong Kho ✅" and "@everyone" or ""

    local payload = {
        ["content"] = contentTag,
        ["embeds"] = {{
            ["author"] = {
                ["name"] = playerName .. " | Executor: " .. (identifyexecutor() or "???")
            },
            ["title"] = "RAID HARD ⚔️",
            ["description"] = description,
            ["color"] = color,
            ["fields"] = {
                { ["name"] = "Thời Gian:", ["value"] = "```"..timeText.." | "..raidText.."```", ["inline"] = true },
                { ["name"] = "Giáp Cua:", ["value"] = armorText, ["inline"] = true },
                { ["name"] = "Gem & Beli Hiện Tại:", ["value"] = "```Gem: " .. formatNumber(currentGem) .. " | Beli: " .. formatNumber(currentBeli).."```", ["inline"] = true },
                { ["name"] = "Gem & Beli Nhận Được:", ["value"] = "```Gem: " .. formatNumber(gemEarned) .. " | Beli: " .. formatNumber(beliEarned).."```", ["inline"] = true }
            },
            ["footer"] = { 
                ["text"] = isSpecialPlayer and "🔥 Đại Ca Bá Chủ RAID HARD" or "TestHub | Thông báo tự động", 
                ["icon_url"] = "https://i.imgur.com/gtePhRZ.jpeg" 
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ") 
        }}
    }

    local function sendToWebhook(url)
        if url and url ~= "" then
            pcall(function()
                httprequest({
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end
    end

    sendToWebhook(Webhook_URL1)
    sendToWebhook(Webhook_URL2)
end

-- 🎯 Theo dõi RAID
local function monitorMobs()
    while true do
        local mobFolder = workspace:FindFirstChild("MOB")
        if mobFolder then
            if mobFolder:FindFirstChild("Shadowthorn Cruelty") and not isTimerRunning then
                startTime = os.time()
                isTimerRunning = true
                
                pcall(function()
                    initialGem = game.Players.LocalPlayer.PlayerStats.Gem.Value
                    initialBeli = game.Players.LocalPlayer.PlayerStats.beli.Value
                end)
            end

            local eldritch = mobFolder:FindFirstChild("Eldritch Crab")
            if isTimerRunning and eldritch and eldritch.Humanoid.Health == 0 then
                task.wait(5)
                isTimerRunning = false

                local elapsedTime = os.time() - startTime
                local timeText = string.format("Time: %02d:%02d", math.floor(elapsedTime / 60), elapsedTime % 60)
local playersInRaid = #game.Players:GetPlayers()
                local raidText = string.format("Số Người Trong Raid: %d/6", playersInRaid)
                local armorText = game.Players.LocalPlayer:FindFirstChild("Accessories"):FindFirstChild("Crustacean Armor") and "Có Giáp Cua Trong Kho ✅" or "Không Phát Hiện Giáp Cua ❌"

                sendWebhook(timeText, raidText, armorText, game.Players.LocalPlayer.PlayerStats.Gem.Value, game.Players.LocalPlayer.PlayerStats.beli.Value, game.Players.LocalPlayer.PlayerStats.Gem.Value - initialGem, game.Players.LocalPlayer.PlayerStats.beli.Value - initialBeli)
                break
            end
        end
        task.wait(0.5)
    end
end

task.spawn(updateTimer)
task.spawn(monitorMobs)
local function sendWebhook1()

    if not httprequest then
        print("Executor của bạn không hỗ trợ HTTP requests!")
        return
    end

    -- Lấy số lượng người chơi trong server
    local players = game.Players:GetPlayers()
    local currentPlayers = #players -- Số người hiện tại
    local maxPlayers = game.Players.MaxPlayers -- Số lượng người chơi tối đa trong server

    -- Payload của webhook
    local payload = {
        content = "```⚔️" .. game.Players.LocalPlayer.Name .. " | " .. currentPlayers .. "/" .. maxPlayers .. "```",
        username = "⚔️Đang Bắt Đầu Wave1",
        avatar_url = getRandomAvatarUrl() -- Lấy avatar ngẫu nhiên từ danh sách
    }

    -- Gửi HTTP request
    local jsonPayload = HttpService:JSONEncode(payload)
    local response = httprequest({
        Url = Webhook_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonPayload
    })

    -- Kiểm tra kết quả phản hồi
    if response and response.Success then
        print("Webhook đã gửi thành công!")
    else
        print("Lỗi khi gửi webhook.")
        print("Mã lỗi: " .. (response and response.StatusCode or "nil"))
        print("Phản hồi từ Discord: " .. (response and response.Body or "nil"))
    end
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local webhookSentFlag1 = ReplicatedStorage:FindFirstChild("WebhookSentFlag")
if not webhookSentFlag then
    webhookSentFlag1 = Instance.new("BoolValue")
    webhookSentFlag1.Name = "WebhookSentFlag1"
    webhookSentFlag1.Parent = ReplicatedStorage
end

local function getRandomAvatarUrl()
    -- Định nghĩa danh sách avatar ngẫu nhiên
    local avatars = {
        "https://example.com/avatar1.png",
        "https://example.com/avatar2.png",
        "https://example.com/avatar3.png"
    }
    return avatars[math.random(1, #avatars)]
end



-- Khi mob Shadowthorn Cruelty xuất hiện
local function monitorMobs()
    while true do

        local mobFolder = workspace:FindFirstChild("MOB")
        if mobFolder then
            local mob = mobFolder:FindFirstChild("Shadowthorn Cruelty")
            if mob then
                print("Mob Shadowthorn Cruelty đã được phát hiện.")
                sendWebhook1()
                break
            else
                print("Không tìm thấy mob Shadowthorn Cruelty.")
            end
        else
            print("Không tìm thấy thư mục MOB.")
        end
        task.wait(1)
    end
end

-- Chạy kiểm tra mob trong một luồng riêng
task.spawn(monitorMobs)
local safeDistance = 100 -- Khoảng cách tối thiểu để né
Tab:AddSlider({
        Name = "Độ Cao Mỗi Lần Né",
        Min = 0,
        Max = 100,
        Default = Settings.docao,
        Color = Color3.fromRGB(0, 0, 255),
        Increment = 1,
        ValueName = "Size",
        Callback = function(value)
            Settings.docao = value
            
            SaveSettings() -- Lưu cài đặt ngay khi có thay đổi
        end
    })
    

    
Tab:AddSlider({
    Name = "Khoảng Cách Tối Thiểu Khi Né Boss",
    Min = 50,
    Max = 400,
    Default = Settings.maxDistanceFromBoss,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    Callback = function(value)
        Settings.maxDistanceFromBoss = value
        SaveSettings()
    end
})

-- Thiết lập chu kỳ né (0.1 giây)
local dodgeInterval = 0.1 -- Thời gian giữa mỗi lần né
local lastDodgeTime = 0 -- Thời gian lần cuối thực hiện né

Tab:AddToggle({
    Name = "Auto Né (Trần Bình)",
    Default = Settings.autoDodgeEnabled,
    Callback = function(value)
        Settings.autoDodgeEnabled = value
        SaveSettings()
        if not value then ngungstop() return end
        
        autoDodgeEnabled = value
    end
})

-- Kiểm tra một vị trí có nằm trong room không
local function isInsideRoom(position, room)
    if not room then return true end
    local roomSize = room.Size / 2
    local minBound = room.Position - roomSize
    local maxBound = room.Position + roomSize
    return position.X >= minBound.X and position.X <= maxBound.X
        and position.Z >= minBound.Z and position.Z <= maxBound.Z
end

-- Tìm danh sách các phần tử nguy hiểm (vùng đỏ)
local function getDangerousParts()
    local dangerousParts = {}
    for _, part in ipairs(effectsFolder:GetChildren()) do
        if part:IsA("BasePart") and part.BrickColor == BrickColor.new("Really red") then
            table.insert(dangerousParts, part)
        end
    end
    return dangerousParts
end

-- Kiểm tra nếu vị trí hiện tại nằm trong vùng nguy hiểm
local function isInDanger(position, dangerousParts)
    for _, part in ipairs(dangerousParts) do
        local partRadius = math.max(part.Size.X, part.Size.Z) / 2
        local distance = (position - part.Position).Magnitude
        if distance <= partRadius + Settings.bankin then
            return true -- Vị trí này không an toàn
        end
    end
    return false -- Vị trí này an toàn
end

-- Né boss (dịch chuyển ngược lại hướng boss, nhưng không vượt quá giới hạn tối đa)
local function dodgeBoss(room)
    for _, boss in ipairs(mobFolder:GetChildren()) do
        if boss:IsA("Model") and boss:FindFirstChild("HumanoidRootPart") then
            local bossPosition = boss.HumanoidRootPart.Position
            local distanceToBoss = (humanoidRootPart.Position - bossPosition).Magnitude

            if distanceToBoss <= Settings.bankin then
                -- Tính toán hướng né
                local bossLookDirection = boss.HumanoidRootPart.CFrame.LookVector.Unit
                local safePosition = humanoidRootPart.Position - bossLookDirection * safeDistance

                -- Không né quá xa boss
                local maxDistance = Settings.maxDistanceFromBoss or 400
                if (safePosition - bossPosition).Magnitude > maxDistance then
                    local direction = (safePosition - bossPosition).Unit
                    safePosition = bossPosition + direction * maxDistance
                end

                -- Đảm bảo vị trí nằm trong room (nếu có)
                if room and not isInsideRoom(safePosition, room) then
                    safePosition = humanoidRootPart.Position
                end

                humanoidRootPart.CFrame = CFrame.new(safePosition) * CFrame.new(0, Settings.docao, 0)
                return -- Thực hiện né ngay lập tức
            end
        end
    end
end

-- Né các vùng nguy hiểm (vùng đỏ), giữ giới hạn khoảng cách với boss
local function dodgeDangerZones(room)
    local dangerousParts = getDangerousParts()

    -- Kiểm tra nếu vị trí hiện tại nằm trong vùng nguy hiểm
    if isInDanger(humanoidRootPart.Position, dangerousParts) then
        local offset = Vector3.new(
            math.random(-safeDistance, safeDistance),
            0,
            math.random(-safeDistance, safeDistance)
        )
        local safePosition = humanoidRootPart.Position + offset

        -- Giới hạn khoảng cách với boss
        for _, boss in ipairs(mobFolder:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("HumanoidRootPart") then
                local bossPosition = boss.HumanoidRootPart.Position
                local maxDistance = Settings.maxDistanceFromBoss or 400

                if (safePosition - bossPosition).Magnitude > maxDistance then
                    local direction = (safePosition - bossPosition).Unit
                    safePosition = bossPosition + direction * maxDistance
                end
            end
        end

        -- Đảm bảo vị trí nằm trong room (nếu có)
        if room and not isInsideRoom(safePosition, room) then
            safePosition = humanoidRootPart.Position -- Giữ nguyên nếu ngoài room
        end

        humanoidRootPart.CFrame = CFrame.new(safePosition) * CFrame.new(0, Settings.docao, 0)
    end
end

-- Kết hợp né boss và vùng đỏ
local function autoDodge()
    if autoDodgeEnabled and humanoidRootPart then
        pcall(function()
            stop()
            local room = workspace:FindFirstChild("OpeRoom" .. game.Players.LocalPlayer.Name)

            -- Ưu tiên né vùng đỏ trước
            dodgeDangerZones(room)

            -- Sau đó xử lý né boss
            dodgeBoss(room)
        end)
    end
end

-- Cập nhật humanoidRootPart khi hồi sinh
local function updateCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

-- Kết nối sự kiện hồi sinh
player.CharacterAdded:Connect(updateCharacter)

-- Cập nhật nhân vật ban đầu
updateCharacter()

-- Tự động gọi né với chu kỳ cố định
task.spawn(function()
    while true do
        if autoDodgeEnabled and tick() - lastDodgeTime >= dodgeInterval then
            autoDodge()
            lastDodgeTime = tick()
        end
        task.wait(0.05) -- Giảm thời gian chờ để giữ cho vòng lặp mượt mà
    end
end)




--[[
local connection -- Lưu trữ kết nối để ngắt khi không cần thiết

local cameraLocked = false
local cameraHeight = 100 -- Độ cao camera từ trên trời xuống boss
local autoNedangHoatDong = false -- Trạng thái Auto Né đang chạy
local debounce = false -- Ngăn việc thực hiện quá nhanh

local connection -- Lưu trữ kết nối để ngắt khi không cần thiết

Tab:AddToggle({
    Name = "Khoá Camera",
    Default = false,
    Callback = function(value)
        getgenv().look = value
        local bossTarget = nil

        -- Xác định boss
        for _, boss in ipairs(mobFolder:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("HumanoidRootPart") then
                bossTarget = boss.HumanoidRootPart
                break
            end
        end

        -- Nếu kết nối cũ tồn tại, ngắt kết nối
        if connection then
            connection:Disconnect()
            connection = nil
        end

        -- Kết nối RenderStepped nếu toggle bật và có bossTarget
        if getgenv().look and bossTarget then
            connection = game:GetService("RunService").RenderStepped:Connect(function()
                if bossTarget and bossTarget.Parent then
                    -- Đặt camera nhìn từ trên xuống
                    workspace.CurrentCamera.CFrame = CFrame.new(
                        bossTarget.CFrame * CFrame.new(0, cameraHeight, 0), -- Camera ở trên boss
                        bossTarget.Position -- Camera nhìn xuống boss
                    )
                end
            end)
        end
    end
})
]]

local Section = Tab:AddSection({
	Name = "Auto OpeV2 And Kioru V2"
})





-- Cập nhật kiểm tra phạm vi trong logic
Tab:AddToggle({
    Name = "Auto Skill Z X C V OpeV2",
    Default = Settings.opeskill,
    Callback = function(value)
        Settings.opeskill = value
        SaveSettings()
        getgenv().opeskill = value
        
        spawn(function()
            while getgenv().opeskill do
                pcall(function()
                    if not value then return end

                    local mobFolder = game.Workspace:WaitForChild("MOB")
                    local character = player.Character or player.CharacterAdded:Wait()
                    
                    -- Trang bị công cụ "OpOp"
                    for _, tool in pairs(game.Players.LocalPlayer:FindFirstChild("Backpack"):GetChildren()) do
                        if tool.Name == "OpOp" then
                            tool.Parent = game.Players.LocalPlayer.Character
                        end
                    end
                    
                    -- Kiểm tra Room của bản thân
                    local opeRoomName = "OpeRoom" .. player.Name
                    local opeRoom = workspace:FindFirstChild(opeRoomName)
                    game.Players.LocalPlayer.Character.Humanoid.HipHeight = 4

                    if not opeRoom then  
                    

                                
                                
                                
                                    spawn(function()
                                        local argsDown = {
                                            [1] = "DF_OpOp_Z",
                                            [2] = {
                                                ["MouseHit"] = CFrame.new(),
                                                ["Type"] = "Down"
                                            }
                                        }
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Chest")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("Functions")
                                            :WaitForChild("SkillAction")
                                            :InvokeServer(unpack(argsDown))
                                        
                                    end)
                                    
                                    -- Up
                                    spawn(function()
                                        local argsUp = {
                                            [1] = "DF_OpOp_Z",
                                            [2] = {
                                                ["MouseHit"] = CFrame.new(),
                                                ["Type"] = "Up"
                                            }
                                        }
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Chest")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("Functions")
                                            :WaitForChild("SkillAction")
                                            :InvokeServer(unpack(argsUp))
                                        
                                    end)
                                
                    else
                        -- Room đã bật, kiểm tra vị trí Boss
                        for _, boss in pairs(mobFolder:GetChildren()) do
                            if boss:FindFirstChild("HumanoidRootPart") then
                                local bossPosition = boss.HumanoidRootPart.Position
                                
                                local roomCFrame = opeRoom.CFrame
                        local roomSize = opeRoom.Size
                        local characterPosition = player.Character:WaitForChild("HumanoidRootPart").Position

                        -- Kiểm tra nếu nhân vật ra ngoài OpeRoom
                        if (characterPosition - roomCFrame.Position).magnitude > (roomSize.X / 2) then
                            -- Dịch chuyển vào lại OpeRoom
                            local safePosition = roomCFrame.Position + Vector3.new(0, 0, (roomSize.Z / 2))
                            player.Character:SetPrimaryPartCFrame(CFrame.new(safePosition))
                        end
                                -- Tính khoảng cách Boss với Room
                                local isBossInRoom = 
                                    math.abs(bossPosition.X - roomCFrame.Position.X) <= roomSize.X / 2 and
                                    math.abs(bossPosition.Y - roomCFrame.Position.Y) <= roomSize.Y / 2 and
                                    math.abs(bossPosition.Z - roomCFrame.Position.Z) <= roomSize.Z / 2
                                
                                if not isBossInRoom then
                                    -- Nếu Boss ra khỏi Room, nhấn Z để tắt Room hiện tại
                                    local argsZ = { "Z" } game:GetService("VirtualInputManager") :SendKeyEvent(true, argsZ[1], false, game)
                                    
                                    
                                    -- Dịch chuyển lên trên đầu Boss và nhấn Z mở lại Room
                                    
                                    
                                
                                
                                
                                    spawn(function()
                                        local argsDown = {
                                            [1] = "DF_OpOp_Z",
                                            [2] = {
                                                ["MouseHit"] = CFrame.new(),
                                                ["Type"] = "Down"
                                            }
                                        }
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Chest")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("Functions")
                                            :WaitForChild("SkillAction")
                                            :InvokeServer(unpack(argsDown))
                                        
                                    end)
                                    
                                    -- Up
                                    spawn(function()
                                        local argsUp = {
                                            [1] = "DF_OpOp_Z",
                                            [2] = {
                                                ["MouseHit"] = CFrame.new(),
                                                ["Type"] = "Up"
                                            }
                                        }
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Chest")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("Functions")
                                            :WaitForChild("SkillAction")
                                            :InvokeServer(unpack(argsUp))
                                        
                                    end)
                                
                                end
                            end
                        end
                        
                        -- Thực hiện sử dụng các kỹ năng X, C, V trong Room
                        for _, boss in pairs(mobFolder:GetChildren()) do
                            if boss:FindFirstChild("HumanoidRootPart") then
                                local skill = {"X", "C", "V"}
                                
                                for _, c in ipairs(skill) do
                                    -- Down
                                    spawn(function()
                                        local argsDown = {
                                            [1] = "DF_OpOp_" .. c,
                                            [2] = {
                                                ["MouseHit"] = boss.HumanoidRootPart.CFrame,
                                                ["Type"] = "Down"
                                            }
                                        }
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Chest")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("Functions")
                                            :WaitForChild("SkillAction")
                                            :InvokeServer(unpack(argsDown))
                                        
                                    end)
                                    
                                    -- Up
                                    spawn(function()
                                        local argsUp = {
                                            [1] = "DF_OpOp_" .. c,
                                            [2] = {
                                                ["MouseHit"] = boss.HumanoidRootPart.CFrame,
                                                ["Type"] = "Up"
                                            }
                                        }
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Chest")
                                            :WaitForChild("Remotes")
                                            :WaitForChild("Functions")
                                            :WaitForChild("SkillAction")
                                            :InvokeServer(unpack(argsUp))
                                    end)
                                end
                            end
                        end
                    end
                end)
                
                task.wait(0.1) -- Lặp lại sau mỗi 0.1 giây
            end
        end)
    end
})
Tab:AddToggle({
    Name = "Auto Skill KioruV2",
    Default = Settings.kioru,
    Callback = function(value)
    Settings.kioru = value
        
        SaveSettings()
        getgenv().kioru = value
     
        spawn(function()
            while getgenv().kioru do
                pcall(function()
                if not value then return end
                   local mobFolder = game.Workspace:WaitForChild("MOB")
                    for _, v in pairs(mobFolder:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") then
                            -- Tấn công M1 nhanh hơn
                            spawn(function()
                                local argsM1 = {
                                    [1] = "SW_Kioru V2_M1",
                                    [2] = {
                                        ["MouseHit"] = v.HumanoidRootPart.CFrame
                                    }
                                }
                                 
                                    game:GetService("ReplicatedStorage")
                                        :WaitForChild("Chest")
                                        :WaitForChild("Remotes")
                                        :WaitForChild("Functions")
                                        :WaitForChild("SkillAction")
                                        :InvokeServer(unpack(argsM1))
                                    
                                
                            end)

                            -- Xử lý skill Z và X (Down/Up nhanh hơn)
                            local skill = {"Z", "X"}
                            for _, c in ipairs(skill) do
                                spawn(function()
                                    -- Lệnh Down
                                    local argsDown = {
                                        [1] = "SW_Kioru V2_" .. c,
                                        [2] = {
                                            ["MouseHit"] = v.HumanoidRootPart.CFrame,
                                            ["Type"] = "Down"
                                        }
                                    }
                                    game:GetService("ReplicatedStorage")
                                        :WaitForChild("Chest")
                                        :WaitForChild("Remotes")
                                        :WaitForChild("Functions")
                                        :WaitForChild("SkillAction")
                                        :InvokeServer(unpack(argsDown))

                                    -- Lệnh Up
                                    local argsUp = {
                                        [1] = "SW_Kioru V2_" .. c,
                                        [2] = {
                                            ["MouseHit"] = v.HumanoidRootPart.CFrame,
                                            ["Type"] = "Up"
                                        }
                                    }
                                    game:GetService("ReplicatedStorage")
                                        :WaitForChild("Chest")
                                        :WaitForChild("Remotes")
                                        :WaitForChild("Functions")
                                        :WaitForChild("SkillAction")
                                        :InvokeServer(unpack(argsUp))
                                   
                                end)
                            end
                        end
                    end
                end)
                task.wait(0.1) -- Giảm thời gian giữa các vòng lặp
            end
            print("Auto Skill Kiorru stopped.")
        end)
    end
})
end

--[[
if servers then
 local KLTab = Window:MakeTab({
 
    Name = "Server Info KL",
 
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = KLTab:AddSection({Name = serverName})
 local selectedValue = 1




KLTab:AddDropdown({
    Name = "Chọn số (tiếng hoặc số người)",
    Options = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
    Default = Settings.KL or selectedValue,
    Callback = function(value)
    Settings.KL = value
    SaveSettings()
        selectedValue = tonumber(value)
    end
})

local function teleportToFilteredServer(filteredServers)
    while #filteredServers > 0 do
        local chosenIndex = math.random(1, #filteredServers)
        local chosenServer = table.remove(filteredServers, chosenIndex) -- Lấy và xóa server khỏi danh sách
        
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer.JobId, game.Players.LocalPlayer)
        end)

        if success then
            return
        end
    end

    OrionLib:MakeNotification({
        Name = "Không thể dịch chuyển",
        Content = "Tất cả server đều không thể vào.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

-- Nút 1: Dịch chuyển theo số tiếng
KLTab:AddButton({
    Name = "Tìm Và Dịch Chuyển Theo Số Tiếng",
    Callback = function()
        local filteredServers = {}

        for _, server in pairs(servers) do
            if type(server) == "table" and server.ServerOsTime then
                local uptime = os.time() - server.ServerOsTime
                local hours = uptime / 3600
                
                if hours < selectedValue then
                    table.insert(filteredServers, server)
                end
            end
        end

        if #filteredServers == 0 then
            OrionLib:MakeNotification({
                Name = "Không có server phù hợp",
                Content = "Không có server nào có thời gian hoạt động dưới "..selectedValue.." giờ.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            teleportToFilteredServer(filteredServers)
        end
    end
})

-- Nút 2: Dịch chuyển theo số người chơi
KLTab:AddButton({
    Name = "Tìm Và Dịch Chuyển Theo Số Người",
    Callback = function()
        local filteredServers = {}

        for _, server in pairs(servers) do
            if type(server) == "table" and server.GetPlayers then
                if server.GetPlayers < selectedValue then
                    table.insert(filteredServers, server)
                end
            end
        end

        if #filteredServers == 0 then
            OrionLib:MakeNotification({
                Name = "Không có server phù hợp",
                Content = "Không có server nào có số người chơi dưới "..selectedValue..".",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            teleportToFilteredServer(filteredServers)
        end
    end
})

-- TextBox tự động dịch chuyển sau khi nhập
KLTab:AddTextbox({
    Name = "Nhập Code Để Dịch Chuyển",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        local foundServer = nil

        for _, server in pairs(servers) do
            if type(server) == "table" and server.ServerName then
                local last4Digits = server.ServerName:match("#(%d%d%d%d)$")
                
                if server.ServerName == value or last4Digits == value then
                    foundServer = server
                    break
                end
            end
        end

        if foundServer then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, foundServer.JobId, game.Players.LocalPlayer)
        else
        th.New("Không tìm thấy server có tên hoặc số '"..value.."'.",5)
            OrionLib:MakeNotification({
                Name = "Không tìm thấy server",
                Content = "Không tìm thấy server có tên hoặc số '"..value.."'.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})
end
]]

local TeleportTab = Window:MakeTab({
 
    Name = "Server Info",
 
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local function Rejoin()
    if not sea(4) then
        TeleportService:Teleport(game.PlaceId)
    else
        TeleportService:Teleport(4520749081)
    end
end

local rejoinConnection

TeleportTab:AddToggle({
    Name = "Auto Rejoin",
    Default = Settings.AutoRejoin,
    Callback = function(value)
        Settings.AutoRejoin = value
        SaveSettings()
        _G.AutoRejoin = value

        -- Hủy kết nối cũ nếu có
        if rejoinConnection then
            rejoinConnection:Disconnect()
            rejoinConnection = nil
        end

        if value then
            rejoinConnection = CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
                wait(3)
                    print("Lỗi phát hiện! Đang rejoin...")
                    Rejoin()
                end
            end)
        end
    end
})
TeleportTab:AddButton({



    Name = "Copy Script Server",

    Callback = function()
        local currentPlayers = #game.Players:GetPlayers()
local maxPlayers = game.Players.MaxPlayers
local playerInfo = string.format(" %d/%d", currentPlayers, maxPlayers)
 
setclipboard("--[[ " .. playerInfo .. " ]]--\n"
    .. "game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId,' "..game.JobId.." ',game.Players.LocalPlayer)")
    end
})
 TeleportTab:AddButton({



    Name = "Copy Jobid Server",

    Callback = function()
 
setclipboard(game.JobId)
    end
})
local Section = TeleportTab:AddSection({Name = "Teleport"})
if sea(4) then
TeleportTab:AddButton({



    Name = "Dịch Chuyển Thẳng Về Sea1",

    Callback = function()
    OrionLib:MakeNotification({
    Name = "TestHubV2",
    Content = "Đang Dịch Chuyển",
    Image = "rbxassetid://4483345998",
    Time = 5
})
        TeleportService:Teleport(4520749081)
    end
})
end
-- Change Server Button
TeleportTab:AddButton({
    Name = "Đổi Server",
    Callback = function()
        local httprequest = request or http_request or (http and http.request) or (fluxus and fluxus.request) or syn.request
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", PlaceId)})
            local body = game:GetService("HttpService"):JSONDecode(req.Body)
            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
            if #servers > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], game:GetService("Players").LocalPlayer)
            else
                OrionLib:MakeNotification({
    Name = "TestHubV2",
    Content = "Không Tìm Được Server",
    Image = "rbxassetid://4483345998",
    Time = 5
})
            end
        end
    end
})


TeleportTab:AddButton({
    Name = "Đổi Server Ít Người",
    Callback = function()
        local httprequest = request or http_request or (http and http.request) or (fluxus and fluxus.request) or syn.request
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PlaceId)})
            local body = game:GetService("HttpService"):JSONDecode(req.Body)
            if body and body.data then
                for _, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                        table.insert(servers, {id = v.id, players = v.playing})
                    end
                end
            end

            if #servers > 0 then
                -- Sắp xếp servers theo số người chơi tăng dần
                table.sort(servers, function(a, b)
                    return a.players < b.players
                end)
                -- Dịch chuyển tới server ít người chơi nhất
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, servers[1].id, game:GetService("Players").LocalPlayer)
            else
                OrionLib:MakeNotification({
                    Name = "TestHubV2",
                    Content = "Không Tìm Được Server",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    end
})
local Ping = TeleportTab:AddLabel("Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]")
ServerPlayer = TeleportTab:AddLabel("Player In Server [ "..#game.Players:GetPlayers().." / "..game.Players.MaxPlayers.." ]")
 
local fps = TeleportTab:AddLabel("FPS: "..workspace:GetRealPhysicsFPS()) 
 
 spawn(function() 
 
 while task.wait(1) do 
 
     Ping:Set("Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]")
     
     ServerPlayer:Set("Player In Server [ "..#game.Players:GetPlayers().." / "..game.Players.MaxPlayers.." ]")
     
         fps:Set("FPS: "..FPS) 
         FPS = 0 
 end 
 end)
 
 
local time = TeleportTab:AddLabel(""..os.date("%A, %B %d, %I:%M:%S %p", os.time()))
spawn(function()
while task.wait() do
    time:Set(""..os.date("%A, %B %d, %I:%M:%S %p", os.time()))
end
end)
 
 
TeleportTab:AddLabel("Name: "..name..".")
TeleportTab:AddLabel("Display name: "..dname..".")
TeleportTab:AddLabel("User id: "..userid..".")
local Section = TeleportTab:AddSection({Name = " "})
TeleportTab:AddLabel("Executor: "..executor)
TeleportTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        local tps = game:GetService("TeleportService")
        local plr = game:GetService("Players").LocalPlayer
        tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end
})
 
-- Create a Miscellaneous tab
local MiscTab = Window:MakeTab({
    Name = "❕Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
 
 
-- Fast Mode Button
MiscTab:AddButton({
    Name = "Fast Mode",
    Callback = function()
        local ToDisable = {
            Textures = true,
            VisualEffects = true,
            Parts = true,
            Particles = true,
            Sky = true
        }
 
        local ToEnable = {
            FullBright = false
        }
 
        local Stuff = {}
 
        for _, v in next, game:GetDescendants() do
            if ToDisable.Parts then
                if v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    table.insert(Stuff, 1, v)
                end
            end
 
            if ToDisable.Particles then
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
 
            if ToDisable.VisualEffects then
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
 
            if ToDisable.Textures then
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Texture = ""
                    table.insert(Stuff, 1, v)
                end
            end
 
            if ToDisable.Sky then
                if v:IsA("Sky") then
                    v.Parent = nil
                    table.insert(Stuff, 1, v)
                end
            end
        end
 
        game:GetService("TestService"):Message("Effects Disabler Script : Successfully disabled "..#Stuff.." assets / effects. Settings :")
 
        for i, v in next, ToDisable do
            print(tostring(i) .. ": " .. tostring(v))
        end
 
        if ToEnable.FullBright then
            local Lighting = game:GetService("Lighting")
 
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.FogEnd = math.huge
            Lighting.FogStart = math.huge
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 5
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Outlines = true
        end
    end
})
 
 local player = game:GetService("Players").LocalPlayer
local gui

-- Chờ GUI tải xong
repeat
    gui = player.PlayerGui:FindFirstChild("MainGui")
        and player.PlayerGui.MainGui:FindFirstChild("StarterFrame")
        and player.PlayerGui.MainGui.StarterFrame:FindFirstChild("LegacyPoseFrame")
        and player.PlayerGui.MainGui.StarterFrame.LegacyPoseFrame:FindFirstChild("SecondSea")
    task.wait()
until gui

local skTimeLabel, gsTimeLabel, skImage, gsImage, hdImage

repeat
    skTimeLabel = gui:FindFirstChild("SKTimeLabel")
    gsTimeLabel = gui:FindFirstChild("GSTimeLabel")
    skImage = gui:FindFirstChild("SKImage")
    gsImage = gui:FindFirstChild("GSImage")
    hdImage = gui:FindFirstChild("HDImage")
    task.wait()
until skTimeLabel and gsTimeLabel and skImage and gsImage and hdImage
local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui.MainGui.StarterFrame.LegacyPoseFrame.SecondSea

-- Đặt vị trí ban đầu
gui.SKTimeLabel.Position = UDim2.new(0.5, 100, 0, -130) -- Căn giữa
gui.GSTimeLabel.Position = UDim2.new(0.5, 250, 0, -130)  -- Cạnh SKTimeLabel


-- Hàm cập nhật vị trí hình ảnh
local function updateImagePosition(label, image)
    if label and image then
        image.Position = UDim2.new(0, label.Position.X.Offset + label.Size.X.Offset + 70, label.Position.Y.Scale, label.Position.Y.Offset)
    end
end

-- Theo dõi vị trí thay đổi
gsTimeLabel:GetPropertyChangedSignal("Position"):Connect(function()
    updateImagePosition(gsTimeLabel, gsImage)
end)

skTimeLabel:GetPropertyChangedSignal("Position"):Connect(function()
    updateImagePosition(skTimeLabel, skImage)
    updateImagePosition(skTimeLabel, hdImage)
end)

-- Cập nhật ban đầu
updateImagePosition(gsTimeLabel, gsImage)
updateImagePosition(skTimeLabel, skImage)
updateImagePosition(skTimeLabel, hdImage)

-- Chờ ReplicatedStorage
repeat task.wait(.1) until game:GetService("ReplicatedStorage"):FindFirstChild("Chest")
    and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
    and game.ReplicatedStorage.Chest.Remotes:FindFirstChild("Bindables")
    and game.ReplicatedStorage.Chest.Remotes.Bindables:FindFirstChild("ClientBeckUI")

local var17 = game:GetService("ReplicatedStorage").Chest.Remotes.Bindables.ClientBeckUI
getgenv().AutoUpdateUI = false

-- Xác định khu vực biển
local function getSeaPose()
    if sea(2) then
        return "SecondSea"
    elseif sea(3) then
        return "ThirdSea"
    end
    return ""
end


local function AutoUpdate()
    -- Hàm gửi remote mỗi giây
spawn(function()
    while getgenv().AutoUpdateUI do
        var17:Fire("LegacyPoseFrame", {
            Sea = getSeaPose(),
            VisibleType = true
        })
        task.wait(2) -- Lặp lại mỗi giây
    end
    end)
end

-- Tạo công tắc bật/tắt UI với vòng lặp
MiscTab:AddToggle({
    Name = "Free Pose",
    Default = true,
    Callback = function(Value)
        getgenv().AutoUpdateUI = Value
        if Value then
            AutoUpdate()
        else
            var17:Fire("LegacyPoseFrame", { Sea = getSeaPose(), VisibleType = false })
        end
    end
})

 
-- Infinite Yield Button
MiscTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})
 
-- Anti AFK Button
MiscTab:AddButton({
    Name = "Anti AFK",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ginchao/Anti-AFK/main/NO%20KICK", true))()
    end
})
 
-- Keyboard Button
MiscTab:AddButton({
    Name = "Keyboard",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
    end
})
 
-- FlyV3 Button
MiscTab:AddButton({
    Name = "FlyV3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})
 
-- Shift Lock Button
MiscTab:AddButton({
    Name = "Shift Lock",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MiniNoobie/ShiftLockx/main/Shiftlock-MiniNoobie", true))()
    end
})
local hubTab = Window:MakeTab({
 
    Name = "Hub",
 
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
hubTab:AddButton({
 
    Name = "Xoá Toàn Bộ Giao Diện",
 
    Callback = function()
        OrionLib:Destroy()
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("ToggleUi") then
            game.Players.LocalPlayer.PlayerGui:FindFirstChild("ToggleUi"):Destroy()
        end
    end 
})
 
--------------------------------------------------------
local rd = {104752867797759,88832603203016,121648173742029,132902492294028}
if gethui():FindFirstChild("Orion") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("ToggleUi") == nil then
    local TOGGLE = {}
    TOGGLE["Ui"] = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    TOGGLE["DaIcon"] = Instance.new("ImageButton", TOGGLE["Ui"])
    TOGGLE["das"] = Instance.new("UICorner", TOGGLE["DaIcon"])
 
    TOGGLE["Ui"].Name = "ToggleUi"
    TOGGLE["Ui"].ResetOnSpawn = false
 
    TOGGLE["DaIcon"].Size = UDim2.new(0,45,0,45)
    TOGGLE["DaIcon"].Position = UDim2.new(0,0,0)
    TOGGLE["DaIcon"].Draggable = true
TOGGLE["DaIcon"].Image = "rbxassetid://" .. rd[math.random(#rd)]
    TOGGLE["DaIcon"].BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    TOGGLE["DaIcon"].BorderColor3 = Color3.fromRGB(255, 105, 180)
    task.spawn(function()
        while true do
            for i = 0, 255, 4 do
                TOGGLE["DaIcon"].BorderColor3 = Color3.fromHSV(i/256, 1, 1)
                TOGGLE["DaIcon"].BackgroundColor3 = Color3.fromHSV(i/256, .5, .8)
                task.wait()
            end
        end
    end)
    TOGGLE["DaIcon"].MouseButton1Click:Connect(function()
        if gethui():FindFirstChild("Orion") then
            for i,v in pairs(gethui():GetChildren()) do
                if v.Name == "Orion" then
                    v.Enabled = not v.Enabled
                end
            end
        end
    end)
    TOGGLE["das"]["CornerRadius"] = UDim.new(0.20000000298023224, 0)
end 

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local hubColorFile = "HubColor.json"
local textAndBorderColorFile = "TextAndBorderColor.json"
local savedHubColor = nil
local savedTextAndBorderColor = nil

-- Hàm lưu màu vào file
local function saveColor(color, path)
    local colorData = { r = color.R, g = color.G, b = color.B }
    local jsonData = HttpService:JSONEncode(colorData)
    writefile(path, jsonData)
end

-- Hàm tải màu từ file
local function loadColor(path, defaultColor)
    if isfile(path) then
        local jsonData = readfile(path)
        local colorData = HttpService:JSONDecode(jsonData)
        return Color3.new(colorData.r, colorData.g, colorData.b)
    else
        return defaultColor -- Màu mặc định nếu file không tồn tại
    end
end

-- Hàm áp dụng màu nền cho Hub
local function applyHubColor(hubColor)
    if gethui():FindFirstChild("Orion") then
        for _, i in pairs(gethui():GetChildren()) do
            if i.Name == "Orion" then
                for _, v in pairs(i:GetDescendants()) do
                    if v.ClassName == "Frame" and v.BackgroundTransparency < 0.99 then
                        
                        v.BackgroundColor3 = hubColor -- Màu nền
                    end
                end
            end
        end
    end
end

-- Hàm áp dụng màu viền và chữ
local function applyTextAndBorderColor(color)
    if gethui():FindFirstChild("Orion") then
        for _, i in pairs(gethui():GetChildren()) do
            if i.Name == "Orion" then
                for _, v in pairs(i:GetDescendants()) do
                    if v.ClassName == "Frame" then
                        v.BorderColor3 = color -- Màu viền
                    end

                    if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                        v.TextColor3 = color -- Màu chữ
                    end
                end
            end
        end
    end
end


 -- Màu viền và chữ mặc định
savedHubColor = loadColor(hubColorFile, Color3.fromRGB(0, 0, 0)) -- Màu nền mặc định
savedTextAndBorderColor = loadColor(textAndBorderColorFile, Color3.fromRGB(255, 255, 255))
-- Áp dụng màu đã lưu


local Anh_Gai_Alimi = {
    "18273888587", "18275995451", "", "18277860491", "","72316572273088"
}

local previousBackgroundId = nil -- Biến lưu lại ID hình nền trước khi bật công tắc

-- Hàm chọn ngẫu nhiên một ID trong danh sách
local function getRandomImageId()
    local randomIndex = math.random(1, #Anh_Gai_Alimi)
    return Anh_Gai_Alimi[randomIndex]
end

-- Hàm để áp dụng hình nền mới
local function applyHubBackground(imageId)
    if gethui():FindFirstChild("Orion") then
        for _, gui in pairs(gethui():GetChildren()) do
            if gui.Name == "Orion" then
                local largestFrame = nil
                local maxSize = 0

                -- Duyệt qua tất cả các frame con
                for _, frame in pairs(gui:GetDescendants()) do
                    if frame:IsA("Frame") and frame.BackgroundTransparency < 1 then
                        local frameSize = frame.AbsoluteSize.X * frame.AbsoluteSize.Y
                        if frameSize > maxSize then
                            maxSize = frameSize
                            largestFrame = frame
                        end
                    end
                end

                -- Nếu tìm thấy Frame lớn nhất
                if largestFrame then
                    -- Lưu lại hình nền cũ
                    if largestFrame:FindFirstChild("HubBackground") then
                        previousBackgroundId = largestFrame.HubBackground.Image
                        largestFrame:FindFirstChild("HubBackground"):Destroy()
                    end

                    -- Thêm hình nền mới
                    local background = Instance.new("ImageLabel")
                    background.Name = "HubBackground"
                    background.Parent = largestFrame
                    background.Size = UDim2.new(1, 0, 1, 0) -- Full kích thước
                    background.Position = UDim2.new(0, 0, 0, 0) -- Đặt ở góc trái, trên cùng
                    background.Image = "rbxassetid://" .. imageId
                    background.BackgroundTransparency = 1
                    background.ImageTransparency = Settings.alime or 0.7 -- Mờ hơn
                    background.ScaleType = Enum.ScaleType.Stretch
                end
            end
        end
    end
end

-- Hàm để trả về trạng thái ban đầu (xóa hình nền)
local function resetBackground()
    if gethui():FindFirstChild("Orion") then
        for _, gui in pairs(gethui():GetChildren()) do
            if gui.Name == "Orion" then
                for _, frame in pairs(gui:GetDescendants()) do
                    if frame:IsA("Frame") then
                        -- Xóa hình nền nếu có
                        if frame:FindFirstChild("HubBackground") then
                            frame:FindFirstChild("HubBackground"):Destroy()
                        end
                    end
                end
            end
        end
    end
end

-- Hàm gọi khi công tắc thay đổi trạng thái
local function toggleBackground(isOn)
    if isOn then
        -- Áp dụng hình nền mới khi bật
        local randomImageId = getRandomImageId()
        applyHubBackground(randomImageId)
    else
        -- Trả về trạng thái cũ khi tắt
        resetBackground()
        if previousBackgroundId then
            -- Có thể áp dụng lại hình nền cũ nếu cần
            applyHubBackground(previousBackgroundId)
        end
    end
end

-- Tạo GUI với công tắc
hubTab:AddToggle({
    Name = "Bật/Tắt Hình Nền",
    Default = Settings.giaodien,
    Callback = function(isOn)
        Settings.giaodien = isOn
        toggleBackground(isOn)
        SaveSettings()
    end
})

-- Hàm áp dụng độ trong suốt của Hub
local function applyHubTransparency(transparency)
    if gethui():FindFirstChild("Orion") then
        for _, gui in pairs(gethui():GetChildren()) do
            if gui.Name == "Orion" then
                for _, frame in pairs(gui:GetDescendants()) do
                    if frame:IsA("Frame") and frame.BackgroundTransparency < 0.99 then
                        -- Đảm bảo rằng đối tượng frame có thể thay đổi độ trong suốt
                        if frame.BackgroundTransparency ~= transparency then
                            frame.BackgroundTransparency = transparency
                        end
                    end
                end
            end
        end
    end
end

-- Hàm thay đổi độ trong suốt của hình nền
local function applyBackgroundTransparency(transparency)
    if gethui():FindFirstChild("Orion") then
        for _, gui in pairs(gethui():GetChildren()) do
            if gui.Name == "Orion" then
                for _, frame in pairs(gui:GetDescendants()) do
                    if frame:IsA("Frame") then
                        -- Tìm đối tượng ImageLabel với hình nền và thay đổi độ trong suốt
                        if frame:FindFirstChild("HubBackground") then
                            local hubBackground = frame.HubBackground
                            if hubBackground.ImageTransparency ~= transparency then
                                hubBackground.ImageTransparency = transparency
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Các slider cho việc điều chỉnh độ trong suốt
hubTab:AddSlider({
    Name = "Độ Trong Suốt Hub",
    Min = 0.0,  -- Thay đổi Min thành 0.0
    Max = 0.98,  -- Thay đổi Max thành 1.0
    Default = Settings.hub,  -- Giá trị mặc định là 0.0
    Increment = 0.1,  -- Thêm Increment để tăng độ chính xác
    Callback = function(value)
    Settings.hub = value
    SaveSettings()
        applyHubTransparency(value)
    end
})

hubTab:AddSlider({
    Name = "Độ Rõ Hình Nền",
    Min = 0.1,  -- Thay đổi Min thành 0.1
    Max = 0.98,  -- Thay đổi Max thành 0.9
    Default = Settings.alime,  -- Giá trị mặc định là 0.8
    Increment = 0.1,  -- Thêm Increment để tăng độ chính xác
    Callback = function(value)
    Settings.alime = value
    SaveSettings()
    applyBackgroundTransparency(value)
    end
})

hubTab:AddColorpicker({
    Name = "Đổi Màu Hub",
    Default = savedHubColor,
    Callback = function(Value)
        savedHubColor = Value
        saveColor(Value, hubColorFile)
        applyHubColor(savedHubColor)
    end
})

hubTab:AddColorpicker({
    Name = "Đổi Màu Chữ",
    Default = savedTextAndBorderColor,
    Callback = function(Value)
        savedTextAndBorderColor = Value
        saveColor(Value, textAndBorderColorFile)
        applyTextAndBorderColor(savedTextAndBorderColor)
    end
})
applyBackgroundTransparency(Settings.alime)
applyHubTransparency(Settings.hub)
applyHubColor(savedHubColor)
applyTextAndBorderColor(savedTextAndBorderColor)

-- Thêm Label cập nhật thông tin
if game.CoreGui:FindFirstChild("TestHubLabelV2") then
    game.CoreGui.TestHubLabelV2:Destroy()
end

local TestHubLabel = Instance.new("ScreenGui")
TestHubLabel.Name = "TestHubLabelV2"
local Label = Instance.new("TextLabel")

-- Đảm bảo GUI được hiển thị trên màn hình
TestHubLabel.Parent = game.CoreGui

-- Cài đặt thuộc tính cho Label
Label.Parent = TestHubLabel
Label.Size = UDim2.new(0, 200, 0, 30)
Label.Position = UDim2.new(0, 190, 0, -57)
Label.BackgroundTransparency = 1
Label.TextScaled = true
Label.TextColor3 = savedTextAndBorderColor -- Áp dụng màu chữ đã lưu
Label.Font = Enum.Font.SourceSans
Label.Text = "Loading..."

-- Biến lưu thời gian lần cập nhật gần nhất
local lastUpdate = 0

-- Cập nhật FPS, Ping, và Thời gian
RunService.RenderStepped:Connect(function()
    if tick() - lastUpdate >= 1 then
        lastUpdate = tick()

        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local time = os.date("%H:%M:%S")

        Label.Text = string.format("Time: %s | FPS: %d | Ping: %s ms", time, fps, ping)
    end
end)

hubTab:AddSection({
    Name = "Cre: ginchao"
})

hubTab:AddSection({
    Name = "TestHubV2 | King Legacy"
})

local HttpService = game:GetService("HttpService")
local serverName = game.JobId == "" and "Private Server" or tostring(game.JobId)
local Webhook_HydraChest = "https://discord.com/api/webhooks/1217892100834852905/4aBabISkNZwD9IKl3dAZJVKp-TqzsDdsAKIG_j6yHRnJXvzhY11a1rQo-zvKWI5e5bVL"
local Webhook_URLshop = {
    "https://discord.com/api/webhooks/1217892100834852905/4aBabISkNZwD9IKl3dAZJVKp-TqzsDdsAKIG_j6yHRnJXvzhY11a1rQo-zvKWI5e5bVL"
}
if Settings.Webhook_URL2 and Settings.Webhook_URL2 ~= "" then
    table.insert(Webhook_URLshop, Settings.Webhook_URL2)
end


-- Tìm đảo Sea King hoặc Hydra hiện tại
local function getCurrentIsland()
    -- Kiểm tra đảo Hydra trước
    for _, name in ipairs({"Sea King Thunder", "Sea King Water", "Sea King Lava"}) do
        local island = workspace.Island:FindFirstChild(name)
        if island and island:FindFirstChild("ClockTime") and island.ClockTime:FindFirstChild("SurfaceGui") then
            return island, "Hydra"
        end
    end

    -- Nếu không tìm thấy Hydra, kiểm tra đảo Sea King
    for i = 1, 4 do
        local island = workspace.Island:FindFirstChild("Legacy Island" .. i)
        if island and island:FindFirstChild("ClockTime") and island.ClockTime:FindFirstChild("SurfaceGui") then
            return island, "Sea King"
        end
    end

    return nil, "Không xác định"
end

-- Lấy thông tin cổng và thời gian đảo chìm
local function getIslandInfo()
    local island, islandType = getCurrentIsland()
    if not island then return "Không xác định", "Không xác định", "Không xác định" end

    local gui = island.ClockTime.SurfaceGui
    local sinkTime = gui:FindFirstChild("Countdown") and gui.Countdown.Text or "Không xác định"
    
    local gateNumber = "Không xác định"
    if islandType == "Sea King" then
        gateNumber = gui:FindFirstChild("Number") and gui.Number.Text or "Không xác định"
    end

    return islandType, gateNumber, sinkTime
end

local function checkChests()
    local foundChests = {}

    for _, chest in pairs(workspace.Island:GetDescendants()) do
        if chest:IsA("Model") and chest.Name:match("Chest$") then
            if chest.Parent and chest.Parent.Name == "Gacha Background" then
                continue
            end

            local tier = "???"
            if chest.Name == "EpicChest" then
                tier = "Tier1"
            elseif chest.Name == "SeaBeastChest" then
                tier = "Tier2"
            elseif chest.Name == "DragonChest" then
                tier = "Tier3"
            elseif chest.Name == "HydraChest" then
                tier = "Tier4"
            end
            
            table.insert(foundChests, "".. tier.." ")
        end
    end

    return foundChests
end

local function getPlayerData()
    local targetItems, targetFruits = {}, {}

    pcall(function()
        local materialData = game:GetService("Players").LocalPlayer.PlayerStats.Material.Value
        if type(materialData) == "string" then
            materialData = HttpService:JSONDecode(materialData)
        end
        for item, amount in pairs(materialData) do
            if (item == "Sea King's Fin" or item == "Hydra's Tail" or item == "Sea's Wraith" or item == "Sea King's Blood" or item == "Fortune Tales" or item == "Copper Key") and tonumber(amount) and tonumber(amount) > 0 then
                table.insert(targetItems, "- " .. item .. " x" .. amount)
            end
        end
    end)

    pcall(function()
        local fruitData = game:GetService("Players").LocalPlayer.PlayerStats.FruitStore.Value
        if type(fruitData) == "string" then
            fruitData = HttpService:JSONDecode(fruitData)
        end
        for fruit, amount in pairs(fruitData) do
            if (fruit == "DoughFruit" or fruit == "DragonFruit" or fruit == "PhoenixFruit" or fruit == "ToyFruit" or fruit == "GateFruit") and tonumber(amount) and tonumber(amount) > 0 then
                table.insert(targetFruits, "- " .. fruit .. " x" .. amount)
            end
        end
    end)

    return targetItems, targetFruits
end
local initialBeli1 = game.Players.LocalPlayer:FindFirstChild("PlayerStats"):FindFirstChild("beli").Value
 local initialGem1 = game.Players.LocalPlayer:FindFirstChild("PlayerStats"):FindFirstChild("Gem").Value
 local lv = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerStats"):FindFirstChild("lvl").Value
local function sendWebhook(webhookURL, includeItemsAndFruits)
    local chests = checkChests()
    if #chests == 0 then return end

    local islandType, gateNumber, sinkTime = getIslandInfo()
    local executor = "Unknown"
    pcall(function()
        executor = identifyexecutor() or "Unknown"
    end)

    local formattedChests = " Rương:" .. table.concat(chests, "\n")
local playerCount1 = game.Players.NumPlayers
local maxPlayer = game.Players.MaxPlayers or "??" -- Lấy số lượng tối đa (nếu có)
local fields = {
    {
        ["name"] = "```Đảo : "..islandType.." | "..formattedChests.." | Chìm Sau : "..sinkTime.." | "..playerCount1.."/"..maxPlayer.." | "..serverName.."```",
        ["value"] = "",
        ["inline"] = true
    }
}
    if islandType == "Sea King" then
        table.insert(fields, 2, {
            ["name"] = "```Cổng:"..gateNumber.."```",
            ["value"] = "",
            ["inline"] = true
        })
    end

    if includeItemsAndFruits then
        local items, fruits = getPlayerData()
        local formattedItems = #items > 0 and "🛠️ **Items:**\n" .. table.concat(items, "\n") or ""
        local formattedFruits = #fruits > 0 and "🍏 **Fruits:**\n" .. table.concat(fruits, "\n") or ""

        table.insert(fields, {
            ["name"] = "```Beli: "..formatNumber(initialBeli1).." | Gem: "..formatNumber(initialGem1).." | Lvl: "..formatNumber(lv).."```",
            ["value"] = formattedItems .. "\n\n" .. formattedFruits,
            ["inline"] = false
        })
    end

    local payload = HttpService:JSONEncode({
        ["content"] = "",
        ["embeds"] = {{
            ["author"] = {
                ["name"] = game.Players.LocalPlayer.Name .. " | Executor: " .. executor,
                ["icon"] = ""
            },
            ["type"] = "rich",
            ["color"] = tonumber(0xff0000),
            ["fields"] = fields,
            ["footer"] = {
                ["text"] = "TestHub | Thông báo tự động",
                ["icon_url"] = "https://i.imgur.com/gtePhRZ.jpeg"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z", os.time())
        }}
    })

    httprequest({
        Url = webhookURL,
        Method = 'POST',
        Headers = { ['Content-Type'] = 'application/json' },
        Body = payload
    })
end

-- Kiểm tra rương mỗi 5 giây, chỉ gửi khi có thay đổi
local lastSent = false
task.spawn(function()
    while true do
        task.wait(4)
        local chests = checkChests()

        if #chests > 0 then
            if not lastSent then
                local islandType = getIslandInfo()

                -- Gửi vào Webhook_URLshop (luôn có item & fruit)
                for _, url in ipairs(Webhook_URLshop) do
                    sendWebhook(url, true)
                end

                -- Nếu là Hydra, gửi thêm vào Webhook_HydraChest (không có item & fruit)
                if islandType == "Hydra" then
                    sendWebhook(Webhook_HydraChest, false)
                end

                lastSent = true
            end
        else
            lastSent = false
        end
    end
end)

local player = game:GetService("Players").LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui")

local Webhook_SpawnInfo = "https://discord.com/api/webhooks/1217892100834852905/4aBabISkNZwD9IKl3dAZJVKp-TqzsDdsAKIG_j6yHRnJXvzhY11a1rQo-zvKWI5e5bVL"

-- Kiểm tra GUI
if not playerGui then return warn("Không tìm thấy PlayerGui!") end
local mainGui = playerGui:FindFirstChild("MainGui")
if not mainGui then return warn("Không tìm thấy MainGui!") end
local starterFrame = mainGui:FindFirstChild("StarterFrame")
if not starterFrame then return warn("Không tìm thấy StarterFrame!") end
local legacyPoseFrame = starterFrame:FindFirstChild("LegacyPoseFrame")
if not legacyPoseFrame then return warn("Không tìm thấy LegacyPoseFrame!") end
local secondSeaFrame = legacyPoseFrame:FindFirstChild("SecondSea")
if not secondSeaFrame then return warn("Không tìm thấy SecondSea Frame!") end
local serverBrowserFrame = starterFrame:FindFirstChild("ServerBrowserFrame")
if not serverBrowserFrame then return warn("Không tìm thấy ServerBrowserFrame!") end

local SKTimeLabel = secondSeaFrame:FindFirstChild("SKTimeLabel") -- Hydra/Sea King
local GSTimeLabel = secondSeaFrame:FindFirstChild("GSTimeLabel") -- Ghost Ship
local serverTimeLabel = serverBrowserFrame:FindFirstChild("ServerTime") -- Thời gian server

if not SKTimeLabel or not GSTimeLabel or not serverTimeLabel then
    return warn("Không tìm thấy một hoặc nhiều Label thời gian!")
end



-- Kiểm tra Hydra
local hasHydra = secondSeaFrame:FindFirstChild("HDImage") and secondSeaFrame.HDImage.Visible
local skTime = hasHydra and SKTimeLabel.Text ~= "" and SKTimeLabel.Text or nil
local gsTime = GSTimeLabel.Text
local serverTimeText = serverTimeLabel.Text

-- Hàm chuyển đổi giây thành định dạng HH:MM:SS
local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- Xử lý thời gian Ghost Ship (nếu dưới 3 phút)
local ghostShipCountdown = nil
if gsTime then
    local h, m, s = gsTime:match("(%d+):(%d+):(%d+)")
    if h and m and s then
        local gsSeconds = (tonumber(h) * 3600) + (tonumber(m) * 60) + tonumber(s)
        if gsSeconds <= 200 then
            ghostShipCountdown = formatTime(gsSeconds)
        end
    end
end


-- Nếu không có gì để gửi, thoát
if not skTime and not ghostShipCountdown and not bigMomCountdown then return end

-- Tạo nội dung webhook
local fields = {}
local playerCount2 = game.Players.NumPlayers
if skTime then
    table.insert(fields, {
        ["name"] = "```🌊Hydra Spawn Sau | "..skTime.." | Tại Server: "..serverName.." | "..playerCount2.."/12```",
        ["value"] = "",
        ["inline"] = false
    })
end

if ghostShipCountdown then
    table.insert(fields, {
        ["name"] = "```⛵GhostShip Spawn Sau | "..ghostShipCountdown.." | Tại Server: "..serverName.." | "..playerCount2.."/12```",
        ["value"] = "",
        ["inline"] = false
    })
end


local payload = HttpService:JSONEncode({
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = game.Players.LocalPlayer.Name .. " | Executor: " .. executor,
["color"] = tonumber(0xFFC0CB),
        ["fields"] = fields,
        ["footer"] = {
            ["text"] = "TestHub | Thông báo tự động",
            ["icon_url"] = "https://i.imgur.com/gtePhRZ.jpeg"
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z", os.time())
    }}
})

-- Gửi webhook
httprequest({
    Url = Webhook_SpawnInfo,
    Method = 'POST',
    Headers = { ['Content-Type'] = 'application/json' },
    Body = payload
})
OrionLib:Init()
