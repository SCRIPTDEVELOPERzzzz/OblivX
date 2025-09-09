local OK, library = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTDEVELOPERzzzz/FuckLove/refs/heads/main/FuckLove/FuckLove/FuckLove/FuckLove.lua", true))()
end)
if not OK or not library then
	warn("[Farming GUI] Failed to load Elerium v2 library. Script will still try to run safe GUI parts.")
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function safe_call(fn, ...)
	local ok, ret = pcall(fn, ...)
	if not ok then
		warn("[Farming GUI] UI call failed:", ret)
		return nil
	end
	return ret
end

-- Custom window title bar using player DisplayName
local windowTitle = ("OblivX Hub - Thanks for buying VeX Hub X | Paid [%s]"):format(player.DisplayName or player.Name)

-- Create window using custom title
local window = nil
if library and type(library.AddWindow) == "function" then
	window = safe_call(library.AddWindow, library, windowTitle, {
		main_color = Color3.fromRGB(0, 0, 0),
		min_size = Vector2.new(700, 700),
		can_resize = true,
	})
end
if not window then
	window = {
		AddTab = function() 
			return {
				AddLabel = function() return nil end,
				AddTextBox = function() return nil end,
				AddSwitch = function() return nil end,
				Show = function() end,
			}
		end
	}
end

-- ... (rest of your UI script here, unchanged from pasted2.txt) ...
-- SINGLE GLITCHING TAB
local glitchingTab = window:AddTab("Glitching")

glitchingTab:AddLabel("----------VeX Paid RockV1----------")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local selectrock

-- Define gettool function
local function gettool()
    for i, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "Punch" and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:EquipTool(v)
        end
    end
    player.muscleEvent:FireServer("punch", "leftHand")
    player.muscleEvent:FireServer("punch", "rightHand")
end

-- Lock Position Function
local function lockPosition()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    for _, obj in ipairs(hrp:GetChildren()) do
        if obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
            obj:Destroy()
        end
    end
    local lockedCFrame = hrp.CFrame
    local bodyPos = Instance.new("BodyPosition")
    bodyPos.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyPos.Position = lockedCFrame.Position
    bodyPos.D = 1000
    bodyPos.P = 1e5
    bodyPos.Parent = hrp
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.CFrame = lockedCFrame
    bodyGyro.D = 1000
    bodyGyro.P = 1e5
    bodyGyro.Parent = hrp
    return function()
        pcall(function() bodyPos:Destroy() bodyGyro:Destroy() end)
    end
end

-- Auto Fast Punch Function
local function startAutoFastPunch(stopSignal)
    local running = true
    local punchTask = task.spawn(function()
        while running and not stopSignal() do
            local character = player.Character
            if character and not character:FindFirstChild("Punch") then
                local punch = player.Backpack:FindFirstChild("Punch")
                if punch then
                    if punch:FindFirstChild("attackTime") then
                        punch.attackTime.Value = 0
                    end
                    character.Humanoid:EquipTool(punch)
                end
            elseif character and character:FindFirstChild("Punch") then
                local equipped = character:FindFirstChild("Punch")
                if equipped:FindFirstChild("attackTime") then
                    equipped.attackTime.Value = 0
                end
            end
            task.wait(0.1)
        end
    end)
    local fastPunchTask = task.spawn(function()
        while running and not stopSignal() do
            local character = player.Character
            if character then
                local punchTool = character:FindFirstChild("Punch")
                if punchTool then punchTool:Activate() end
            end
            player.muscleEvent:FireServer("punch", "rightHand")
            player.muscleEvent:FireServer("punch", "leftHand")
            task.wait(0.15)
        end
    end)
    return function()
        running = false
    end
end

-- Auto Rock Toggles (Durability-based)
local durabilityRocks = {
    {name="Tiny Rock", value=0},
    {name="Starter Rock", value=100},
    {name="Legend Beach Rock", value=5000},
    {name="Frozen Rock", value=150000},
    {name="Mythical Rock", value=400000},
    {name="Inferno Rock", value=750000},
    {name="Legend Rock", value=1000000},
    {name="Muscle King Rock", value=5000000},
    {name="Jungle Rock", value=10000000},
}

for _, rock in ipairs(durabilityRocks) do
    glitchingTab:AddSwitch("Auto Punch " .. rock.name .. " (" .. rock.value .. ")", function(enabled)
        getgenv().autoFarm = enabled
        task.spawn(function()
            while getgenv().autoFarm do
                task.wait()
                if not getgenv().autoFarm then break end
                if player.Durability.Value >= rock.value then
                    for i, v in pairs(game.Workspace.machinesFolder:GetDescendants()) do
                        if v.Name == "neededDurability" and v.Value == rock.value and player.Character:FindFirstChild("LeftHand") and player.Character:FindFirstChild("RightHand") then
                            firetouchinterest(v.Parent.Rock, player.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, player.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, player.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, player.Character.LeftHand, 1)
                            gettool()
                        end
                    end
                end
            end
        end)
    end)
end

-- Auto Rock V2 Toggles (Teleport + Fast Punch)
local rocksV2 = {
    { name="Tiny Rock", CFrame=CFrame.new(15.166, 8.524, 2095.036, -0.996226, 0, -0.086796, 0, 1, 0, 0.086796, 0, -0.996226) },
    { name="Muscle Rock", CFrame=CFrame.new(-8964.373, 9.663, -6134.546, -0.999739, 0, -0.022827, 0, 1, 0, 0.022827, 0, -0.999739) },
    { name="Mystic Rock", CFrame=CFrame.new(2171.710, 7.793, 1289.757, 0.945463, 0, -0.325730, 0, 1, 0, 0.325730, 0, 0.945463) },
    { name="Legend Rock", CFrame=CFrame.new(4182.626, 992.000, -4054.639, 0.511141, 0, 0.859497, 0, 1, 0, -0.859497, 0, 0.511141) },
    { name="Eternal Rock", CFrame=CFrame.new(-7283.623, 7.793, -1297.459, -0.900332, 0, -0.435205, 0, 1, 0, 0.435205, 0, -0.900332) },
    { name="Frozen Rock", CFrame=CFrame.new(-2579.328, 8.782, -272.074, -0.951082, 0, -0.308940, 0, 1, 0, 0.308940, 0, -0.951082) },
    { name="Punching Rock", CFrame=CFrame.new(-154.469, 7.793, 407.537, -0.973748, 0, -0.227630, 0, 1, 0, 0.227630, 0, -0.973748) },
    { name="Large Rock", CFrame=CFrame.new(160.409, 7.793, -137.992, 0.857985, 0, -0.513674, 0, 1, 0, 0.513674, 0, 0.857985) },
    { name="Golden Rock", CFrame=CFrame.new(310.492, 7.791, -560.009, 0.989373, 0, -0.145400, 0, 1, 0, 0.145400, 0, 0.989373) },
    { name="Ancient Jungle Rock", CFrame=CFrame.new(-7691.660, 7.272, 2862.824, -0.432285, 0, -0.901737, 0, 1, 0, 0.901737, 0, -0.432285) },
}

glitchingTab:AddLabel("----------VeX Paid Rock V2----------")
local currentToggleIndex = nil
local cleanupFuncs = {}

for idx, rock in ipairs(rocksV2) do
    glitchingTab:AddSwitch("Auto Farm " .. rock.name, function(enabled)
        if enabled then
            -- Disable others
            for i, c in pairs(cleanupFuncs) do
                if c and i ~= idx then c() cleanupFuncs[i] = nil end
            end
            currentToggleIndex = idx

            -- Teleport & Lock
            local character = player.Character or player.CharacterAdded:Wait()
            character.HumanoidRootPart.CFrame = rock.CFrame
            task.wait(0.1)
            local cleanupLock = lockPosition()

            -- Start Fast Punch
            local stopSignal = function() return currentToggleIndex ~= idx end
            local cleanupPunch = startAutoFastPunch(stopSignal)

            cleanupFuncs[idx] = function()
                cleanupLock()
                cleanupPunch()
            end
        else
            if cleanupFuncs[idx] then
                cleanupFuncs[idx]()
                cleanupFuncs[idx] = nil
            end
            if currentToggleIndex == idx then
                currentToggleIndex = nil
            end
        end
    end)
end


---------------------------------
-- FARMING TAB
---------------------------------
local farmingTab = safe_call(window.AddTab, window, "Fast Strength") or window:AddTab("Fast Strength")
if farmingTab and farmingTab.Show then pcall(function() farmingTab:Show() end) end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-------------------------------
-- Strength Label (BIG)
-------------------------------
local strengthLabel = farmingTab:AddLabel("Strength: ...")
strengthLabel.TextSize = 20

-- Helper to format big numbers
local function formatNumber(n)
    local absN = math.abs(n)
    if absN >= 1e15 then
        return string.format("%.1fQ", n / 1e15) -- Quadrillion
    elseif absN >= 1e12 then
        return string.format("%.1fT", n / 1e12) -- Trillion
    elseif absN >= 1e9 then
        return string.format("%.1fB", n / 1e9) -- Billion
    elseif absN >= 1e6 then
        return string.format("%.1fM", n / 1e6) -- Million
    elseif absN >= 1e3 then
        return string.format("%.1fK", n / 1e3) -- Thousand
    else
        return tostring(n)
    end
end

-- Safe label setter
local function safeSetLabel(labelObj, text)
    pcall(function()
        if labelObj and labelObj.Text ~= nil then
            labelObj.Text = tostring(text)
        end
    end)
end

-- Connection reference
local strengthConn

-- Attach to leaderstat IntValue / NumberValue
local function attachToStrength(valObj)
    if strengthConn then
        pcall(function() strengthConn:Disconnect() end)
    end
    if not valObj then return end

    local function update()
        local val = valObj.Value or 0
        safeSetLabel(strengthLabel, ("Strength: %d | %s"):format(val, formatNumber(val)))
    end

    update()
    strengthConn = valObj.Changed:Connect(update)
end

-- Attach to player Attribute
local function attachToStrengthAttribute(attrName)
    if strengthConn then
        pcall(function() strengthConn:Disconnect() end)
    end
    if not player then return end

    local function update()
        local val = player:GetAttribute(attrName) or 0
        safeSetLabel(strengthLabel, ("Strength: %d | %s"):format(val, formatNumber(val)))
    end

    update()
    strengthConn = player:GetAttributeChangedSignal(attrName):Connect(update)
end

-- Scan for Strength value in leaderstats or attributes
local function scanAndAttachStrength()
    if not player then return false end

    -- Leaderstats
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            if string.find(string.lower(child.Name), "strength") and (child:IsA("IntValue") or child:IsA("NumberValue")) then
                attachToStrength(child)
                return true
            end
        end
    end

    -- Attributes
    for _, attr in ipairs({"Strength", "strength", "Muscle", "muscle"}) do
        if player:GetAttribute(attr) ~= nil then
            attachToStrengthAttribute(attr)
            return true
        end
    end

    return false
end

-- Keep scanning every second until Strength is found
task.spawn(function()
    while not scanAndAttachStrength() do
        task.wait(1)
    end
end)

-------------------------------
-- Rebirth Label (BIG)
-------------------------------
local rebirthLabel = safe_call(farmingTab.AddLabel, farmingTab, "Rebirths: ...") or farmingTab:AddLabel("Rebirths: ...")
pcall(function()
    if rebirthLabel and rebirthLabel.TextSize ~= nil then
        rebirthLabel.TextSize = 20
    end
end)


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

local function safeSetLabel(labelObj, text)
	pcall(function()
		if not labelObj then return end
		if type(labelObj) == "table" and labelObj.Set then
			labelObj:Set(tostring(text))
			return
		end
		if typeof(labelObj) == "Instance" and labelObj:IsA("TextLabel") then
			labelObj.Text = tostring(text)
			return
		end
		if labelObj and labelObj.Text ~= nil then
			labelObj.Text = tostring(text)
		end
	end)
end

-------------------------
-- Anti AFK (Floating GUI)
-------------------------
local antiAfkEnabled = false
local antiAfkGui, antiAfkLabel
local afkTime = 0

local function createAntiAfkGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AntiAFKGui"
    ScreenGui.Parent = game.CoreGui

    local Label = Instance.new("TextLabel")
    Label.Parent = ScreenGui
    Label.Size = UDim2.new(0, 220, 0, 40)
    Label.Position = UDim2.new(0.5, -110, 0.05, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "ANTI AFK [Timer: 0s]"
    Label.TextSize = 20
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.new(0, 1, 0) -- start green

    antiAfkGui, antiAfkLabel = ScreenGui, Label
end

local function removeAntiAfkGui()
    if antiAfkGui then
        antiAfkGui:Destroy()
        antiAfkGui, antiAfkLabel = nil, nil
    end
end

local function antiAfkLoop()
    afkTime = 0
    local toggle = true
    while antiAfkEnabled do
        afkTime += 1
        if antiAfkLabel then
            antiAfkLabel.Text = "ANTI AFK [Timer: " .. afkTime .. "s]"
            if toggle then
                antiAfkLabel.TextColor3 = Color3.new(0, 1, 0) -- green
            else
                antiAfkLabel.TextColor3 = Color3.new(1, 0, 0) -- red
            end
            toggle = not toggle
        end
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        task.wait(1)
    end
end

local AntiAFK = farmingTab:AddSwitch("Anti AFK", function(state)
    antiAfkEnabled = state
    if state then
        createAntiAfkGui()
        task.spawn(antiAfkLoop)
    else
        removeAntiAfkGui()
    end
end)

AntiAFK:Set(true)

local statsLabel = safe_call(farmingTab.AddLabel, farmingTab, "Ping: ... | Players: ...") or farmingTab:AddLabel("Ping: ... | Players: ...")

pcall(function()
    if statsLabel and statsLabel.TextSize ~= nil then
        statsLabel.TextSize = 20
    end
end)

-- Update Ping and Players every second
task.spawn(function()
    local Stats = game:GetService("Stats")
    local Players = game:GetService("Players")
    
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local currentPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers or 20 -- fallback if MaxPlayers is nil

        safeSetLabel(statsLabel, string.format("Ping: %d | Players: %d/%d", ping, currentPlayers, maxPlayers))
        task.wait(0.1)
    end
end)

-------------------------
-- Rep Speed + Fast Rep
-------------------------
farmingTab:AddButton("Anti Lag", function()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local lighting = game:GetService("Lighting")

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end

    local function darkenSky()
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end

        local darkSky = Instance.new("Sky")
        darkSky.Name = "DarkSky"
        darkSky.SkyboxBk = "rbxassetid://0"
        darkSky.SkyboxDn = "rbxassetid://0"
        darkSky.SkyboxFt = "rbxassetid://0"
        darkSky.SkyboxLf = "rbxassetid://0"
        darkSky.SkyboxRt = "rbxassetid://0"
        darkSky.SkyboxUp = "rbxassetid://0"
        darkSky.Parent = lighting

        lighting.Brightness = 0
        lighting.ClockTime = 0
        lighting.TimeOfDay = "00:00:00"
        lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        lighting.Ambient = Color3.new(0, 0, 0)
        lighting.FogColor = Color3.new(0, 0, 0)
        lighting.FogEnd = 100

        task.spawn(function()
            while true do
                wait(5)
                if not lighting:FindFirstChild("DarkSky") then
                    darkSky:Clone().Parent = lighting
                end
                lighting.Brightness = 0
                lighting.ClockTime = 0
                lighting.OutdoorAmbient = Color3.new(0, 0, 0)
                lighting.Ambient = Color3.new(0, 0, 0)
                lighting.FogColor = Color3.new(0, 0, 0)
                lighting.FogEnd = 100
            end
        end)
    end

    local function removeParticleEffects()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj:Destroy()
            end
        end
    end

    local function removeLightSources()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end
    end

    removeParticleEffects()
    removeLightSources()
    darkenSky()
end)
---------------------------------
-- Repping Speed + Fast Rep (Super Fast Updates + Instant Stop)
---------------------------------
farmingTab:AddLabel("Recommended 30 Rep Speed")
local repSpeedLabel = farmingTab:AddLabel("Rep Speed: 1 | Done: 0 | Rep Speed: OFF")
repSpeedLabel.TextSize = 20

local muscleEvent = ReplicatedStorage:FindFirstChild("muscleEvent") or player:FindFirstChild("muscleEvent")
local runFastRep = false
local repsPerTick = 1
local totalRepsDone = 0

-- Function to refresh the label text
local function updateRepLabel()
    local stateText = runFastRep and "ON" or "OFF"
    safeSetLabel(repSpeedLabel, "Rep Speed: " .. tostring(repsPerTick) .. " | Done: " .. tostring(totalRepsDone) .. " | Rep Speed: " .. stateText)
end

-- Textbox with live updating + reset done count
farmingTab:AddTextBox("Rep Speed", function(value)
    local n = tonumber(value:match("^%s*(.-)%s*$"))
    if n and n > 0 then
        repsPerTick = math.clamp(math.floor(n), 1, 10000)
    else
        repsPerTick = 1 -- fallback if invalid
    end
    totalRepsDone = 0 -- reset done counter whenever user changes speed
    updateRepLabel()
end)

-- Fast Rep loop (super fast updates, no delay on stop)
local function fastRepLoop()
	while runFastRep do
		local toDo = math.max(1, repsPerTick)
		local repsLeft = toDo
		while repsLeft > 0 and runFastRep do
			local batch = math.min(50, repsLeft)
			for i = 1, batch do
				if not runFastRep then break end -- instant stop check
				if not muscleEvent then
					muscleEvent = ReplicatedStorage:FindFirstChild("muscleEvent") or player:FindFirstChild("muscleEvent")
				end
				if muscleEvent then
					pcall(function() muscleEvent:FireServer("rep") end)
					totalRepsDone += 1
					updateRepLabel() -- update super fast
				end
			end
			repsLeft -= batch
			task.wait() -- tiny yield keeps UI responsive
		end
		task.wait(0.02) -- cooldown per tick
	end
end

-- Toggle Fast Rep
farmingTab:AddSwitch("Fast Rep", function(state)
	runFastRep = state and true or false
	updateRepLabel() -- update ON/OFF status instantly
	if runFastRep then
		task.spawn(fastRepLoop)
	end
end)

-------------------------
-- Rebirth Detection
-------------------------
local rebirthConn = nil
local function attachToValue(valObj)
	if rebirthConn then pcall(function() rebirthConn:Disconnect() end) end
	if not valObj then return end
	pcall(function() safeSetLabel(rebirthLabel, ("Rebirths: %s"):format(tostring(valObj.Value))) end)
	rebirthConn = valObj.Changed:Connect(function()
		pcall(function() safeSetLabel(rebirthLabel, ("Rebirths: %s"):format(tostring(valObj.Value))) end)
	end)
end

local function attachToAttribute(attrName)
	if rebirthConn then pcall(function() rebirthConn:Disconnect() end) end
	if not player then return end
	pcall(function() safeSetLabel(rebirthLabel, ("Rebirths: %s"):format(tostring(player:GetAttribute(attrName)))) end)
	rebirthConn = player:GetAttributeChangedSignal(attrName):Connect(function()
		pcall(function() safeSetLabel(rebirthLabel, ("Rebirths: %s"):format(tostring(player:GetAttribute(attrName)))) end)
	end)
end

local function scanAndAttach()
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		for _, child in ipairs(ls:GetChildren()) do
			if string.find(string.lower(child.Name), "rebirth") and (child:IsA("IntValue") or child:IsA("NumberValue") or child:IsA("StringValue")) then
				attachToValue(child)
				return true
			end
		end
	end
	for _, an in ipairs({"Rebirths","rebirths","rebirth"}) do
		if player:GetAttribute(an) ~= nil then
			attachToAttribute(an)
			return true
		end
	end
	return false
end

task.spawn(function()
	while not scanAndAttach() do
		task.wait(1)
	end
end)

-------------------------
-- Other Farming Features
-------------------------
farmingTab:AddSwitch("Fast Strength", function(Value)
    getgenv().isGrinding = Value
    if not Value then return end
    for _ = 1, 30 do
        task.spawn(function()
            while getgenv().isGrinding do
                player.muscleEvent:FireServer("rep")
                task.wait(0.01)
            end
        end)
    end
end)

farmingTab:AddSwitch("Ultimate Fast Strength", function(Value)
    getgenv().isGrinding = Value
    if not Value then return end
    for _ = 1, 3000 do
        task.spawn(function()
            while getgenv().isGrinding do
                player.muscleEvent:FireServer("rep")
                task.wait(0.01)
            end
        end)
    end
end)

farmingTab:AddSwitch("Hide Frames", function(bool)
    for _, frameName in ipairs({"strengthFrame", "durabilityFrame", "agilityFrame"}) do
        local frame = ReplicatedStorage:FindFirstChild(frameName)
        if frame and frame:IsA("GuiObject") then
            frame.Visible = not bool
        end
    end
end)

farmingTab:AddSwitch("Fast Rebirth", function(bool)
    isRunning = bool
    task.spawn(function()
        while isRunning do
            local currentRebirths = player.leaderstats.Rebirths.Value
            local rebirthCost = 10000 + (5000 * currentRebirths)
            ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            task.wait(0.5)
        end
    end)
end)


print("[Farming GUI] Loaded with Main Tab, Farming Tab (Rebirths big, Rep Speed + Fast Rep), and Anti AFK GUI with green/red timer.")

farmingTab:AddSwitch("Fast Rebirth", function(bool)
    isRunning = bool
    
    task.spawn(function()
        while isRunning do
            local currentRebirths = player.leaderstats.Rebirths.Value
            local rebirthCost = 10000 + (5000 * currentRebirths)
            
            if player.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                local goldenRebirths = player.ultimatesFolder["Golden Rebirth"].Value
                rebirthCost = math.floor(rebirthCost * (1 - (goldenRebirths * 0.1)))
            end
            unequipAllPets()
            task.wait(0.1)
            equipUniquePet("Swift Samurai")
            
            while isRunning and player.leaderstats.Strength.Value < rebirthCost do
                for i = 1, 10 do
                    player.muscleEvent:FireServer("rep")
                end
                task.wait()
            end
            unequipAllPets()
            task.wait(0.1)
            equipUniquePet("Tribal Overlord")
            local machine = findMachine("Jungle Bar Lift")
            if machine and machine:FindFirstChild("interactSeat") then
                player.Character.HumanoidRootPart.CFrame = machine.interactSeat.CFrame * CFrame.new(0, 3, 0)
                repeat
                    task.wait(0.1)
                    pressE()
                until player.Character.Humanoid.Sit
            end
            local initialRebirths = player.leaderstats.Rebirths.Value
            repeat
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1)
            until player.leaderstats.Rebirths.Value > initialRebirths
            if not isRunning then break end
            task.wait()
        end
    end)
end)

local rebirthTab = window:AddTab("Fast Rebirth")

-- Target rebirth input - direct text input
rebirthTab:AddTextBox("Rebirth Target", function(text)
    local newValue = tonumber(text)
    if newValue and newValue > 0 then
        targetRebirthValue = newValue
        updateStats() -- Call the stats update function
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Updated Objective",
            Text = "New goal: " .. tostring(targetRebirthValue) .. " rebirth",
            Duration = 0
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Invalid Entry",
            Text = "Please enter a valid number",
            Duration = 0
        })
    end
end)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager") -- Make sure this exists

-- Function to instantly eat an egg
local function eatEgg()
    local proteinEgg = player.Backpack:FindFirstChild("Protein Egg") or player.Character:FindFirstChild("Protein Egg")
    if proteinEgg then
        -- Equip the egg
        proteinEgg.Parent = player.Character
        task.wait(0.1)

        -- Simulate pressing the screen to eat it (5 clicks ~1 second)
        for i = 1, 5 do
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            task.wait(0.1)
        end
    end
end

farmingTab:AddLabel("Eat Egg | 30 Minutes | 1 Hour").TextSize = 20
-- Auto Eat 1 Egg Every 30 Minutes
farmingTab:AddSwitch("Auto Eat Egg | 30 Minutes", function(enabled)
    _G.AutoEgg30 = enabled
    if enabled then
        task.spawn(function()
            while _G.AutoEgg30 do
                eatEgg()
                task.wait(1800) -- 30 minutes
            end
        end)
    end
end)

-- Auto Eat 1 Egg Every 1 Hour
farmingTab:AddSwitch("Auto Eat Egg | 1 Hour", function(enabled)
    _G.AutoEgg60 = enabled
    if enabled then
        task.spawn(function()
            while _G.AutoEgg60 do
                eatEgg()
                task.wait(3600) -- 1 hour
            end
        end)
    end
end)


-- Create toggle switches
local infiniteSwitch -- Forward declaration

local targetSwitch = rebirthTab:AddSwitch("Auto Rebirth Target", function(bool)
    _G.targetRebirthActive = bool
    
    if bool then
        -- Turn off infinite rebirth if it's on
        if _G.infiniteRebirthActive and infiniteSwitch then
            infiniteSwitch:Set(false)
            _G.infiniteRebirthActive = false
        end
        
        -- Start target rebirth loop
        spawn(function()
            while _G.targetRebirthActive and wait(0.1) do
                local currentRebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value
                
                if currentRebirths >= targetRebirthValue then
                    targetSwitch:Set(false)
                    _G.targetRebirthActive = false
                    
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Goal Achieved!!",
                        Text = "You have reached " .. tostring(targetRebirthValue) .. " rebirth",
                        Duration = 5
                    })
                    
                    break
                end
                
                game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end
        end)
    end
end, "Automatic rebirth until the goal is reached")

-- Fast Weight toggle with auto-weight functionality and persistent equipping
rebirthTab:AddSwitch("Auto Weight", function(bool)
    _G.FastWeight = bool
    
    if bool then
        -- Continuously equip and modify weight tool
        spawn(function()
            while _G.FastWeight do
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                -- Check if tool is not equipped
                if character and not character:FindFirstChild("Weight") then
                    local weightTool = player.Backpack:FindFirstChild("Weight")
                    if weightTool then
                        if weightTool:FindFirstChild("repTime") then
                            weightTool.repTime.Value = 0
                        end
                        character.Humanoid:EquipTool(weightTool)
                    end
                elseif character and character:FindFirstChild("Weight") then
                    -- Make sure equipped tool is modified
                    local equipped = character:FindFirstChild("Weight")
                    if equipped:FindFirstChild("repTime") then
                        equipped.repTime.Value = 0
                    end
                end
                
                wait(0.1)
            end
        end)
        
        -- Auto do weight lifting
        spawn(function()
            while _G.FastWeight do
                game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
                task.wait(0)
            end
        end)
    else
        -- Unequip and reset tool
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Weight")
        if equipped then
            if equipped:FindFirstChild("repTime") then
                equipped.repTime.Value = 1
            end
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
        
        -- Also reset the backpack tool
        local backpackTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
        if backpackTool and backpackTool:FindFirstChild("repTime") then
            backpackTool.repTime.Value = 1
        end
    end
end)

local sizeSwitch = rebirthTab:AddSwitch("Auto Size 1", function(bool)
    _G.autoSizeActive = bool
    
    if bool then
        spawn(function()
            while _G.autoSizeActive and wait() do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 0)
            end
        end)
    end
end, "Auto Set Size 1")


local teleportSwitch = rebirthTab:AddSwitch("Auto Teleport to Muscle King", function(bool)
    _G.teleportActive = bool
    
    if bool then
        spawn(function()
            while _G.teleportActive and wait() do
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-8646, 17, -5738))
                end
            end
        end)
    end
end, "Continuous teleportation to Muscle King")

rebirthTab:AddLabel("---VeX OP Stuffs---")

local function unequipAllPets()
    local petsFolder = player.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.1)
end

local function equipUniquePet(petName)
    unequipAllPets()
    task.wait(0.01)
    for _, pet in pairs(player.petsFolder.Unique:GetChildren()) do
        if pet.Name == petName then
            ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
        end
    end
end

local function findMachine(machineName)
    local machine = workspace.machinesFolder:FindFirstChild(machineName)
    if not machine then
        for _, folder in pairs(workspace:GetChildren()) do
            if folder:IsA("Folder") and folder.Name:find("machines") then
                machine = folder:FindFirstChild(machineName)
                if machine then break end
            end
        end
    end
    return machine
end

local function pressE()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    vim:SendKeyEvent(false, "E", false, game)
end

local function useOneEgg()
    ReplicatedStorage.rEvents.proteinEggEvent:FireServer("useEgg")
end

local packFarm = rebirthTab:AddSwitch("Fast Rebirth", function(bool)
    isRunning = bool
    
    task.spawn(function()
        while isRunning do
            local currentRebirths = player.leaderstats.Rebirths.Value
            local rebirthCost = 10000 + (5000 * currentRebirths)
            
            if player.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                local goldenRebirths = player.ultimatesFolder["Golden Rebirth"].Value
                rebirthCost = math.floor(rebirthCost * (1 - (goldenRebirths * 0.1)))
            end
            unequipAllPets()
            task.wait(0.1)
            equipUniquePet("Swift Samurai")
            
            while isRunning and player.leaderstats.Strength.Value < rebirthCost do
                for i = 1, 100 do
                    player.muscleEvent:FireServer("rep")
                end
                task.wait()
            end
            unequipAllPets()
            task.wait(0.1)
            equipUniquePet("Tribal Overlord")
            local machine = findMachine("Jungle Bar Lift")
            if machine and machine:FindFirstChild("interactSeat") then
                player.Character.HumanoidRootPart.CFrame = machine.interactSeat.CFrame * CFrame.new(0, 3, 0)
                repeat
                    task.wait(0.1)
                    pressE()
                until player.Character.Humanoid.Sit
            end
            local initialRebirths = player.leaderstats.Rebirths.Value
            repeat
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1)
            until player.leaderstats.Rebirths.Value > initialRebirths
            if not isRunning then break end
            task.wait()
        end
    end)
end)

local speedGrind = rebirthTab:AddSwitch("Fast Strength", function(bool)
    local isGrinding = bool
    
    if not bool then
        unequipAllPets()
        return
    end
    
    equipUniquePet("Swift Samurai")
    
    for i = 1, 100 do
        task.spawn(function()
            while isGrinding do
                player.muscleEvent:FireServer("rep")
                task.wait()
            end
        end)
    end
end)

local frameToggle = rebirthTab:AddSwitch("Hide Frames", function(bool)
    local rSto = game:GetService("ReplicatedStorage")
    for _, obj in pairs(rSto:GetChildren()) do
        if obj.Name:match("Frame$") then
            obj.Visible = not bool
        end
    end
end)

rebirthTab:AddSwitch("Hide Pets", function(State)
    if State then
        game:GetService("ReplicatedStorage").rEvents.showPetsEvent:FireServer("hidePets")
    else
        game:GetService("ReplicatedStorage").rEvents.showPetsEvent:FireServer("showPets")
    end
end)

local farmPlusTab = window:AddTab("Farming")

farmPlusTab:AddButton("Unlock Lift Gamepass", function()
    local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
    local player = game:GetService("Players").LocalPlayer
    for _, gamepass in pairs(gamepassFolder:GetChildren()) do
        local value = Instance.new("IntValue")
        value.Name = gamepass.Name
        value.Value = gamepass.Value
        value.Parent = player.ownedGamepasses
    end
end, "Unlock the AutoLift Game Pass for free")
local autoEquipToolsFolder = farmPlusTab:AddFolder("Tools+")

-- Auto Weight Toggle
autoEquipToolsFolder:AddSwitch("Auto Weight", function(Value)
    _G.AutoWeight = Value
    
    if Value then
        local weightTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
        if weightTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(weightTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Weight")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoWeight do
            if not _G.AutoWeight then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Do lifting automatically")

-- Auto Pushups Toggle
autoEquipToolsFolder:AddSwitch("Auto Pushups", function(Value)
    _G.AutoPushups = Value
    
    if Value then
        local pushupsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Pushups")
        if pushupsTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(pushupsTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Pushups")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoPushups do
            if not _G.AutoPushups then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Do push-ups automatically")

-- Auto Handstands Toggle
autoEquipToolsFolder:AddSwitch("Auto Handstands", function(Value)
    _G.AutoHandstands = Value
    
    if Value then
        local handstandsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Handstands")
        if handstandsTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(handstandsTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Handstands")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoHandstands do
            if not _G.AutoHandstands then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Do hand-stands automatically")

-- Auto Situps Toggle
autoEquipToolsFolder:AddSwitch("Auto Situps", function(Value)
    _G.AutoSitups = Value
    
    if Value then
        local situpsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Situps")
        if situpsTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(situpsTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Situps")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoSitups do
            if not _G.AutoSitups then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Do sit-ups automatically")

-- Auto Punch Toggle
autoEquipToolsFolder:AddSwitch("Auto Punch", function(Value)
    _G.fastHitActive = Value
    
    if Value then
        -- Function to equip and modify punch
        task.spawn(function()
            while _G.fastHitActive do
                if not _G.fastHitActive then break end
                
                local player = game.Players.LocalPlayer
                local punch = player.Backpack:FindFirstChild("Punch")
                if punch then
                    punch.Parent = player.Character
                    if punch:FindFirstChild("attackTime") then
                        punch.attackTime.Value = 0
                    end
                end
                task.wait(0.1)
            end
        end)
        
        -- Function for rapid punching
        task.spawn(function()
            while _G.fastHitActive do
                if not _G.fastHitActive then break end
                
                local player = game.Players.LocalPlayer
                player.muscleEvent:FireServer("punch", "rightHand")
                player.muscleEvent:FireServer("punch", "leftHand")
                
                local character = player.Character
                if character then
                    local punchTool = character:FindFirstChild("Punch")
                    if punchTool then
                        punchTool:Activate()
                    end
                end
                task.wait(0)
            end
        end)
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
end, "Hits automatically")

-- Fast Tools Toggle
autoEquipToolsFolder:AddSwitch("Fast Tools", function(Value)
    _G.FastTools = Value
    
    local defaultSpeeds = {
        {
            "Punch",
            "attackTime",
            Value and 0 or 0.35
        },
        {
            "Ground Slam",
            "attackTime",
            Value and 0 or 6
        },
        {
            "Stomp",
            "attackTime",
            Value and 0 or 7
        },
        {
            "Handstands",
            "repTime",
            Value and 0 or 1
        },
        {
            "Pushups",
            "repTime",
            Value and 0 or 1
        },
        {
            "Weight",
            "repTime",
            Value and 0 or 1
        },
        {
            "Situps",
            "repTime",
            Value and 0 or 1
        }
    }
    
    local player = game.Players.LocalPlayer
    local backpack = player:WaitForChild("Backpack")
    
    for _, toolInfo in ipairs(defaultSpeeds) do
        local tool = backpack:FindFirstChild(toolInfo[1])
        if tool and tool:FindFirstChild(toolInfo[2]) then
            tool[toolInfo[2]].Value = toolInfo[3]
        end
        
        local equippedTool = player.Character and player.Character:FindFirstChild(toolInfo[1])
        if equippedTool and equippedTool:FindFirstChild(toolInfo[2]) then
            equippedTool[toolInfo[2]].Value = toolInfo[3]
        end
    end
end, "Accelerates all tools")

-- Inicializar variables de seguimiento
local sessionStartTime = os.time()
local sessionStartStrength = 0
local sessionStartDurability = 0
local sessionStartKills = 0
local sessionStartRebirths = 0
local sessionStartBrawls = 0
local hasStartedTracking = false

local jungleGymFolder = farmPlusTab:AddFolder("Jungle Workouts")

-- Cache services for faster access
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Helper functions for Jungle Gym
local function pressE()
    VIM:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, "E", false, game)
end

local function autoLift()
    while getgenv().working do
        LocalPlayer.muscleEvent:FireServer("rep")
        task.wait() -- More efficient than task.wait(0) or task.wait(small number)
    end
end

local function teleportAndStart(machineName, position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = position
        task.wait(0.1)
        pressE()
        task.spawn(autoLift) -- Use task.spawn to prevent UI freezing
    end
end

-- Jungle Gym Bench Press
jungleGymFolder:AddSwitch("Jungle Bench Press", function(bool)
    if getgenv().working and not bool then
        getgenv().working = false
        return
    end
    
    getgenv().working = bool
    if bool then
        teleportAndStart("Bench Press", CFrame.new(-8173, 64, 1898))
    end
end)

-- Jungle Gym Squat
jungleGymFolder:AddSwitch("Jungle Squat", function(bool)
    if getgenv().working and not bool then
        getgenv().working = false
        return
    end
    
    getgenv().working = bool
    if bool then
        teleportAndStart("Squat", CFrame.new(-8352, 34, 2878))
    end
end)

-- Jungle Gym Pull Up
jungleGymFolder:AddSwitch("Jungle Pull Ups", function(bool)
    if getgenv().working and not bool then
        getgenv().working = false
        return
    end
    
    getgenv().working = bool
    if bool then
        teleportAndStart("Pull Up", CFrame.new(-8666, 34, 2070))
    end
end)

-- Jungle Gym Boulder
jungleGymFolder:AddSwitch("Jungle Boulder", function(bool)
    if getgenv().working and not bool then
        getgenv().working = false
        return
    end
    
    getgenv().working = bool
    if bool then
        teleportAndStart("Boulder", CFrame.new(-8621, 34, 2684))
    end
end)

-- NEW: Farm Gyms Folder
local farmGymsFolder = farmPlusTab:AddFolder("Gym DropDowns")

-- Workout positions data
local workoutPositions = {
    ["Bench Press"] = {
        ["Eternal Gym"] = CFrame.new(-7176.19141, 45.394104, -1106.31421),
        ["Legend Gym"] = CFrame.new(4111.91748, 1020.46674, -3799.97217),
        ["Muscle King Gym"] = CFrame.new(-8590.06152, 46.0167427, -6043.34717)
    },
    ["Squat"] = {
        ["Eternal Gym"] = CFrame.new(-7176.19141, 45.394104, -1106.31421),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477)
    },
    ["Deadlift"] = {
        ["Eternal Gym"] = CFrame.new(-7176.19141, 45.394104, -1106.31421),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477)
    },
    ["Pull Up"] = {
        ["Eternal Gym"] = CFrame.new(-7176.19141, 45.394104, -1106.31421),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477)
    }
}

-- Workout types
local workoutTypes = {
    "Bench Press",
    "Squat",
    "Deadlift",
    "Pull Up"
}

-- Gym locations (only the three requested)
local gymLocations = {
    "Eternal Gym",
    "Legend Gym",
    "Muscle King Gym"
}

-- Spanish translations for workout types
local workoutTranslations = {
    ["Bench Press"] = "Bench Press",
    ["Squat"] = "Squat",
    ["Deadlift"] = "Dead Lift",
    ["Pull Up"] = "Pull Up"
}

-- Store references to toggle objects
local gymToggles = {}

-- Create dropdowns and toggles for each workout type
for _, workoutType in ipairs(workoutTypes) do
    -- Create dropdown for gym selection
    local dropdownName = workoutType .. "GymDropdown"
    local spanishWorkoutName = workoutTranslations[workoutType]
    
    -- Create the dropdown with the correct format
    local dropdown = farmGymsFolder:AddDropdown(spanishWorkoutName .. " - Gym", function(selected)
        _G["selected" .. string.gsub(workoutType, " ", "") .. "Gym"] = selected
    end)
    
    -- Add gym locations to the dropdown
    for _, gymName in ipairs(gymLocations) do
        dropdown:Add(gymName)
    end
    
    -- Create toggle for workout
    local toggleName = workoutType .. "GymToggle"
    local toggle = farmGymsFolder:AddSwitch(spanishWorkoutName, function(bool)
        getgenv().workingGym = bool
        getgenv().currentWorkoutType = workoutType
        
        if bool then
            local selectedGym = _G["selected" .. string.gsub(workoutType, " ", "") .. "Gym"] or gymLocations[1]
            
            -- Make sure we have a valid position
            if workoutPositions[workoutType] and workoutPositions[workoutType][selectedGym] then
                -- Stop any other workout that might be running
                for otherType, otherToggle in pairs(gymToggles) do
                    if otherType ~= workoutType and otherToggle then
                        otherToggle:Set(false)
                    end
                end
                
                -- Start the workout
                teleportAndStart(workoutType, workoutPositions[workoutType][selectedGym])
            else
                -- Notify user if position is not found
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Error",
                    Text = "Position not found for " .. workoutType .. " in " .. selectedGym,
                    Duration = 5
                })
            end
        end
    end)
    
    -- Store reference to toggle
    gymToggles[workoutType] = toggle
end

 local miscTab = window:AddTab("Miscellaneous")

local misc1Folder = miscTab:AddFolder("Miscellaneous 1")

-- Fast Punch toggle with auto-punch functionality and persistent equipping
misc1Folder:AddSwitch("Auto Punch", function(bool)
    _G.FastPunch = bool
    
    if bool then
        -- Function to continuously equip and modify punch
        spawn(function()
            while _G.FastPunch do
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                -- Check if tool is not equipped
                if character and not character:FindFirstChild("Punch") then
                    local punch = player.Backpack:FindFirstChild("Punch")
                    if punch then
                        if punch:FindFirstChild("attackTime") then
                            punch.attackTime.Value = 0
                        end
                        character.Humanoid:EquipTool(punch)
                    end
                elseif character and character:FindFirstChild("Punch") then
                    -- Make sure equipped tool is modified
                    local equipped = character:FindFirstChild("Punch")
                    if equipped:FindFirstChild("attackTime") then
                        equipped.attackTime.Value = 0
                    end
                end
                
                wait(0.1)
            end
        end)
        
        -- Function to rapidly punch
        spawn(function()
            while _G.FastPunch do
                local player = game.Players.LocalPlayer
                player.muscleEvent:FireServer("punch", "rightHand")
                player.muscleEvent:FireServer("punch", "leftHand")
                local character = player.Character
                if character then
                    local punchTool = character:FindFirstChild("Punch")
                    if punchTool then
                        punchTool:Activate()
                    end
                end
                wait(0)
            end
        end)
    else
        -- Unequip and reset tool
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Punch")
        if equipped then
            if equipped:FindFirstChild("attackTime") then
                equipped.attackTime.Value = 0.35
            end
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
        
        -- Also reset the backpack tool
        local backpackTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")
        if backpackTool and backpackTool:FindFirstChild("attackTime") then
            backpackTool.attackTime.Value = 0.35
        end
    end
end)

-- Fast Weight toggle with auto-weight functionality and persistent equipping
misc1Folder:AddSwitch("Auto Weight", function(bool)
    _G.FastWeight = bool
    
    if bool then
        -- Continuously equip and modify weight tool
        spawn(function()
            while _G.FastWeight do
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                -- Check if tool is not equipped
                if character and not character:FindFirstChild("Weight") then
                    local weightTool = player.Backpack:FindFirstChild("Weight")
                    if weightTool then
                        if weightTool:FindFirstChild("repTime") then
                            weightTool.repTime.Value = 0
                        end
                        character.Humanoid:EquipTool(weightTool)
                    end
                elseif character and character:FindFirstChild("Weight") then
                    -- Make sure equipped tool is modified
                    local equipped = character:FindFirstChild("Weight")
                    if equipped:FindFirstChild("repTime") then
                        equipped.repTime.Value = 0
                    end
                end
                
                wait(0.1)
            end
        end)
        
        -- Auto do weight lifting
        spawn(function()
            while _G.FastWeight do
                game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
                task.wait(0)
            end
        end)
    else
        -- Unequip and reset tool
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Weight")
        if equipped then
            if equipped:FindFirstChild("repTime") then
                equipped.repTime.Value = 1
            end
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
        
        -- Also reset the backpack tool
        local backpackTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
        if backpackTool and backpackTool:FindFirstChild("repTime") then
            backpackTool.repTime.Value = 1
        end
    end
end)

-- Fast Pushups toggle with auto-pushups functionality and persistent equipping
misc1Folder:AddSwitch("Auto Pushups", function(bool)
    _G.FastPushups = bool
    
    if bool then
        -- Continuously equip and modify pushups tool
        spawn(function()
            while _G.FastPushups do
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                -- Check if tool is not equipped
                if character and not character:FindFirstChild("Pushups") then
                    local pushupsTool = player.Backpack:FindFirstChild("Pushups")
                    if pushupsTool then
                        if pushupsTool:FindFirstChild("repTime") then
                            pushupsTool.repTime.Value = 0
                        end
                        character.Humanoid:EquipTool(pushupsTool)
                    end
                elseif character and character:FindFirstChild("Pushups") then
                    -- Make sure equipped tool is modified
                    local equipped = character:FindFirstChild("Pushups")
                    if equipped:FindFirstChild("repTime") then
                        equipped.repTime.Value = 0
                    end
                end
                
                wait(0.1)
            end
        end)
        
        -- Auto do pushups
        spawn(function()
            while _G.FastPushups do
                game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
                task.wait(0)
            end
        end)
    else
        -- Unequip and reset tool
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Pushups")
        if equipped then
            if equipped:FindFirstChild("repTime") then
                equipped.repTime.Value = 1
            end
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
        
        -- Also reset the backpack tool
        local backpackTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Pushups")
        if backpackTool and backpackTool:FindFirstChild("repTime") then
            backpackTool.repTime.Value = 1
        end
    end
end)

-- Fast Handstands toggle with auto-handstands functionality and persistent equipping
misc1Folder:AddSwitch("Auto Handstands", function(bool)
    _G.FastHandstands = bool
    
    if bool then
        -- Continuously equip and modify handstands tool
        spawn(function()
            while _G.FastHandstands do
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                -- Check if tool is not equipped
                if character and not character:FindFirstChild("Handstands") then
                    local handstandsTool = player.Backpack:FindFirstChild("Handstands")
                    if handstandsTool then
                        if handstandsTool:FindFirstChild("repTime") then
                            handstandsTool.repTime.Value = 0
                        end
                        character.Humanoid:EquipTool(handstandsTool)
                    end
                elseif character and character:FindFirstChild("Handstands") then
                    -- Make sure equipped tool is modified
                    local equipped = character:FindFirstChild("Handstands")
                    if equipped:FindFirstChild("repTime") then
                        equipped.repTime.Value = 0
                    end
                end
                
                wait(0.1)
            end
        end)
        
        -- Auto do handstands
        spawn(function()
            while _G.FastHandstands do
                game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
                task.wait(0)
            end
        end)
    else
        -- Unequip and reset tool
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Handstands")
        if equipped then
            if equipped:FindFirstChild("repTime") then
                equipped.repTime.Value = 1
            end
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
        
        -- Also reset the backpack tool
        local backpackTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Handstands")
        if backpackTool and backpackTool:FindFirstChild("repTime") then
            backpackTool.repTime.Value = 1
        end
    end
end)

-- Create the first folder
local misc2Folder = miscTab:AddFolder("Miscellaneous 2")

-- Add Auto Spin Wheel toggle
misc2Folder:AddSwitch("Auto Spin Wheel", function(bool)
    _G.AutoSpinWheel = bool
    
    if bool then
        spawn(function()
            while _G.AutoSpinWheel and wait(1) do
                game:GetService("ReplicatedStorage").rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", game:GetService("ReplicatedStorage").fortuneWheelChances["Fortune Wheel"])
            end
        end)
    end
end)

-- Add Auto Claim Gifts toggle
misc2Folder:AddSwitch("Auto Claim Gifts", function(bool)
    _G.AutoClaimGifts = bool
    
    if bool then
        spawn(function()
            while _G.AutoClaimGifts and wait(1) do
                for i = 1, 8 do
                    game:GetService("ReplicatedStorage").rEvents.freeGiftClaimRemote:InvokeServer("claimGift", i)
                end
            end
        end)
    end
end)

-- Add position lock toggle
misc2Folder:AddSwitch("Lock Position", function(bool)
    if bool then
        -- Get current position and lock it
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPosition = player.Character.HumanoidRootPart.CFrame
            lockPlayerPosition(currentPosition)
        end
    else
        -- Unlock position
        unlockPlayerPosition()
    end
end)

local frameToggle = misc2Folder:AddSwitch("Hide Frames", function(bool)
    local rSto = game:GetService("ReplicatedStorage")
    for _, obj in pairs(rSto:GetChildren()) do
        if obj.Name:match("Frame$") then
            obj.Visible = not bool
        end
    end
end)

-- Auto Eat Eggs Feature
local player = game.Players.LocalPlayer

misc2Folder:AddSwitch("Hide Pets", function(State)
    if State then
        game:GetService("ReplicatedStorage").rEvents.showPetsEvent:FireServer("hidePets")
    else
        game:GetService("ReplicatedStorage").rEvents.showPetsEvent:FireServer("showPets")
    end
end)


misc2Folder:AddSwitch("Unable Trade", function(State)
    if State then
        game:GetService("ReplicatedStorage").rEvents.tradingEvent:FireServer("disableTrading")
    else
        game:GetService("ReplicatedStorage").rEvents.tradingEvent:FireServer("enableTrading")
    end
end)

-- Protein Items Definitions
local proteinItems = {
    {"toughBar", "TOUGH Bar"},
    {"proteinBar", "Protein Bar"},
    {"energyBar", "Energy Bar"},
    {"proteinShake", "Protein Shake"},
    {"ultraShake", "ULTRA Shake"}, -- <-- Changed here
    {"energyShake", "Energy Shake"}
}
local proteinEgg = {"proteinEgg", "Protein Egg"}

-- Auto Eat Proteins Toggle
local autoEatProteins = false
local autoEatProteinsConn
misc2Folder:AddSwitch("Auto Eat Proteins", function(enabled)
    autoEatProteins = enabled
    if autoEatProteinsConn then autoEatProteinsConn:Disconnect() autoEatProteinsConn = nil end
    if enabled then
        autoEatProteinsConn = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            local ev = player:FindFirstChild("muscleEvent")
            if not char or not ev then return end
            for _, pair in ipairs(proteinItems) do
                local id, displayName = pair[1], pair[2]
                for _, item in ipairs(player.Backpack:GetChildren()) do
                    if item.Name == displayName then
                        item.Parent = char
                        ev:FireServer(id, item)
                    end
                end
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") and item.Name == displayName then
                        ev:FireServer(id, item)
                    end
                end
            end
        end)
    end
end, "Automatically eat all protein items repeatedly")

-- Auto Eat Protein Egg Toggle
local autoEatEgg = false
local autoEatEggConn
misc2Folder:AddSwitch("Auto Eat Protein Egg", function(enabled)
    autoEatEgg = enabled
    if autoEatEggConn then autoEatEggConn:Disconnect() autoEatEggConn = nil end
    if enabled then
        autoEatEggConn = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            local ev = player:FindFirstChild("muscleEvent")
            if not char or not ev then return end
            local id, displayName = proteinEgg[1], proteinEgg[2]
            for _, item in ipairs(player.Backpack:GetChildren()) do
                if item.Name == displayName then
                    item.Parent = char
                    ev:FireServer(id, item)
                end
            end
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") and item.Name == displayName then
                    ev:FireServer(id, item)
                end
            end
        end)
    end
end, "Automatically eat Protein Egg repeatedly")

-- Create the first folder
local misc3Folder = miscTab:AddFolder("Miscellaneous 3")

local godModeToggle = false
misc3Folder:AddSwitch("God Mode (Brawl)", function(State)
    godModeToggle = State
    if State then
        task.spawn(function()
            while godModeToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(0)
            end
        end)
    end
end)

local autoJoinToggle = false
misc3Folder:AddSwitch("Auto Join Brawl", function(State)
    autoJoinToggle = State
    if State then
        task.spawn(function()
            while autoJoinToggle do
                game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
                task.wait(2)
            end
        end)
    end
end)

-- Walk on Water feature
local parts = {}
local partSize = 2048
local totalDistance = 50000
local startPosition = Vector3.new(-2, -9.5, -2)
local numberOfParts = math.ceil(totalDistance / partSize)

local function createParts()
    for x = 0, numberOfParts - 1 do
        for z = 0, numberOfParts - 1 do
            local newPartSide = Instance.new("Part")
            newPartSide.Size = Vector3.new(partSize, 1, partSize)
            newPartSide.Position = startPosition + Vector3.new(x * partSize, 0, z * partSize)
            newPartSide.Anchored = true
            newPartSide.Transparency = 1
            newPartSide.CanCollide = true
            newPartSide.Name = "Part_Side_" .. x .. "_" .. z
            newPartSide.Parent = workspace
            table.insert(parts, newPartSide)
            
            local newPartLeftRight = Instance.new("Part")
            newPartLeftRight.Size = Vector3.new(partSize, 1, partSize)
            newPartLeftRight.Position = startPosition + Vector3.new(-x * partSize, 0, z * partSize)
            newPartLeftRight.Anchored = true
            newPartLeftRight.Transparency = 1
            newPartLeftRight.CanCollide = true
            newPartLeftRight.Name = "Part_LeftRight_" .. x .. "_" .. z
            newPartLeftRight.Parent = workspace
            table.insert(parts, newPartLeftRight)
            
            local newPartUpLeft = Instance.new("Part")
            newPartUpLeft.Size = Vector3.new(partSize, 1, partSize)
            newPartUpLeft.Position = startPosition + Vector3.new(-x * partSize, 0, -z * partSize)
            newPartUpLeft.Anchored = true
            newPartUpLeft.Transparency = 1
            newPartUpLeft.CanCollide = true
            newPartUpLeft.Name = "Part_UpLeft_" .. x .. "_" .. z
            newPartUpLeft.Parent = workspace
            table.insert(parts, newPartUpLeft)
            
            local newPartUpRight = Instance.new("Part")
            newPartUpRight.Size = Vector3.new(partSize, 1, partSize)
            newPartUpRight.Position = startPosition + Vector3.new(x * partSize, 0, -z * partSize)
            newPartUpRight.Anchored = true
            newPartUpRight.Transparency = 1
            newPartUpRight.CanCollide = true
            newPartUpRight.Name = "Part_UpRight_" .. x .. "_" .. z
            newPartUpRight.Parent = workspace
            table.insert(parts, newPartUpRight)
        end
    end
end

local function makePartsWalkthrough()
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = false
        end
    end
end

local function makePartsSolid()
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
end

-- Add Walk on Water toggle
misc3Folder:AddSwitch("Walk on Water", function(bool)
    if bool then
        createParts()
    else
        makePartsWalkthrough()
    end
end)

-- Add No-Clip toggle
misc3Folder:AddSwitch("No-Clip", function(bool)
    _G.NoClip = bool
    
    if bool then
        local noclipLoop
        noclipLoop = game:GetService("RunService").Stepped:Connect(function()
            if _G.NoClip then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            else
                noclipLoop:Disconnect()
            end
        end)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "No-Clip",
            Text = "Tatagos ka ba",
            Duration = 0
        })
    end
end)

-- Add Infinite Jump toggle
misc3Folder:AddSwitch("Jumpy Infinite", function(bool)
    _G.InfiniteJump = bool
    
    if bool then
        local InfiniteJumpConnection
        InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfiniteJump then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            else
                InfiniteJumpConnection:Disconnect()
            end
        end)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "High na High",
            Text = "Sumakses ka eh",
            Duration = 0
        })
    end
end)

local timeDropdown = misc3Folder:AddDropdown("Change Time", function(selection)
    local lighting = game:GetService("Lighting")
    
    if selection == "Night" then
        lighting.ClockTime = 0
    elseif selection == "Day" then
        lighting.ClockTime = 12
    elseif selection == "Midnight" then
        lighting.ClockTime = 6
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Hora Cambiada",
        Text = "La hora del día ha sido cambiada a: " .. selection,
        Duration = 0
    })
end)

-- Add time options
timeDropdown:Add("Night")
timeDropdown:Add("Day")
timeDropdown:Add("Midnight")

local ProteinFolder = miscTab:AddFolder("Auto Proteins")

ProteinFolder:AddButton("Eat All Proteins", function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local ev = player:FindFirstChild("muscleEvent")
    if not char or not ev then return end
    for _, pair in ipairs(proteinItems) do
        local id, displayName = pair[1], pair[2]
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if item.Name == displayName then
                item.Parent = char
                ev:FireServer(id, item)
            end
        end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name == displayName then
                ev:FireServer(id, item)
            end
        end
    end
end, "Eat all protein items in your backpack/character once")

-- Individual Eat Buttons for each Protein
for _, pair in ipairs(proteinItems) do
    local id, displayName = pair[1], pair[2]
    ProteinFolder:AddButton("Eat " .. displayName, function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local ev = player:FindFirstChild("muscleEvent")
        if not char or not ev then return end
        local item = player.Backpack:FindFirstChild(displayName) or (char and char:FindFirstChild(displayName))
        if item then
            item.Parent = char
            ev:FireServer(id, item)
        end
    end, "Eat one " .. displayName)
end

-- Single Eat Button for Protein Egg
ProteinFolder:AddButton("Eat Protein Egg", function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local ev = player:FindFirstChild("muscleEvent")
    if not char or not ev then return end
    local id, displayName = proteinEgg[1], proteinEgg[2]
    local item = player.Backpack:FindFirstChild(displayName) or (char and char:FindFirstChild(displayName))
    if item then
        item.Parent = char
        ev:FireServer(id, item)
    end
end, "Eat one Protein Egg")

local viewStatsTab = window:AddTab("Specs")
viewStatsTab:Show()

-- Abbreviate numbers function
local function abbreviateNumber(value)
    if value >= 1e15 then
        return string.format("%.2fQa", value / 1e15) -- Quadrillion
    elseif value >= 1e12 then
        return string.format("%.2fT", value / 1e12)  -- Trillion
    elseif value >= 1e9 then
        return string.format("%.2fB", value / 1e9)   -- Billion
    elseif value >= 1e6 then
        return string.format("%.2fM", value / 1e6)   -- Million
    elseif value >= 1e3 then
        return string.format("%.2fK", value / 1e3)   -- Thousand
    else
        return tostring(value)
    end
end

-- Wrapper to add labels with emoji-friendly font
local function AddEmojiLabel(tab, text)
    local lbl = tab:AddLabel(text)
    lbl.Font = Enum.Font.Cartoon -- Font supports most emojis
    return lbl
end

-- Variables
local targetPlayer = nil
local initialStats = {}

-- Dropdown for selecting player by DisplayName
local dropdown = viewStatsTab:AddDropdown("Select Player", function(displayName)
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.DisplayName == displayName then
            targetPlayer = p
            storeInitialStats()
            return
        end
    end
    targetPlayer = nil
    resetTargetStats()
end)

-- Populate dropdown with display names
for _, p in ipairs(game.Players:GetPlayers()) do
    dropdown:Add(p.DisplayName)
end

-- Update dropdown when players join
game.Players.PlayerAdded:Connect(function(player)
    dropdown:Add(player.DisplayName)
end)

-- Reset stats when players leave
game.Players.PlayerRemoving:Connect(function(player)
    resetTargetStats()
end)

-- Labels
local labels = {
    ViewStats = AddEmojiLabel(viewStatsTab, "View Stats:"),
    StrengthLabel = AddEmojiLabel(viewStatsTab, "Strength💪: 0"),
    DurabilityLabel = AddEmojiLabel(viewStatsTab, "Durability🛡️: 0"),
    AgilityLabel = AddEmojiLabel(viewStatsTab, "Agility⚡: 0"),
    RebirthsLabel = AddEmojiLabel(viewStatsTab, "Rebirths♻️: 0"),
    KillsLabel = AddEmojiLabel(viewStatsTab, "Kills☠️: 0"),
    EvilKarmaLabel = AddEmojiLabel(viewStatsTab, "Evil Karma😈: 0"),
    GoodKarmaLabel = AddEmojiLabel(viewStatsTab, "Good Karma😇: 0"),
    StatsGainedLabel = AddEmojiLabel(viewStatsTab, "Stats Gained In Server:"),
    StrengthGainedLabel = AddEmojiLabel(viewStatsTab, "Strength💪: 0"),
    DurabilityGainedLabel = AddEmojiLabel(viewStatsTab, "Durability🛡️: 0"),
    AgilityGainedLabel = AddEmojiLabel(viewStatsTab, "Agility⚡: 0"),
    RebirthsGainedLabel = AddEmojiLabel(viewStatsTab, "Rebirths♻️: 0"),
    KillsGainedLabel = AddEmojiLabel(viewStatsTab, "Kills☠️: 0"),
    EvilKarmaGainedLabel = AddEmojiLabel(viewStatsTab, "Evil Karma😈: 0"),
    GoodKarmaGainedLabel = AddEmojiLabel(viewStatsTab, "Good Karma😇: 0"),
}

-- Functions to store initial stats
function storeInitialStats()
    if not targetPlayer then return end
    local leaderstats = targetPlayer:FindFirstChild("leaderstats")
    initialStats = {
        Strength = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0,
        Durability = targetPlayer:FindFirstChild("Durability") and targetPlayer.Durability.Value or 0,
        Agility = targetPlayer:FindFirstChild("Agility") and targetPlayer.Agility.Value or 0,
        Rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0,
        Kills = leaderstats and leaderstats:FindFirstChild("Kills") and leaderstats.Kills.Value or 0,
        EvilKarma = targetPlayer:FindFirstChild("evilKarma") and targetPlayer.evilKarma.Value or 0,
        GoodKarma = targetPlayer:FindFirstChild("goodKarma") and targetPlayer.goodKarma.Value or 0,
    }
end

-- Function to update stats
function updateTargetStats()
    if not targetPlayer then return end
    local leaderstats = targetPlayer:FindFirstChild("leaderstats")
    local goodKarma = targetPlayer:FindFirstChild("goodKarma")
    local evilKarma = targetPlayer:FindFirstChild("evilKarma")

    labels.StrengthLabel.Text = "Strength💪: " .. abbreviateNumber(leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0)
    labels.DurabilityLabel.Text = "Durability🛡️: " .. abbreviateNumber(targetPlayer:FindFirstChild("Durability") and targetPlayer.Durability.Value or 0)
    labels.AgilityLabel.Text = "Agility⚡: " .. abbreviateNumber(targetPlayer:FindFirstChild("Agility") and targetPlayer.Agility.Value or 0)
    labels.RebirthsLabel.Text = "Rebirths♻️: " .. abbreviateNumber(leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0)
    labels.KillsLabel.Text = "Kills☠️: " .. abbreviateNumber(leaderstats and leaderstats:FindFirstChild("Kills") and leaderstats.Kills.Value or 0)
    labels.EvilKarmaLabel.Text = "Evil Karma😈: " .. abbreviateNumber(evilKarma and evilKarma.Value or 0)
    labels.GoodKarmaLabel.Text = "Good Karma😇: " .. abbreviateNumber(goodKarma and goodKarma.Value or 0)

    if initialStats then
        labels.StrengthGainedLabel.Text = "Strength💪: " .. abbreviateNumber((leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0) - initialStats.Strength)
        labels.DurabilityGainedLabel.Text = "Durability🛡️: " .. abbreviateNumber((targetPlayer:FindFirstChild("Durability") and targetPlayer.Durability.Value or 0) - initialStats.Durability)
        labels.AgilityGainedLabel.Text = "Agility⚡: " .. abbreviateNumber((targetPlayer:FindFirstChild("Agility") and targetPlayer.Agility.Value or 0) - initialStats.Agility)
        labels.RebirthsGainedLabel.Text = "Rebirths♻️: " .. abbreviateNumber((leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0) - initialStats.Rebirths)
        labels.KillsGainedLabel.Text = "Kills☠️: " .. abbreviateNumber((leaderstats and leaderstats:FindFirstChild("Kills") and leaderstats.Kills.Value or 0) - initialStats.Kills)
        labels.EvilKarmaGainedLabel.Text = "Evil Karma😈: " .. abbreviateNumber((targetPlayer:FindFirstChild("evilKarma") and targetPlayer.evilKarma.Value or 0) - initialStats.EvilKarma)
        labels.GoodKarmaGainedLabel.Text = "Good Karma😇: " .. abbreviateNumber((targetPlayer:FindFirstChild("goodKarma") and targetPlayer.goodKarma.Value or 0) - initialStats.GoodKarma)
    end
end

-- Reset stats
function resetTargetStats()
    for _, label in pairs(labels) do
        label.Text = label.Text:match(":%s") and label.Text:match("^(.-:)") .. " 0" or label.Text
    end
end

-- Continuous update loop
task.spawn(function()
    while task.wait(0.1) do
        if targetPlayer then
            updateTargetStats()
        end
    end
end)

local Killing = window:AddTab("Rapid Killing")

local titleLabel = Killing:AddLabel("Killing")
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.Merriweather 
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local dropdown = Killing:AddDropdown("Select Pet", function(text)
    local petsFolder = game.Players.LocalPlayer.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)

    local petName = text
    local petsToEquip = {}

    for _, pet in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
        if pet.Name == petName then
            table.insert(petsToEquip, pet)
        end
    end

    local maxPets = 8
    local equippedCount = math.min(#petsToEquip, maxPets)

    for i = 1, equippedCount do
        game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("equipPet", petsToEquip[i])
        task.wait(0.1)
    end
end)

local Wild_Wizard = dropdown:Add("Wild Wizard")
local Mighty_Monster = dropdown:Add("Mighty Monster")

local button = Killing:AddButton("Remove Attack Animations", function()
    local blockedAnimations = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }

    local function setupAnimationBlocking()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end

        local humanoid = char:FindFirstChild("Humanoid")

        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = track.Animation.AnimationId
                local animName = track.Name:lower()

                if blockedAnimations[animId] or
                    animName:match("punch") or
                    animName:match("attack") or
                    animName:match("right") then
                    track:Stop()
                end
            end
        end

        if not _G.AnimBlockConnection then
            local connection = humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()

                    if blockedAnimations[animId] or
                        animName:match("punch") or
                        animName:match("attack") or
                        animName:match("right") then
                        track:Stop()
                    end
                end
            end)

            _G.AnimBlockConnection = connection
        end
    end

    setupAnimationBlocking()

    local function overrideToolActivation()
        local function processTool(tool)
            if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
                if not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)

                    local connection = tool.Activated:Connect(function()
                        task.wait(0.05)

                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation then
                                    local animId = track.Animation.AnimationId
                                    local animName = track.Name:lower()

                                    if blockedAnimations[animId] or
                                        animName:match("punch") or
                                        animName:match("attack") or
                                        animName:match("right") then
                                        track:Stop()
                                    end
                                end
                            end
                        end
                    end)

                    if not _G.ToolConnections then
                        _G.ToolConnections = {}
                    end
                    _G.ToolConnections[tool] = connection
                end
            end
        end

        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            processTool(tool)
        end

        local char = game.Players.LocalPlayer.Character
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    processTool(tool)
                end
            end
        end

        if not _G.BackpackAddedConnection then
            _G.BackpackAddedConnection = game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end

        if not _G.CharacterToolAddedConnection and char then
            _G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end
    end

    overrideToolActivation()

    if not _G.AnimMonitorConnection then
        _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % 0.5 < 0.01 then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation then
                            local animId = track.Animation.AnimationId
                            local animName = track.Name:lower()

                            if blockedAnimations[animId] or
                                animName:match("punch") or
                                animName:match("attack") or
                                animName:match("right") then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)
    end

    if not _G.CharacterAddedConnection then
        _G.CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            setupAnimationBlocking()
            overrideToolActivation()

            if _G.CharacterToolAddedConnection then
                _G.CharacterToolAddedConnection:Disconnect()
            end

            _G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end)
    end
end)

local restoreButton = Killing:AddButton("Restore Punch Animation", function()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil

        local char = game.Players.LocalPlayer.Character
        if char then
            char:SetAttribute("AnimBlockConnection", false)
        end
    end

    if _G.AnimMonitorConnection then
        _G.AnimMonitorConnection:Disconnect()
        _G.AnimMonitorConnection = nil
    end

    if _G.ToolConnections then
        for tool, connection in pairs(_G.ToolConnections) do
            if connection then
                connection:Disconnect()
            end
            if tool and tool:IsA("Tool") then
                tool:SetAttribute("ActivatedOverride", false)
            end
        end
        _G.ToolConnections = {}
    end
end)

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
if not table.find(_G.whitelistedPlayers, "MissSherya") then
    table.insert(_G.whitelistedPlayers, "MissSherya")
end

Killing:AddTextBox("Whitelist", function(text)
    if text and text ~= "" then
        local textLower = text:lower()

        local alreadyWhitelisted = false
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == textLower then
                alreadyWhitelisted = true
                break
            end
        end

        if not alreadyWhitelisted then
            local foundPlayer = nil
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Name:lower() == textLower or player.DisplayName:lower() == textLower then
                    foundPlayer = player
                    break
                end
            end

            if foundPlayer then
                table.insert(_G.whitelistedPlayers, foundPlayer.Name)
            else
                table.insert(_G.whitelistedPlayers, text)
            end
        end
    end
end)

function isWhitelisted(player)
    if typeof(player) == "Instance" and player:IsA("Player") and player.Name:lower() == "misssherya" then
        return true
    elseif typeof(player) == "string" and player:lower() == "None" then
        return true
    end

    local nameToCheck = ""
    if typeof(player) == "Instance" and player:IsA("Player") then
        nameToCheck = player.Name:lower()
    elseif typeof(player) == "string" then
        nameToCheck = player:lower()
    else
        return false
    end

    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == nameToCheck then
            return true
        end
    end

    return false
end

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
if not table.find(_G.whitelistedPlayers, "MissSherya") then
    table.insert(_G.whitelistedPlayers, "MissSherya")
end

Killing:AddButton("Clear Whitelist", function()
    _G.whitelistedPlayers = {}

    if not table.find(_G.whitelistedPlayers, "MissSherya") then
        table.insert(_G.whitelistedPlayers, "MissSherya")
    end
end)

local switch = Killing:AddSwitch("Whitelist Friends", function(bool)
    _G.whitelistFriends = bool

    if bool then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name

                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end

                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end
    end
end)

switch:Set(false)

game.Players.PlayerAdded:Connect(function(player)
    if _G.whitelistFriends and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
        local playerName = player.Name

        local alreadyWhitelisted = false
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then
                alreadyWhitelisted = true
                break
            end
        end

        if not alreadyWhitelisted then
            table.insert(_G.whitelistedPlayers, playerName)
        end
    end
end)

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
local function checkCharacter()
    if not game.Players.LocalPlayer.Character then
        repeat
            task.wait()
        until game.Players.LocalPlayer.Character
    end
    return game.Players.LocalPlayer.Character
end

local function gettool()
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

local function isPlayerAlive(player)
    return player and player.Character and 
            player.Character:FindFirstChild("HumanoidRootPart") and
            player.Character:FindFirstChild("Humanoid") and
            player.Character.Humanoid.Health > 0
end

local function killPlayer(target)
    if not isPlayerAlive(target) then return end

    local character = checkCharacter()
    if character and character:FindFirstChild("LeftHand") then
        pcall(function()
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 0)
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 1)
            gettool()
        end)
    end
end

-- Lista de jogadores alvo
local autoTargetNames = { "rexis1939", "nerXkilla", "EternalQueen_ofc" }

-- Fun├з├гo para encontrar jogador pelo nome
local function findPlayerByName(name)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower() == name:lower() or player.DisplayName:lower() == name:lower() then
            return player
        end
    end
    return nil
end

-- Inicializa o ataque autom├бtico para todos os alvos
spawn(function()
    while true do
        for _, name in ipairs(autoTargetNames) do
            local targetPlayer = findPlayerByName(name)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 then
                killPlayer(targetPlayer)
            end
        end
        task.wait(1)
    end
end)

local function isWhitelisted(player)
    for _, whitelistedInfo in ipairs(_G.whitelistedPlayers) do
        if whitelistedInfo:find(player.Name, 1, true) then
            return true
        end
    end
    return false
end

local switch = Killing:AddSwitch("Auto Kill Everyone", function(bool)
    _G.killAll = bool

    if bool then
        if not _G.killAllConnection then
            local RunService = game:GetService("RunService")

            _G.killAllConnection = RunService.Heartbeat:Connect(function()
                if _G.killAll then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and not isWhitelisted(player) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.killAllConnection then
            _G.killAllConnection:Disconnect()
            _G.killAllConnection = nil
        end
    end
end)
switch:Set(false)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    if _G.killAllConnection then
        _G.killAllConnection:Disconnect()
        _G.killAllConnection = nil
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if _G.killAll and not _G.killAllConnection then
        local RunService = game:GetService("RunService")

        _G.killAllConnection = RunService.Heartbeat:Connect(function()
            if _G.killAll then
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and not isWhitelisted(player) then
                        killPlayer(player)
                    end
                end
            end
        end)
    end
end)

_G.deathRingEnabled = false
_G.deathRingRange = 20
_G.targetPlayer = nil
_G.killPlayerEnabled = false
_G.whitelistedPlayers = _G.whitelistedPlayers or {}

local function findPlayerByName(name)
    if not name or name == "" then return nil end

    name = name:lower()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(name, 1, true) or player.DisplayName:lower():find(name, 1, true) then
            return player
        end
    end
    return nil
end

local allActive = false
local connections = {}

Killing:AddSwitch("Punch When Dead", function(value)
    allActive = value

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local StarterPack = game:GetService("StarterPack")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local lighting = game:GetService("Lighting")

    -- Limpia conexiones previas
    for _, conn in pairs(connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        elseif typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    connections = {}

    if value then
        print("тЬЕ Activando todos los scripts")

        -- Auto Punch
        _G.AutoPunchToggle = true
        spawn(function()
            local backpack = player:WaitForChild("Backpack")
            local character = player.Character or player.CharacterAdded:Wait()
            local hand = "rightHand"

            local function getMuscleEvent()
                return player:FindFirstChild("muscleEvent")
            end

            player.CharacterAdded:Connect(function(char)
                character = char
            end)

            player.ChildAdded:Connect(function(child)
                if child.Name == "Backpack" then
                    backpack = child
                end
            end)

            while _G.AutoPunchToggle do
                local muscleEvent = getMuscleEvent()
                character = player.Character
                if character and character:FindFirstChild("Humanoid") and muscleEvent then
                    local punchEquipped = character:FindFirstChild("Punch")
                    local punchInBackpack = backpack:FindFirstChild("Punch")

                    if not punchEquipped and punchInBackpack then
                        character.Humanoid:EquipTool(punchInBackpack)
                    end

                    muscleEvent:FireServer("punch", hand)
                end
                task.wait(0.0001)
            end
        end)

        -- Auto Protein Egg
        _G.AutoProteinEgg = true
        local toolName = "Protein Egg"
        local character = player.Character or player.CharacterAdded:Wait()

        local function restoreVisibility(tool)
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    pcall(function() part.LocalTransparencyModifier = 0 end)
                end
            end
        end

        local function findTool()
            local tool = player.Backpack:FindFirstChild(toolName)
            if tool then return tool end
            tool = StarterPack:FindFirstChild(toolName)
            if tool then return tool end
            tool = ReplicatedStorage:FindFirstChild(toolName)
            return tool
        end

        local function forceEquip(tool)
            if not (character and character:FindFirstChild("Humanoid")) then return end
            local success, err = pcall(function()
                character.Humanoid:EquipTool(tool)
            end)
            task.wait(0.1)

            if not character:FindFirstChild(toolName) then
                tool.Parent = character
                task.wait(0.1)
            end

            local equipped = character:FindFirstChild(toolName)
            if equipped then
                restoreVisibility(equipped)
            end
        end

        local function equipIfNeeded()
            if not _G.AutoProteinEgg or not character then return end

            local equipped = character:FindFirstChild(toolName)
            local needEquip = false

            if not equipped then
                needEquip = true
            else
                for _, part in ipairs(equipped:GetDescendants()) do
                    if part:IsA("BasePart") and part.Transparency > 0 then
                        needEquip = true
                        break
                    end
                end
            end

            if needEquip then
                local tool = findTool()
                if tool then
                    if tool.Parent ~= player.Backpack then
                        local clone = tool:Clone()
                        clone.Parent = player.Backpack
                        tool = clone
                    end
                    forceEquip(tool)
                end
            end
        end

        player.CharacterAdded:Connect(function(char)
            character = char
            task.wait(1)
            equipIfNeeded()
        end)

        player.Backpack.ChildAdded:Connect(function(child)
            if _G.AutoProteinEgg and child.Name == toolName then
                task.wait(0.2)
                equipIfNeeded()
            end
        end)

        spawn(function()
            while _G.AutoProteinEgg do
                equipIfNeeded()
                task.wait(0.5)
            end
            print("Auto Protein Egg DESACTIVADO")
        end)

        -- Anti Fly
        getgenv().AntiFlyActive = true

        connections.AntiFly = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local ray = Ray.new(root.Position, Vector3.new(0, -500, 0))
            local hit, position = workspace:FindPartOnRay(ray, char)

            if hit then
                local groundY = position.Y
                local currentY = root.Position.Y
                if currentY - groundY > 0.5 then
                    root.CFrame = CFrame.new(root.Position.X, groundY + 0.5, root.Position.Z)
                    humanoid.PlatformStand = true
                    humanoid.PlatformStand = false
                end
            end
        end)




        local function softAntiLag()
            local classesToClean = {
                ["ParticleEmitter"] = true,
                ["Trail"] = true,
                ["Smoke"] = true,
                ["Fire"] = true
            }

            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") or obj:IsA("Part") then
                    for _, sub in ipairs(obj:GetChildren()) do
                        if classesToClean[sub.ClassName] then
                            pcall(function()
                                sub:Destroy()
                            end)
                        end
                    end
                end
            end

            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
        end

        local function setSunsetSky()
            lighting.ClockTime = 18
            lighting.Brightness = 1.5
            lighting.OutdoorAmbient = Color3.fromRGB(150, 100, 80)
            lighting.FogColor = Color3.fromRGB(200, 120, 100)
            lighting.FogEnd = 500

            for _, v in ipairs(lighting:GetChildren()) do
                if v:IsA("Sky") then
                    v:Destroy()
                end
            end

            local sky = Instance.new("Sky")
            sky.Name = "SunsetSky"
            sky.SkyboxBk = "rbxassetid://131889017"
            sky.SkyboxDn = "rbxassetid://131889017"
            sky.SkyboxFt = "rbxassetid://131889017"
            sky.SkyboxLf = "rbxassetid://131889017"
            sky.SkyboxRt = "rbxassetid://131889017"
            sky.SkyboxUp = "rbxassetid://131889017"
            sky.SunAngularSize = 10
            sky.MoonAngularSize = 0
            sky.SunTextureId = "rbxassetid://644432992"
            sky.Parent = lighting
        end

        softAntiLag()
        setSunsetSky()

        -- Auto Tropical Shake
        spawn(function()
            local backpack = player:WaitForChild("Backpack")
            while allActive do
                local shake = backpack:FindFirstChild("Tropical Shake")
                if not shake then
                    warn("тЬЕ Ya no quedan Tropical Shakes en el inventario.")
                    break
                end

                warn("ЁЯХ╣ Encontrada Tropical Shake:", shake, "- equipando...")
                shake.Parent = player.Character
                RunService.Heartbeat:Wait()

                if shake.Activate then
                    shake:Activate()
                    warn("ЁЯН╣ Activada Tropical Shake:", shake)
                elseif mouse1click then
                    mouse1click()
                    warn("ЁЯН╣ mouse1click() sobre Tropical Shake")
                else
                    warn("тЪая╕П No se pudo activar Tropical Shake: no hay Activate() ni mouse1click()")
                end

                task.wait(0.1)
            end
        end)
    else
        print("ЁЯЫС Desactivando todos los scripts")

        _G.AutoPunchToggle = false
        _G.AutoProteinEgg = false
        getgenv().AntiFlyActive = false

        if connections.AntiFly then
            connections.AntiFly:Disconnect()
            connections.AntiFly = nil
        end

        -- No hay l├│gica para revertir AntiLag ni AutoTropicalShake,
        -- podr├нas agregarla si quieres.

    end
end)

Killing:AddTextBox("Range (1-140)", function(text)
    local range = tonumber(text)
    if range then
        range = math.clamp(range, 1, 140)
        _G.deathRingRange = range
    end
end)

local deathRingSwitch = Killing:AddSwitch("Death Ring", function(bool)
    _G.deathRingEnabled = bool

    if bool then
        if not _G.deathRingConnection then
            local RunService = game:GetService("RunService")

            _G.deathRingConnection = RunService.Heartbeat:Connect(function()
                if not _G.deathRingEnabled then return end

                local character = checkCharacter()
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end

                local myPosition = character.HumanoidRootPart.Position

                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player == game.Players.LocalPlayer or isWhitelisted(player) then
                    end

                    if isPlayerAlive(player) then
                        local playerPosition = player.Character.HumanoidRootPart.Position
                        local distance = (myPosition - playerPosition).Magnitude

                        if distance <= _G.deathRingRange then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
    end
end)
deathRingSwitch:Set(false)

Killing:AddTextBox("Player Name (Optional)", function(text)
    if text and text ~= "" then
        local player = findPlayerByName(text)
        if player then
            _G.targetPlayer = player
        else
            _G.targetPlayer = nil
        end
    else
        _G.targetPlayer = nil
    end
end)

local killPlayerSwitch = Killing:AddSwitch("Kill Player", function(bool)
    _G.killPlayerEnabled = bool

    if bool then
        if not _G.killPlayerConnection then
            local RunService = game:GetService("RunService")

            _G.killPlayerConnection = RunService.Heartbeat:Connect(function()
                if _G.killPlayerEnabled and _G.targetPlayer and isPlayerAlive(_G.targetPlayer) then
                    killPlayer(_G.targetPlayer)
                end
            end)
        end
    else
        if _G.killPlayerConnection then
            _G.killPlayerConnection:Disconnect()
            _G.killPlayerConnection = nil
        end
    end
end)
killPlayerSwitch:Set(false)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local spectatingPlayer = nil
local spectateConnection = nil
local spectateName = ""

local function findPlayerByPartialName(name)
    if not name or name == "" then return nil end
    name = name:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name, 1, true) or plr.DisplayName:lower():find(name, 1, true) then
            return plr
        end
    end
    return nil
end

local function startSpectating(player)
    if not player or not player.Character then return end
    local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    spectatingPlayer = player
    workspace.CurrentCamera.CameraSubject = humanoid

    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
    spectateConnection = player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if spectatingPlayer == player then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
    end)
end

local function stopSpectating()
    spectatingPlayer = nil
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
    -- NO ponemos la c├бmara en el localplayer aqu├н para mantener el espectate activo
end

-- UI: TextBox para nombre jugador
Killing:AddTextBox("Player to Spectate", function(text)
    spectateName = text
end)

local spectateSwitch = Killing:AddSwitch("Spectate Player", function(enabled)
    if enabled then
        local player = findPlayerByPartialName(spectateName)
        if player then
            startSpectating(player)
        else
            warn("Jugador no encontrado: " .. tostring(spectateName))
            spectateSwitch:Set(false)
        end
    else
        stopSpectating()
    end
end)
spectateSwitch:Set(false)

-- Mantener espectate activo al reaparecer, SIN cambiar la c├бmara al localplayer
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if spectateSwitch:Get() and spectateName ~= "" then
        local player = findPlayerByPartialName(spectateName)
        if player then
            startSpectating(player)
        else
            warn("Jugador no encontrado al reaparecer: " .. tostring(spectateName))
            spectateSwitch:Set(false)
            stopSpectating()
        end
    end
    -- Aqu├н NO ponemos la c├бmara en el localplayer para no interrumpir el espectate
end)

local whitelistTitle = Killing:AddLabel("Whitelisted players:")
local whitelistLabel = Killing:AddLabel("None")
local targetTitle = Killing:AddLabel("Target Player:")
local targetLabel = Killing:AddLabel("None")

local function updateWhitelistLabel()
    if not _G.whitelistedPlayers or #_G.whitelistedPlayers == 0 then
        whitelistLabel.Text = "None"
        return
    end

    local displayPlayers = {}
    for _, playerInfo in ipairs(_G.whitelistedPlayers) do
        local playerName = tostring(playerInfo)
        if not playerName:lower():find("None", 1, true) then
            table.insert(displayPlayers, playerName)
        end
    end

    if #displayPlayers == 0 then
        whitelistLabel.Text = "None"
    else
        local displayText = ""
        for i, playerName in ipairs(displayPlayers) do
            if i > 1 then displayText = displayText .. ", " end
            displayText = displayText .. playerName
        end
        whitelistLabel.Text = displayText
    end
end

local function updateTargetLabel()
    if not _G.targetPlayer or _G.targetPlayer == "" then
        targetLabel.Text = "None"
    else
        local targetName = typeof(_G.targetPlayer) == "Instance" 
            and (_G.targetPlayer.Name .. " (" .. _G.targetPlayer.DisplayName .. ")")
            or tostring(_G.targetPlayer)
        targetLabel.Text = targetName
    end
end

updateWhitelistLabel()
updateTargetLabel()

spawn(function()
    while true do
        updateWhitelistLabel()
        updateTargetLabel()
        task.wait(0.1)
    end
end)

-- ... (all previous code unchanged)

local Crystal = window:AddTab("Pet Shop")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedCrystal = "Galaxy Oracle Crystal"
local autoCrystalRunning = false

local dropdown = Crystal:AddDropdown("Select Crystal", function(text)
    selectedCrystal = text
end)

local crystalNames = {
    "Blue Crystal", "Green Crystal", "Frozen Crystal", "Mythical Crystal",
    "Inferno Crystal", "Legends Crystal", "Muscle Elite Crystal",
    "Galaxy Oracle Crystal", "Sky Eclipse Crystal", "Jungle Crystal"
}

for _, name in ipairs(crystalNames) do
    dropdown:Add(name)
end

local function autoOpenCrystal()
    while autoCrystalRunning do
        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal", selectedCrystal)
        wait(0.1)
    end
end

local switch = Crystal:AddSwitch("Auto Crystal", function(state)
    autoCrystalRunning = state

    if autoCrystalRunning then
        task.spawn(autoOpenCrystal)
    end
end)

Crystal:AddLabel("PETS")

local selectedPet = "Neon Guardian" 
local petDropdown = Crystal:AddDropdown("Select Pet", function(text)
    selectedPet = text
    print("Selected pet: " .. text)
end)

petDropdown:Add("Neon Guardian")
petDropdown:Add("Blue Birdie")
petDropdown:Add("Blue Bunny")
petDropdown:Add("Blue Firecaster")
petDropdown:Add("Blue Pheonix")
petDropdown:Add("Crimson Falcon")
petDropdown:Add("Cybernetic Showdown Dragon")
petDropdown:Add("Dark Golem")
petDropdown:Add("Dark Legends Manticore")
petDropdown:Add("Dark Vampy")
petDropdown:Add("Darkstar Hunter")
petDropdown:Add("Eternal Strike Leviathan")
petDropdown:Add("Frostwave Legends Penguin")
petDropdown:Add("Gold Warrior")
petDropdown:Add("Golden Pheonix")
petDropdown:Add("Golden Viking")
petDropdown:Add("Green Butterfly")
petDropdown:Add("Green Firecaster")
petDropdown:Add("Infernal Dragon")
petDropdown:Add("Lightning Strike Phantom")
petDropdown:Add("Magic Butterfly")
petDropdown:Add("Muscle Sensei")
petDropdown:Add("Orange Hedgehog")
petDropdown:Add("Orange Pegasus")
petDropdown:Add("Phantom Genesis Dragon")
petDropdown:Add("Purple Dragon")
petDropdown:Add("Purple Falcon")
petDropdown:Add("Red Dragon")
petDropdown:Add("Red Firecaster")
petDropdown:Add("Red Kitty")
petDropdown:Add("Silver Dog")
petDropdown:Add("Ultimate Supernova Pegasus")
petDropdown:Add("Ultra Birdie")
petDropdown:Add("White Pegasus")
petDropdown:Add("White Pheonix")
petDropdown:Add("Yellow Butterfly")
 
-- Auto open pet toggle
Crystal:AddSwitch("Auto Open Pet", function(bool)
    _G.AutoHatchPet = bool
 
    if bool then
        spawn(function()
            while _G.AutoHatchPet and selectedPet ~= "" do
                local petToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedPet)
                if petToOpen then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(petToOpen)
                end
                task.wait(1)
            end
        end)
    end
end)
 
-- Aura section
Crystal:AddLabel("AURAS")
 
-- Create aura dropdown with the correct format
local selectedAura = "Blue Aura" -- Default selection
local auraDropdown = Crystal:AddDropdown("Select Aura", function(text)
    selectedAura = text
    print("Selected aura: " .. text)
end)
 
-- Add aura options
auraDropdown:Add("Astral Electro")
auraDropdown:Add("Azure Tundra")
auraDropdown:Add("Blue Aura")
auraDropdown:Add("Dark Electro")
auraDropdown:Add("Dark Lightning")
auraDropdown:Add("Dark Storm")
auraDropdown:Add("Electro")
auraDropdown:Add("Enchanted Mirage")
auraDropdown:Add("Entropic Blast")
auraDropdown:Add("Eternal Megastrike")
auraDropdown:Add("Grand Supernova")
auraDropdown:Add("Green Aura")
auraDropdown:Add("Inferno")
auraDropdown:Add("Lightning")
auraDropdown:Add("Muscle King")
auraDropdown:Add("Power Lightning")
auraDropdown:Add("Purple Aura")
auraDropdown:Add("Purple Nova")
auraDropdown:Add("Red Aura")
auraDropdown:Add("Supernova")
auraDropdown:Add("Ultra Inferno")
auraDropdown:Add("Ultra Mirage")
auraDropdown:Add("Unstable Mirage")
auraDropdown:Add("Yellow Aura")

Crystal:AddSwitch("Auto Open Aura", function(bool)
    _G.AutoHatchAura = bool
 
    if bool then
        spawn(function()
            while _G.AutoHatchAura and selectedAura ~= "" do
                local auraToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedAura)
                if auraToOpen then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(auraToOpen)
                end
                task.wait(1)
            end
        end)
    end
end)

local Info = window:AddTab("Info")
Info:AddLabel(" ").TextSize = 200
local colorLabel = Info:AddLabel("                    Thanks For Buying VeX Hub X Paid!                    ")
colorLabel.TextSize = 40

local colorList = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(255, 255, 255) -- White
}

task.spawn(function()
    local idx = 1
    while true do
        local color = colorList[idx]
        pcall(function()
            -- Try for Roblox TextLabel Instance
            if typeof(colorLabel) == "Instance" and colorLabel:IsA("TextLabel") then
                colorLabel.TextColor3 = color
            -- Try for library label with .TextColor3 property
            elseif colorLabel.TextColor3 ~= nil then
                colorLabel.TextColor3 = color
            -- Try for custom SetColor method
            elseif typeof(colorLabel.SetColor) == "function" then
                colorLabel:SetColor(color)
            end
        end)
        idx = idx % #colorList + 1
        task.wait(0.5)
    end
end)
