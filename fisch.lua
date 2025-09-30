-- Load CompKiller UI
local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();

-- Create Notification
local Notifier = Compkiller.newNotify();

-- Create Config Manager
local ConfigManager = Compkiller:ConfigManager({
    Directory = "Aurora-Hex",
    Config = "Fisch-Configs"
});

-- Apply Theme Colors
local Main = Color3.fromRGB(138, 43, 226) -- Purple theme
Compkiller.Colors.Highlight = Main
Compkiller.Colors.TextColor = Color3.fromRGB(255,255,255)
Compkiller.Colors.Toggle = Main
Compkiller.Colors.BlockColor = Color3.fromRGB(25, 25, 35)
Compkiller.Colors.BGDBColor = Color3.fromRGB(15, 15, 20)
Compkiller.Colors.BlockBackground = Color3.fromRGB(30, 30, 40)
Compkiller.Colors.StrokeColor = Color3.fromRGB(60, 70, 90)
Compkiller.Colors.HighStrokeColor = Main
Compkiller.Colors.SwitchColor = Main:lerp(Color3.fromRGB(100,120,160), 0.5)
Compkiller.Colors.LineColor = Color3.fromRGB(70, 80, 100)
Compkiller:RefreshCurrentColor()

-- Loading UI
Compkiller:Loader("rbxassetid://104487529937663", 2.5).yield();

local market = game:GetService('MarketplaceService')
local info = market:GetProductInfo(game.PlaceId)

-- Create Window
local Window = Compkiller.new({
    Name = "Aurora Hex | Fisch | Premium",
    Keybind = "End",
    Logo = "rbxassetid://104487529937663",
    Scale = Compkiller.Scale.Window,
    TextSize = 15,
});

-- Watermark
local Watermark = Window:Watermark();

Watermark:AddText({
    Icon = "user",
    Text = "Aurora Hex",
});

Watermark:AddText({
    Icon = "clock",
    Text = Compkiller:GetDate(),
});

local Time = Watermark:AddText({
    Icon = "timer",
    Text = "TIME",
});

task.spawn(function()
    while true do task.wait()
        Time:SetText(Compkiller:GetTimeNow());
    end
end)

Watermark:AddText({
    Icon = "game-2",
    Text = info.Name,
});

-- Tables
local teleportSpots = {}
local racistPeople = {}
local itemSpots = {
    Bait_Crate = CFrame.new(384.57513427734375, 135.3519287109375, 337.5340270996094),
    Carbon_Rod = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
    Crab_Cage = CFrame.new(474.803589, 149.664566, 229.49469, -0.721874595, 0, 0.692023814, 0, 1, 0, -0.692023814, 0, -0.721874595),
    Fast_Rod = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
    Flimsy_Rod = CFrame.new(471.107697, 148.36171, 229.642441, 0.841614008, 0.0774728209, -0.534493923, 0.00678436086, 0.988063335, 0.153898612, 0.540036798, -0.13314943, 0.831042409),
    GPS = CFrame.new(517.896729, 149.217636, 284.856842, 7.39097595e-06, -0.719539165, -0.694451928, -1, -7.39097595e-06, -3.01003456e-06, -3.01003456e-06, 0.694451928, -0.719539165),
    Long_Rod = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
    Lucky_Rod = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
    Plastic_Rod = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
    Training_Rod = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998)
}

local fisktable = {}

-- Services
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Locals
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local ActiveFolder = Workspace:FindFirstChild("active")
local FishingZonesFolder = Workspace:FindFirstChild("zones"):WaitForChild("fishing")
local TpSpotsFolder = Workspace:FindFirstChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")
local NpcFolder = Workspace:FindFirstChild("world"):WaitForChild("npcs")
local PlayerGUI = LocalPlayer:FindFirstChildOfClass("PlayerGui")
local RenderStepped = RunService.RenderStepped
local WaitForSomeone = RenderStepped.Wait
local Debug = function()
    print(debug.info(2, "l"))
end

-- Variables
local autoSell = false
local autoShake = false
local autoShakeDelay = 0.1
local autoShakeMethod = "KeyCodeEvent"
local autoShakeClickOffsetX = 0
local autoShakeClickOffsetY = 0
local autoReel = false
local autoReelDelay = 2
local autoCast = false
local autoCastMode = "Legit"
local autoCastDelay = 2
local ZoneCast = false
local Zone = "Brine Pool"
local Noclip = false
local AntiDrown = false
local CollarPlayer = false
local Target
local FreezeChar = false

-- Rest (Game Logic - unchanged)
autoreelandshakeConnection = PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") and GUI.Name == "shakeui" then
        if GUI:FindFirstChild("safezone") ~= nil then
            GUI.safezone.ChildAdded:Connect(function(child)
                if child:IsA("ImageButton") and child.Name == "button" then
                    if autoShake == true then
                        task.wait(autoShakeDelay)
                        if child.Visible == true then
                            if autoShakeMethod == "ClickEvent" then
                                local pos = child.AbsolutePosition
                                local size = child.AbsoluteSize
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, LocalPlayer, 0)
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, LocalPlayer, 0)
                            elseif autoShakeMethod == "KeyCodeEvent" then
                                while WaitForSomeone(RenderStepped) do
                                    if autoShake and GUI.safezone:FindFirstChild(child.Name) ~= nil then
                                        task.wait()
                                        pcall(function()
                                            GuiService.SelectedObject = child
                                            if GuiService.SelectedObject == child then
                                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                            end
                                        end)
                                    else
                                        GuiService.SelectedObject = nil
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    if GUI:IsA("ScreenGui") and GUI.Name == "reel" then
        if autoReel and ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished") ~= nil then
            repeat task.wait(autoReelDelay) ReplicatedStorage.events.reelfinished:FireServer(100, false) until GUI == nil
        end
    end
end)

autoCastConnection = LocalCharacter.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child:FindFirstChild("events"):WaitForChild("cast") ~= nil and autoCast then
        task.wait(autoCastDelay)
        if autoCastMode == "Legit" then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
            HumanoidRootPart.ChildAdded:Connect(function()
                if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
                    HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
                        if property == "Size" then
                            if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, LocalPlayer, 0)
                            end
                        end
                    end)
                end
            end)
        elseif autoCastMode == "Rage" then
            child.events.cast:FireServer(100)
        end
    end
end)

autoCastConnection2 = PlayerGUI.ChildRemoved:Connect(function(GUI)
    local Tool = LocalCharacter:FindFirstChildOfClass("Tool")
    if GUI.Name == "reel" and autoCast == true and Tool ~= nil and Tool:FindFirstChild("events"):WaitForChild("cast") ~= nil then
        task.wait(autoCastDelay)
        if autoCastMode == "Legit" then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
            HumanoidRootPart.ChildAdded:Connect(function()
                if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
                    HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
                        if property == "Size" then
                            if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, LocalPlayer, 0)
                            end
                        end
                    end)
                end
            end)
        elseif autoCastMode == "Rage" then
            Tool.events.cast:FireServer(100)
        end
    end
end)

ZoneConnection = LocalCharacter.ChildAdded:Connect(function(child)
    if ZoneCast and child:IsA("Tool") and FishingZonesFolder:FindFirstChild(Zone) ~= nil then
        child.ChildAdded:Connect(function(blehh)
            if blehh.Name == "bobber" then
                local RopeConstraint = blehh:FindFirstChildOfClass("RopeConstraint")
                if ZoneCast and RopeConstraint ~= nil then
                    RopeConstraint.Changed:Connect(function(property)
                        if property == "Length" then
                            RopeConstraint.Length = math.huge
                        end
                    end)
                    RopeConstraint.Length = math.huge
                end
                task.wait(1)
                while WaitForSomeone(RenderStepped) do
                    if ZoneCast and blehh.Parent ~= nil then
                        task.wait()
                        blehh.CFrame = FishingZonesFolder[Zone].CFrame
                    else
                        break
                    end
                end
            end
        end)
    end
end)

CollarConnection = LocalCharacter.ChildAdded:Connect(function(child)
    if CollarPlayer and child:IsA("Tool") and Players:FindFirstChild(Target).Character:FindFirstChild("Head") ~= nil then
        child.ChildAdded:Connect(function(blehh)
            if blehh.Name == "bobber" then
                local RopeConstraint = blehh:FindFirstChildOfClass("RopeConstraint")
                if CollarPlayer and RopeConstraint ~= nil then
                    RopeConstraint.Changed:Connect(function(property)
                        if property == "Length" then
                            RopeConstraint.Length = math.huge
                        end
                    end)
                    RopeConstraint.Length = math.huge
                end
                task.wait(1)
                while WaitForSomeone(RenderStepped) do
                    if CollarPlayer and blehh.Parent ~= nil then
                        task.wait()
                        blehh.CFrame = Players:FindFirstChild(Target).Character:FindFirstChild("Head").CFrame + Vector3.new(0, -1, 0)
                    else
                        break
                    end
                end
            end
        end)
    end
end)

NoclipConnection = RunService.Stepped:Connect(function()
    if Noclip == true then
        if LocalCharacter ~= nil then
            for i, v in pairs(LocalCharacter:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
end)

local SafeZone = Instance.new("Part")
SafeZone.Parent = Workspace
SafeZone.Size = Vector3.new(50, 2, 50)
SafeZone.CFrame = CFrame.new(9999, 9999, 9999)
SafeZone.Anchored = true

for i, v in pairs(FishingZonesFolder:GetChildren()) do
    if table.find(fisktable, v.Name) == nil then
        table.insert(fisktable, v.Name)
    end
end

FishingZonesFolder.ChildAdded:Connect(function(child)
    if table.find(fisktable, child.Name) == nil then
        table.insert(fisktable, child.Name)
    end
end)

for i, v in pairs(TpSpotsFolder:GetChildren()) do
    if table.find(teleportSpots, v.Name) == nil then
        table.insert(teleportSpots, v.Name)
    end
end

for i, v in pairs(NpcFolder:GetChildren()) do
    if table.find(racistPeople, v.Name) == nil and v.Name ~= "mirror Area" then
        table.insert(racistPeople, v.Name)
    end
end

NpcFolder.ChildAdded:Connect(function(child)
    if table.find(racistPeople, child.Name) == nil and child.Name ~= "mirror Area" then
        table.insert(racistPeople, child.Name)
    end
end)

-- Create UI Categories and Tabs
Window:DrawCategory({
    Name = "Automation"
});

-- Main Tab
local MainTab = Window:DrawTab({
    Name = "Main",
    Icon = "fish",
    Type = "Double",
    EnableScrolling = true
});

-- Auto Shake Section
local AutoShakeSection = MainTab:DrawSection({
    Name = "Auto Shake",
    Position = "left"
});

local AutoShakeToggle = AutoShakeSection:AddToggle({
    Name = "Enabled",
    Flag = "AutoShake",
    Default = false,
    Callback = function(Value)
        autoShake = Value
    end
});

AutoShakeToggle.Link:AddHelper({
    Text = "Automatically clicks the shake button for you"
})

local AutoShakeOption = AutoShakeToggle.Link:AddOption()

AutoShakeOption:AddDropdown({
    Name = "Auto Shake Method",
    Flag = "AutoShakeMethod",
    Default = "KeyCodeEvent",
    Values = {"ClickEvent", "KeyCodeEvent"},
    Callback = function(Value)
        autoShakeMethod = Value
    end
})

AutoShakeOption:AddSlider({
    Name = "Auto-Shake Delay",
    Flag = "AutoShakeDelay",
    Min = 0,
    Max = 10,
    Default = 0.1,
    Round = 1,
    Callback = function(Value)
        autoShakeDelay = Value
    end
})

-- Auto Reel Section
local AutoReelSection = MainTab:DrawSection({
    Name = "Auto Reel",
    Position = "left"
});

local AutoReelToggle = AutoReelSection:AddToggle({
    Name = "Enabled",
    Flag = "AutoReel",
    Default = false,
    Callback = function(Value)
        autoReel = Value
    end
});

AutoReelToggle.Link:AddHelper({
    Text = "Automatically reels in the fishing rod"
})

local AutoReelOption = AutoReelToggle.Link:AddOption()

AutoReelOption:AddSlider({
    Name = "Auto-Reel Delay",
    Flag = "AutoReelDelay",
    Min = 0,
    Max = 10,
    Default = 2,
    Round = 1,
    Callback = function(Value)
        autoReelDelay = Value
    end
})

-- Auto Cast Section
local AutoCastSection = MainTab:DrawSection({
    Name = "Auto Cast",
    Position = "left"
});

local AutoCastToggle = AutoCastSection:AddToggle({
    Name = "Enabled",
    Flag = "AutoCast",
    Default = false,
    Callback = function(Value)
        autoCast = Value
        local Tool = LocalCharacter:FindFirstChildOfClass("Tool")
        if Tool ~= nil and Tool:FindFirstChild("events"):WaitForChild("cast") ~= nil and Value == true then
            task.wait(autoCastDelay)
            if autoCastMode == "Legit" then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
                HumanoidRootPart.ChildAdded:Connect(function()
                    if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
                        HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
                            if property == "Size" then
                                if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, LocalPlayer, 0)
                                end
                            end
                        end)
                    end
                end)
            elseif autoCastMode == "Rage" then
                Tool.events.cast:FireServer(100)
            end
        end
    end
});

AutoCastToggle.Link:AddHelper({
    Text = "Automatically throws the rod"
})

local AutoCastOption = AutoCastToggle.Link:AddOption()

AutoCastOption:AddSlider({
    Name = "Auto-Cast Delay",
    Flag = "AutoCastDelay",
    Min = 0,
    Max = 10,
    Default = 2,
    Round = 1,
    Callback = function(Value)
        autoCastDelay = Value
    end
})

AutoCastOption:AddDropdown({
    Name = "Auto Cast Mode",
    Flag = "AutoCastMode",
    Default = "Legit",
    Values = {"Legit", "Rage"},
    Callback = function(Value)
        autoCastMode = Value
    end
})

-- Fish Utilities Section (Right side)
local FishUtilitiesSection = MainTab:DrawSection({
    Name = "Fish Utilities",
    Position = "right"
});

FishUtilitiesSection:AddToggle({
    Name = "Sell ALL fish (Automatically)",
    Flag = "AutoSell",
    Default = false,
    Callback = function(Value)
        autoSell = Value

        task.spawn(function()
            while autoSell do
                local npc = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant")
                local args = {
                    {
                        voice = 12,
                        npc = npc,
                        idle = npc:WaitForChild("description"):WaitForChild("idle")
                    }
                }

                local sellAllEvent = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll")

                pcall(function()
                    sellAllEvent:InvokeServer(unpack(args))
                end)
                task.wait(2)
                sellAllEvent:FireServer(unpack(args))

                task.wait(2)
            end
        end)
    end
});

FishUtilitiesSection:AddButton({
    Name = "Sell a fish",
    Callback = function()
        local world = workspace:WaitForChild("world")
        local npcs = world:WaitForChild("npcs")
        local merchant = npcs:WaitForChild("Merchant Matey")

        local args = {{
            voice = 12,
            npc = merchant,
            idle = merchant:WaitForChild("description"):WaitForChild("idle")
        }}

        local events = game:GetService("ReplicatedStorage"):WaitForChild("events")
        local sell = events:WaitForChild("Sell")

        sell:InvokeServer(unpack(args))
    end,
});

FishUtilitiesSection:AddButton({
    Name = "Sell ALL fish (Starter Zone)",
    Callback = function()
        local npc = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant")
        local args = {
            {
                voice = 12,
                npc = npc,
                idle = npc:WaitForChild("description"):WaitForChild("idle")
            }
        }

        local sellAllEvent = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll")
        sellAllEvent:InvokeServer(unpack(args))
        wait(0.5)
        sellAllEvent:FireServer(unpack(args))
    end,
});

FishUtilitiesSection:AddButton({
    Name = "Sell ALL fish (Broken Zone)",
    Callback = function()
        local world = workspace:WaitForChild("world")
        local npcs = world:WaitForChild("npcs")
        local merchant = npcs:WaitForChild("Merchant Matey")

        local args = {{
            voice = 12,
            npc = merchant,
            idle = merchant:WaitForChild("description"):WaitForChild("idle")
        }}

        local events = game:GetService("ReplicatedStorage"):WaitForChild("events")
        local sellAll = events:WaitForChild("SellAll")

        sellAll:InvokeServer(unpack(args))
    end,
});

FishUtilitiesSection:AddButton({
    Name = "Appraise fish (450C$)",
    Callback = function()
        Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
    end,
});

-- Zone Cast Section (Right side)
local ZoneCastSection = MainTab:DrawSection({
    Name = "Zone Cast",
    Position = "right"
});

local ZoneCastToggle = ZoneCastSection:AddToggle({
    Name = "Enabled",
    Flag = "ZoneCast",
    Default = false,
    Callback = function(Value)
        ZoneCast = Value
    end
});

ZoneCastToggle.Link:AddHelper({
    Text = "Throws the rod to another zone"
})

local ZoneCastOption = ZoneCastToggle.Link:AddOption()

ZoneCastOption:AddDropdown({
    Name = "Zone",
    Flag = "ZoneCastValue",
    Default = "Brine Pool",
    Values = fisktable,
    Callback = function(Value)
        Zone = Value
    end
})

-- Collar Player Section (Right side)
local CollarPlayerSection = MainTab:DrawSection({
    Name = "Collar Player",
    Position = "right"
});

local CollarPlayerToggle = CollarPlayerSection:AddToggle({
    Name = "Enabled",
    Flag = "CollarPlayer",
    Default = false,
    Callback = function(Value)
        CollarPlayer = Value
    end
});

CollarPlayerToggle.Link:AddHelper({
    Text = "Collar's the player making them look like your pet :3"
})

local CollarPlayerOption = CollarPlayerToggle.Link:AddOption()

CollarPlayerOption:AddDropdown({
    Name = "Player",
    Flag = "CollarTarget",
    Values = {},
    Default = "",
    Multi = false,
    Callback = function(Value)
        Target = Value
    end
})

-- Update player list
task.spawn(function()
    while task.wait(1) do
        local playerNames = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        CollarPlayerOption:AddDropdown({
            Name = "Player",
            Flag = "CollarTarget",
            Values = playerNames,
            Default = Target or "",
            Multi = false,
            Callback = function(Value)
                Target = Value
            end
        })
    end
end)

-- Teleports Tab
local TeleportsTab = Window:DrawTab({
    Name = "Teleports",
    Icon = "map-pin",
    Type = "Double",
    EnableScrolling = true
});

local TeleportsSection = TeleportsTab:DrawSection({
    Name = "Teleports",
    Position = "left"
});

TeleportsSection:AddDropdown({
    Name = "Place teleport",
    Flag = "PlaceTeleport",
    Default = "",
    Values = teleportSpots,
    Callback = function(Value)
        if teleportSpots ~= nil and HumanoidRootPart ~= nil then
            HumanoidRootPart.CFrame = TpSpotsFolder:FindFirstChild(Value).CFrame + Vector3.new(0, 5, 0)
        end
    end
});

TeleportsSection:AddDropdown({
    Name = "Teleport to Npc",
    Flag = "NPCTeleport",
    Default = "",
    Values = racistPeople,
    Callback = function(Value)
        if racistPeople ~= nil and HumanoidRootPart ~= nil then
            HumanoidRootPart.CFrame = NpcFolder:FindFirstChild(Value):WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0, 1, 0)
        end
    end
});

TeleportsSection:AddDropdown({
    Name = "Teleport to item",
    Flag = "ItemTeleport",
    Default = "",
    Values = {"Bait_Crate", "Carbon_Rod", "Crab_Cage", "Fast_Rod", "Flimsy_Rod", "GPS", "Long_Rod", "Lucky_Rod", "Plastic_Rod", "Training_Rod"},
    Callback = function(Value)
        if itemSpots ~= nil and HumanoidRootPart ~= nil then
            HumanoidRootPart.CFrame = itemSpots[Value]
        end
    end
});

local SafeZoneSection = TeleportsTab:DrawSection({
    Name = "Safe Zone",
    Position = "right"
});

SafeZoneSection:AddButton({
    Name = "Teleport to safe zone",
    Callback = function()
        HumanoidRootPart.CFrame = SafeZone.CFrame + Vector3.new(0, 2, 0)
    end,
});

-- LocalPlayer Tab
local LocalPlayerTab = Window:DrawTab({
    Name = "LocalPlayer",
    Icon = "user",
    Type = "Double",
    EnableScrolling = true
});

local LocalPlayerSection = LocalPlayerTab:DrawSection({
    Name = "LocalPlayer",
    Position = "left"
});

LocalPlayerSection:AddToggle({
    Name = "Noclip",
    Flag = "Noclip",
    Default = false,
    Callback = function(Value)
        Noclip = Value
    end
});

LocalPlayerSection:AddToggle({
    Name = "Disable Oxygen",
    Flag = "AntiDrown",
    Default = false,
    Callback = function(Value)
        AntiDrown = Value
        if Value == true then
            if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == true then	
                LocalCharacter.client.oxygen.Enabled = false	
            end	
            CharAddedAntiDrownCon = LocalPlayer.CharacterAdded:Connect(function()	
                if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == true and AntiDrown == true then	
                    LocalCharacter.client.oxygen.Enabled = false	
                end	
            end)
        else	
            if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == false then	
                LocalCharacter.client.oxygen.Enabled = true	
            end	
        end
    end
});

local FreezeCharacterSection = LocalPlayerTab:DrawSection({
    Name = "Freeze Character",
    Position = "left"
});

FreezeCharacterSection:AddToggle({
    Name = "Enabled",
    Flag = "FreezeCharacter",
    Default = false,
    Callback = function(Value)
        local oldpos = HumanoidRootPart.CFrame
        FreezeChar = Value
        task.wait()
        while WaitForSomeone(RenderStepped) do
            if FreezeChar and HumanoidRootPart ~= nil then
                task.wait()
                HumanoidRootPart.CFrame = oldpos
            else
                break
            end
        end
    end
});

local ResetSection = LocalPlayerTab:DrawSection({
    Name = "Reset",
    Position = "right"
});

ResetSection:AddButton({
    Name = "Reset rod",
    Callback = function()
        local tool = LocalCharacter:FindFirstChildOfClass("Tool")
        if tool:FindFirstChild("events"):WaitForChild("reset") ~= nil then
            tool.events.reset:FireServer()
        end
    end,
});

local AntiAfkSection = LocalPlayerTab:DrawSection({
    Name = "AntiAFK",
    Position = "right"
});

AntiAfkSection:AddButton({
    Name = "Anti-AFK",
    Callback = function()
        Notifier.new({
            Title = "Aurora Hex",
            Content = "Anti-AFK is now running!",
            Duration = 5,
            Icon = "rbxassetid://104487529937663"
        });
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end,
});

-- Settings Category
Window:DrawCategory({
    Name = "Settings"
});

-- Settings Tab
local SettingsTab = Window:DrawTab({
    Name = "Settings",
    Icon = "settings",
    Type = "Single",
    EnableScrolling = true
});

local InfoSection = SettingsTab:DrawSection({
    Name = "Developer Info",
    Position = "left"
});

InfoSection:AddParagraph({
    Title = "Credits",
    Content = "Developer: Evan_Slacker\nVersion: 5.9.6\nType: Premium\nUpdate: 9/9/2025"
});

InfoSection:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard('https://discord.gg/6UaRDjBY42')
        Notifier.new({
            Title = "Aurora Hex",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
            Icon = "rbxassetid://104487529937663"
        });
    end,
});

InfoSection:AddParagraph({
    Title = "Discord Server",
    Content = "Server Name: Loading...\nMembers Count: Loading...\nMembers Online: Loading..."
});

-- Note: Real-time Discord info would require external API access which is not possible in Roblox
-- This is placeholder text that would normally be updated via HTTP requests

local UISection = SettingsTab:DrawSection({
    Name = "UI Settings",
    Position = "left"
});

UISection:AddButton({
    Name = "Unload Script",
    Callback = function()
        -- Cleanup connections
        if autoReel then
            autoReel = false
        end
        if autoShake then
            autoShake = false
        end
        if AntiDrown then
            if LocalCharacter ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen") ~= nil and LocalCharacter:FindFirstChild("client"):WaitForChild("oxygen").Enabled == false then
                LocalCharacter.client.oxygen.Enabled = true
                if CharAddedAntiDrownCon then
                    CharAddedAntiDrownCon:Disconnect()
                end
                AntiDrown = false
            end
        end
        if Noclip then
            Noclip = false
        end
        if autoCast then
            autoCast = false
        end
        if ZoneCast then
            ZoneCast = false
        end
        if CollarPlayer then
            CollarPlayer = false
        end
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
        if autoreelandshakeConnection then
            autoreelandshakeConnection:Disconnect()
        end
        if autoCastConnection then
            autoCastConnection:Disconnect()
        end
        if autoCastConnection2 then
            autoCastConnection2:Disconnect()
        end
        if ZoneConnection then
            ZoneConnection:Disconnect()
        end
        if CollarConnection then
            CollarConnection:Disconnect()
        end
        
        -- Unload UI
        Window:Destroy()
    end,
});

-- Config Tab
local ConfigUI = Window:DrawConfig({
    Name = "Config",
    Icon = "folder",
    Config = ConfigManager
});

ConfigUI:Init();

-- Version Check
local Version = "5.9.6"

task.spawn(function()
    local success, LatestVer = pcall(function()
        local version = game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/Fisch/Version.lua")
        return HttpService:JSONDecode(version)
    end)
    
    if success then
        if Version ~= LatestVer then
            Notifier.new({
                Title = "Aurora Hex",
                Content = "You are using an outdated version of the script.",
                Duration = 10,
                Icon = "rbxassetid://104487529937663"
            });
        end
    end
end)