repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local function CreateEsp(Char, Color, Text, Parent, numberOffset)
    if not Char then return end
    KeepEsp(Char, Parent)

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, numberOffset or 3, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    task.spawn(function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        local LocalPlayer = Players.LocalPlayer
        local Camera = Workspace.CurrentCamera

        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                label.Text = Text .. " (" .. math.floor(distance + 0.5) .. " stud)"
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function KeepEsp(Char, Parent)
    if Char then
        local highlight = Char:FindFirstChildOfClass("Highlight")
        if highlight then highlight:Destroy() end
    end
    if Parent then
        local billboard = Parent:FindFirstChildOfClass("BillboardGui")
        if billboard then billboard:Destroy() end
    end
end

local function bringItemsByName(name)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(0, 3, 0) + root.CFrame.LookVector * 5
            end
        end
    end
end

local Confirmed = false
WindUI:Popup({
    Title = "Saturn Hub Loaded! - 99 Night in the Forest",
    Icon = "star",
    IconThemed = true,
    Content = "Saturn Hub by JScripter | Premium Experience",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Folder = "Saturn Hub Config | 99NitF",
    Title = "Saturn Hub - 99 Night in the Forest",
    IconThemed = true,
    Icon = "star",
    Author = "JScripter",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "Saturn Hub - Open Here",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "rocket" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Esp = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Bring = Window:Tab({ Title = "Bring Items (Patched)", Icon = "package" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
}

Tabs.Main:Button({Title="Auto Cook (Meat)", Callback=function()
    local campfirePos = Vector3.new(1.87, 4.33, -3.67)
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            local name = item.Name:lower()
            if name:find("meat") then
                local part = item:FindFirstChildWhichIsA("BasePart") or item
                if part then
                    part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2)))
                end
            end
        end
    end
end})

local ActiveEspPlayer = false
local ActiveEspItems = false
local ActiveEspEnemy = false
local ActiveEspChildren = false
local ActiveEspPeltTrader = false

Tabs.Esp:Toggle({
    Title = "Esp (Player)",
    Default = false,
    Callback = function(state)
        ActiveEspPlayer = state
        task.spawn(function()
            while ActiveEspPlayer do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = player.Character
                        if not char:FindFirstChildOfClass("Highlight") and not char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(char, Color3.fromRGB(144, 238, 144), player.Name, char.HumanoidRootPart, 2)
                        end
                    end
                end
                task.wait(0.1)
            end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    KeepEsp(char, char.HumanoidRootPart)
                end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Items)",
    Default = false,
    Callback = function(state)
        ActiveEspItems = state
        task.spawn(function()
            while ActiveEspItems do
                for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 255, 153), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Enemies)",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 182, 193), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

local espTypes = {
    ["Fuel All"] = {
        color = Color3.fromRGB(255, 218, 185),
        items = { "Log", "Fuel Canister", "Coal", "Oil Barrel" }
    },
    ["Scraps All"] = {
        color = Color3.fromRGB(192, 192, 192),
        items = { "Sheet Metal", "Broken Fan", "UFO Junk", "Bolt", "Old Radio", "UFO Scrap", "Broken Microwave" }
    },
    ["Ammo All"] = {
        color = Color3.fromRGB(144, 238, 144),
        items = { "Rifle Ammo", "Revolver Ammo" }
    },
    ["Guns All"] = {
        color = Color3.fromRGB(255, 182, 193),
        items = { "Rifle", "Revolver" }
    },
    ["Food All"] = {
        color = Color3.fromRGB(255, 255, 153),
        items = { "Meat? Sandwich", "Cake", "Carrot", "Morsel" }
    },
    ["Body All"] = {
        color = Color3.fromRGB(221, 160, 221),
        items = { "Leather Body", "Iron Body" }
    },
    ["Bandage"] = {
        color = Color3.fromRGB(255, 218, 185),
        items = { "Bandage" }
    },
    ["Medkit"] = {
        color = Color3.fromRGB(255, 182, 193),
        items = { "MedKit" }
    },
    ["Coin"] = {
        color = Color3.fromRGB(255, 239, 153),
        items = { "Coin Stack" }
    }
}

for category, data in pairs(espTypes) do
    Tabs.Esp:Toggle({
        Title = "ESP (" .. category .. ")",
        Default = false,
        Callback = function(state)
            local active = state
            task.spawn(function()
                while active do
                    for _, obj in pairs(game.Workspace.Items:GetChildren()) do
                        if obj:IsA("Model") and obj.PrimaryPart and not obj:FindFirstChildOfClass("Highlight") and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            for _, itemName in pairs(data.items) do
                                if string.lower(obj.Name) == string.lower(itemName) then
                                    CreateEsp(obj, data.color, obj.Name, obj.PrimaryPart, 2)
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.25)
                end
                for _, obj in pairs(game.Workspace.Items:GetChildren()) do
                    for _, itemName in pairs(data.items) do
                        if string.lower(obj.Name) == string.lower(itemName) then
                            KeepEsp(obj, obj.PrimaryPart)
                            break
                        end
                    end
                end
            end)
        end
    })
end

Tabs.Esp:Toggle({
    Title = "Esp (Children)",
    Default = false,
    Callback = function(state)
        ActiveEspChildren = state
        task.spawn(function()
            while ActiveEspChildren do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(173, 216, 230), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Pelt Trader)",
    Default = false,
    Callback = function(state)
        ActiveEspPeltTrader = state
        task.spawn(function()
            while ActiveEspPeltTrader do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") and not Obj:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(176, 224, 230), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Teleport:Button({
    Title="Teleport to Camp",
    Callback=function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end
})

Tabs.Teleport:Button({
    Title="TP to NPC Trader",
    Callback=function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Button({
    Title = "TP to Random Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

local lostChildNames = {"Lost Child", "Lost Child2", "Lost Child3", "Lost Child4"}

for i, name in ipairs(lostChildNames) do
    Tabs.Teleport:Button({
        Title = "TP to Lost Child " .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Characters
            local targetLostChild = workspaceCharacters:FindFirstChild(name)
            if targetLostChild and targetLostChild:IsA("Model") and targetLostChild.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetLostChild.PrimaryPart.CFrame
            end
        end
    })
end

Tabs.Bring:Button({Title="Bring Everything (Fixed Lag)",Callback=function()
    for _, item in ipairs(workspace.Items:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
        if part then
            part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-44,44), 0, math.random(-44,44))
        end
    end
end})

for i = 1, 4 do
    Tabs.Bring:Button({Title="Bring Lost Child " .. i, Callback=function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, item in pairs(workspace.Characters:GetChildren()) do
            if item.Name:lower():find("lost child" .. (i == 1 and "" or i)) and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end})
end

local bringItems = {
    "Logs", "Fuel Canister", "Oil Barrel", "Coal", "Meat (Raw & Cooked)",
    "Flashlight", "Nails", "Fan", "Rope", "Scrap", "Wood", "Cloth",
    "Rock", "Stone Pickaxe", "Knife", "Spear", "Leather Body", "Iron Body",
    "Revolver", "Rifle", "Bandage", "MedKit", "Old Radio", "Coin Stack",
    "UFO Junk", "UFO Scrap", "Broken Microwave", "Bolt", "Chair", "Seed Box",
    "Meat? Sandwich", "Cake", "Carrot", "Morsel", "Tyre", "Broken Fan",
    "Sheet Metal", "Strong Axe", "Good Axe", "Old Axe", "Rifle Ammo", "Revolver Ammo"
}

for _, item in ipairs(bringItems) do
    if item == "Meat (Raw & Cooked)" then
        Tabs.Bring:Button({Title="Bring " .. item, Callback=function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, item in pairs(workspace.Items:GetChildren()) do
                local name = item.Name:lower()
                if (name:find("meat") or name:find("cooked")) and item:IsA("Model") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                end
            end
        end})
    elseif item == "Logs" then
        Tabs.Bring:Button({Title="Bring " .. item, Callback=function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item.Name:lower():find("log") and item:IsA("Model") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                end
            end
        end})
    else
        Tabs.Bring:Button({Title="Bring " .. item, Callback=function() bringItemsByName(item) end})
    end
end

Tabs.Bring:Button({ Title = "Bring Scrap All", Callback = function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local scrapNames = {
        ["tyre"] = true, ["sheet metal"] = true, ["broken fan"] = true, ["bolt"] = true, ["old radio"] = true, ["ufo junk"] = true, ["ufo scrap"] = true, ["broken microwave"] = true,
    }
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            for scrapName, _ in pairs(scrapNames) do
                if itemName:find(scrapName) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                    break
                end
            end
        end
    end
end })

local hitboxSettings = {
    Wolf = false,
    Bunny = false,
    Cultist = false,
    All = false,
    Show = false,
    Size = 10
}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()

    if hitboxSettings.All then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
        return
    end

    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))

    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Toggle({Title="Expand All Hitbox", Default=false, Callback=function(val) hitboxSettings.All=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=250, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})

Tabs.Player:Slider({
    Title = "Set WalkSpeed",
    Value = {Min = 5, Max = 500, Default = 16},
    Step = 1,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end
})

Tabs.Player:Slider({
    Title = "Set JumpPower",
    Value = {Min = 10, Max = 500, Default = 50},
    Step = 1,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = val
        end
    end
})

local speedBoostEnabled = false
Tabs.Player:Button({
    Title = "Boost Speed by Saturn",
    Callback = function()
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            speedBoostEnabled = not speedBoostEnabled
            humanoid.WalkSpeed = speedBoostEnabled and 100 or 16
        end
    end
})

Tabs.Player:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Dly"))()
    end
})

local noclipConnection
Tabs.Player:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "No Cooldown (Good Axe Only)",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.BreakJointsOnDeath = not state
        end
    end
})

Tabs.Player:Toggle({
    Title = "God mode (In development)",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.BreakJointsOnDeath = not state
        end
    end
})

Tabs.Player:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if state then
                Humanoid.JumpPower = math.huge
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                local jumpConnection = Humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Landed and Humanoid.JumpPower == math.huge then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                Humanoid:SetAttribute("InfinityJumpConnection", jumpConnection)
            else
                Humanoid.JumpPower = 50
                local jumpConnection = Humanoid:GetAttribute("InfinityJumpConnection")
                if jumpConnection then
                    jumpConnection:Disconnect()
                    Humanoid:SetAttribute("InfinityJumpConnection", nil)
                end
            end
        end
    end
})