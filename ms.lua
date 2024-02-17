queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local Players = game:GetService("Players")
local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if queueteleport and (not TeleportCheck) then
        TeleportCheck = true
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Soul774/Mining-Simulator/main/ms.lua'))()")
    end
end)

if game.PlaceId == 1417427737 then repeat task.wait(1) until game:IsLoaded()

    local SellTreshold = getgenv().SellTreshold or 30000
    local Depth = getgenv().Depth or 205

    local Players = game:GetService("Players")
    Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
    while Players.LocalPlayer.PlayerGui.ScreenGui.LoadingFrame.BackgroundTransparency == 0 do
        for i, connection in pairs(getconnections(Players.LocalPlayer.PlayerGui.ScreenGui.LoadingFrame.Quality.LowQuality.MouseButton1Down)) do
            connection:Fire()
        end
        task.wait(1)
    end
    while true do
        if pcall(function() game.Players.LocalPlayer.leaderstats:WaitForChild("Blocks Mined") end) then
            if pcall(function() game.Players.LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Coins:FindFirstChild("Amount") end) then
                if game.Players.LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Tokens.Amount.Text ~= "Loading..." then
                    break
                end
            end
        end
        task.wait(1)
    end

    if Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("TeleporterFrame") then
        Players.LocalPlayer.PlayerGui.ScreenGui.TeleporterFrame:Destroy()
    end
    if Players.LocalPlayer.PlayerGui.ScreenGui.StatsFrame:FindFirstChild("Sell") then
        Players.LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Sell:Destroy()
    end
    if Players.LocalPlayer.PlayerGui.ScreenGui.MainButtons:FindFirstChild("Surface") then
        Players.LocalPlayer.PlayerGui.ScreenGui.MainButtons.Surface:Destroy()
    end
    if Players.LocalPlayer.PlayerGui.ScreenGui.Collapse:FindFirstChild("Progress") then
        Players.LocalPlayer.PlayerGui.ScreenGui.Collapse.Visible = true
    end

    local ExampleFrame = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("StatsFrame"):WaitForChild("Tokens")
    local Rebirths = game:GetService("Players").LocalPlayer.leaderstats.Rebirths

    local Rebirths2 = ExampleFrame:Clone()
    Rebirths2.Parent = ExampleFrame.Parent
    Rebirths2.Position = UDim2.new(0, 0, 1.5, 15)
    Rebirths2.Logo.Image = "rbxassetid://1440681030"
    Rebirths2.Amount.Text = tostring(Rebirths.Value)
    Rebirths:GetPropertyChangedSignal("Value"):Connect(function()
        Rebirths2.Amount.Text = tostring(Rebirths.Value)
    end)

-- Anti afk
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
--Rejoin
    Workspace.Collapsed.Changed:connect(function()
    if Workspace.Collapsed.Value == true then
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
        end
    end)    

    local Remote

    local Data = getsenv(Players.LocalPlayer.PlayerGui.ScreenGui.ClientScript).displayCurrent
    local Values = getupvalue(Data,8)
    Remote = Values["RemoteEvent"]
    Data, Values = nil

    local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    HumanoidRootPart.Anchored = true
    Remote:FireServer("MoveTo", {{"LavaSpawn"}})
    local className = "Part"
    local parent = game.Workspace
    local part = Instance.new(className, parent)
    part.Anchored = true
    part.Size = Vector3.new(10, 1 , 100)
    part.Material = "ForceField"
    local pos = Vector3.new(21, 9.5, 26285)
    part.Position = pos
    task.wait(1)
    HumanoidRootPart.Anchored = false
    while HumanoidRootPart.Position.Z > 26220 do
        HumanoidRootPart.CFrame = CFrame.new(Vector3.new(HumanoidRootPart.Position.X, 13.05, HumanoidRootPart.Position.Z - 0.5))
        task.wait(0.01)
    end
    HumanoidRootPart.CFrame = CFrame.new(18, 10, 26220)

    local function Split(s, delimiter)
        result = {};
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match);
        end
        return result;
    end

--Dig to depth
    local depth = Split(game.Players.LocalPlayer.PlayerGui.ScreenGui.TopInfoFrame.Depth.Text," ")
    while tonumber(depth[1]) < Depth do
        local min = HumanoidRootPart.CFrame + Vector3.new(-1,-10,-1)
        local max = HumanoidRootPart.CFrame + Vector3.new(1,0,1)
        local region = Region3.new(min.Position, max.Position)
        local parts = workspace:FindPartsInRegion3WithWhiteList(region, {game.Workspace.Blocks}, 10)
        for _, block in pairs(parts) do
            Remote:FireServer("MineBlock",{{block.Parent}})
            task.wait()
        end
        depth = Split(game.Players.LocalPlayer.PlayerGui.ScreenGui.TopInfoFrame.Depth.Text," ")
        task.wait()
    end

    local CoinsAmount = game.Players.LocalPlayer.leaderstats.Coins
    local function GetCoinsAmount()
        local Amount = CoinsAmount.Value
        Amount = Amount:gsub(',', '')
        return tonumber(Amount)
    end

--Recover
    local recovering = false
    local player = game.Players.LocalPlayer
    local DepthAmount = player.PlayerGui.ScreenGui.TopInfoFrame.Depth
    DepthAmount.Changed:Connect(function()
        task.spawn(function()
            local depth = Split(DepthAmount.Text, " ")
            if tonumber(depth[1]) >= 1000 and not recovering then
                recovering = true
                HumanoidRootPart.Anchored = true
                task.wait(1)
                Remote:FireServer("MoveTo", {{"LavaSpawn"}})
                wait(1)
                local pos = Vector3.new(21, 9.5, 26285)
                part.Position = pos
                task.wait(1)
                HumanoidRootPart.Anchored = false
                while HumanoidRootPart.Position.Z > 26220 do
                    HumanoidRootPart.CFrame = CFrame.new(Vector3.new(HumanoidRootPart.Position.X, 13.05, HumanoidRootPart.Position.Z - 0.5))
                    task.wait(0.05)
                end
                HumanoidRootPart.CFrame = CFrame.new(18, 10, 26220)
                task.wait(5)
                recovering = false
            end
        end)
    end)

    local RebirthsAmount = game.Players.LocalPlayer.leaderstats.Rebirths
    game:GetService("RunService"):BindToRenderStep("Rebirth", Enum.RenderPriority.Camera.Value, function()
        while GetCoinsAmount() >= (10000000 * (RebirthsAmount.Value + 1)) do
            Remote:FireServer("Rebirth",{{}})
            task.wait()
        end
    end)
    
    local InventoryAmount = game.Players.LocalPlayer.PlayerGui.ScreenGui.StatsFrame2.Inventory.Amount
    local function GetInventoryAmount()
        local Amount = InventoryAmount.Text
        Amount = Amount:gsub('%s+', '')
        Amount = Amount:gsub(',', '')
        local Inventory = Amount:split("/")
        return tonumber(Inventory[1])
    end

    local Character = game.Players.LocalPlayer.Character
    local SellArea = CFrame.new(41.96064, 16.755, -1239.64648)
    while true do
        task.wait()
        if HumanoidRootPart then
            local minp = HumanoidRootPart.CFrame.Position - Vector3.new(5, 5, 5)
            local maxp = HumanoidRootPart.CFrame.Position + Vector3.new(5, 5, 5)
            local region = Region3.new(minp, maxp)
            local parts = workspace:FindPartsInRegion3WithWhiteList(region, {game.Workspace.Blocks}, 50)
            for _, block in ipairs(parts) do
                if block:IsA("BasePart") then
                    Remote:FireServer("MineBlock", {{block.Parent}})
                    repeat
                        task.wait()
                    until not recovering
                end
                if GetInventoryAmount() >= SellTreshold then
                    if Character and HumanoidRootPart then
                        local SavedPosition = HumanoidRootPart.Position
                        while GetInventoryAmount() >= SellTreshold do
                            Remote:FireServer("SellItems", {{}})
                            HumanoidRootPart.CFrame = SellArea
                            repeat
                                task.wait()
                            until not recovering
                        end
                        HumanoidRootPart.Anchored = true
                        local starttime1 = os.time()
                        while (HumanoidRootPart.Position - SavedPosition).Magnitude > 1 do
                            HumanoidRootPart.CFrame = CFrame.new(18, SavedPosition.Y, 26220)
                            task.wait()
                            if os.time() - starttime1 > 2 then
                                break
                            end
                        end
                        HumanoidRootPart.Anchored = false
                    end
                end
            end
        end
    end
end
