local flingEnabled = false
local flingStrength = 500
local targetAllPlayers = true
local specificTargets = {}
local flingMode = "Random"
local flingHeight = 50
local flingSpeed = 0.1
local guiEnabled = true

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
    print("This script is mobile-only.")
    return
end

local function updateSpecificTargets()
    specificTargets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(specificTargets, player.Name)
        end
    end
end

local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 600)
    frame.Position = UDim2.new(0.5, -200, 0.5, -300)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 70)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.Text = "Public Fling Control"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 28
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 180, 0, 70)
    toggleButton.Position = UDim2.new(0, 20, 0, 90)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.Text = "Toggle Fling"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 24
    toggleButton.Parent = frame

    local strengthBox = Instance.new("TextBox")
    strengthBox.Size = UDim2.new(0, 180, 0, 70)
    strengthBox.Position = UDim2.new(0, 200, 0, 90)
    strengthBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    strengthBox.Text = tostring(flingStrength)
    strengthBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    strengthBox.TextSize = 24
    strengthBox.Parent = frame

    local heightBox = Instance.new("TextBox")
    heightBox.Size = UDim2.new(0, 180, 0, 70)
    heightBox.Position = UDim2.new(0, 20, 0, 170)
    heightBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    heightBox.Text = tostring(flingHeight)
    heightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    heightBox.TextSize = 24
    heightBox.Parent = frame

    local modeButton = Instance.new("TextButton")
    modeButton.Size = UDim2.new(0, 180, 0, 70)
    modeButton.Position = UDim2.new(0, 200, 0, 170)
    modeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    modeButton.Text = "Mode: " .. flingMode
    modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeButton.TextSize = 24
    modeButton.Parent = frame

    local targetToggle = Instance.new("TextButton")
    targetToggle.Size = UDim2.new(0, 180, 0, 70)
    targetToggle.Position = UDim2.new(0, 20, 0, 250)
    targetToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    targetToggle.Text = "Target: All"
    targetToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetToggle.TextSize = 24
    targetToggle.Parent = frame

    local addTargetBox = Instance.new("TextBox")
    addTargetBox.Size = UDim2.new(0, 180, 0, 70)
    addTargetBox.Position = UDim2.new(0, 200, 0, 250)
    addTargetBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    addTargetBox.Text = "Add Target"
    addTargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    addTargetBox.TextSize = 24
    addTargetBox.Parent = frame

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 180, 0, 70)
    speedBox.Position = UDim2.new(0, 20, 0, 330)
    speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedBox.Text = tostring(flingSpeed)
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.TextSize = 24
    speedBox.Parent = frame

    local resetButton = Instance.new("TextButton")
    resetButton.Size = UDim2.new(0, 180, 0, 70)
    resetButton.Position = UDim2.new(0, 200, 0, 330)
    resetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    resetButton.Text = "Reset Settings"
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.TextSize = 24
    resetButton.Parent = frame

    local targetListButton = Instance.new("TextButton")
    targetListButton.Size = UDim2.new(0, 360, 0, 70)
    targetListButton.Position = UDim2.new(0, 20, 0, 410)
    targetListButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    targetListButton.Text = "Show Targets"
    targetListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetListButton.TextSize = 24
    targetListButton.Parent = frame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 60, 0, 60)
    closeButton.Position = UDim2.new(1, -70, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 24
    closeButton.Parent = frame

    local quickToggleButton = Instance.new("TextButton")
    quickToggleButton.Size = UDim2.new(0, 120, 0, 120)
    quickToggleButton.Position = UDim2.new(0, 10, 0, 10)
    quickToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    quickToggleButton.Text = "FLING"
    quickToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    quickToggleButton.TextSize = 28
    quickToggleButton.Parent = screenGui

    local targetListFrame = Instance.new("Frame")
    targetListFrame.Size = UDim2.new(0, 360, 0, 300)
    targetListFrame.Position = UDim2.new(0, 20, 0, 490)
    targetListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    targetListFrame.BorderSizePixel = 0
    targetListFrame.Visible = false
    targetListFrame.Parent = frame

    local targetListLabel = Instance.new("TextLabel")
    targetListLabel.Size = UDim2.new(1, 0, 1, 0)
    targetListLabel.BackgroundTransparency = 1
    targetListLabel.Text = ""
    targetListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetListLabel.TextSize = 20
    targetListLabel.TextWrapped = true
    targetListLabel.Parent = targetListFrame

    toggleButton.MouseButton1Click:Connect(function()
        flingEnabled = not flingEnabled
        toggleButton.Text = flingEnabled and "Fling: ON" or "Fling: OFF"
        print(flingEnabled and "Fling script enabled!" or "Fling script disabled!")
        if flingEnabled then spawn(flingPlayers) end
    end)

    quickToggleButton.MouseButton1Click:Connect(function()
        flingEnabled = not flingEnabled
        quickToggleButton.BackgroundColor3 = flingEnabled and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(50, 150, 50)
        quickToggleButton.Text = flingEnabled and "STOP" or "FLING"
        print(flingEnabled and "Fling script enabled!" or "Fling script disabled!")
        if flingEnabled then spawn(flingPlayers) end
    end)

    strengthBox.FocusLost:Connect(function()
        local newStrength = tonumber(strengthBox.Text)
        if newStrength and newStrength > 0 then
            flingStrength = newStrength
            print("Fling strength set to " .. flingStrength)
        else
            strengthBox.Text = tostring(flingStrength)
            print("Invalid strength value")
        end
    end)

    heightBox.FocusLost:Connect(function()
        local newHeight = tonumber(heightBox.Text)
        if newHeight and newHeight > 0 then
            flingHeight = newHeight
            print("Fling height set to " .. flingHeight)
        else
            heightBox.Text = tostring(flingHeight)
            print("Invalid height value")
        end
    end)

    modeButton.MouseButton1Click:Connect(function()
        flingMode = flingMode == "Random" and "Upward" or flingMode == "Upward" and "Circular" or flingMode == "Circular" and Red and flingMode == "Spiral" and "Random"
        modeButton.Text = "Mode: " .. flingMode
        print("Fling mode set to " .. flingMode)
    end)

    targetToggle.MouseButton1Click:Connect(function()
        targetAllPlayers = not targetAllPlayers
        targetToggle.Text = targetAllPlayers and "Target: All" or "Target: Specific"
        print(targetAllPlayers and "Targeting all players" or "Targeting specific players")
        if not targetAllPlayers then updateSpecificTargets() end
    end)

    addTargetBox.FocusLost:Connect(function()
        local playerName = addTargetBox.Text
        if playerName ~= "" and not table.find(specificTargets, playerName) then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Name == playerName and player ~= LocalPlayer then
                    table.insert(specificTargets, playerName)
                    print("Added " .. playerName .. " to specific targets")
                    break
                end
            end
        end
        addTargetBox.Text = "Add Target"
    end)

    speedBox.FocusLost:Connect(function()
        local newSpeed = tonumber(speedBox.Text)
        if newSpeed and newSpeed > 0 then
            flingSpeed = newSpeed
            print("Fling speed set to " .. flingSpeed)
        else
            speedBox.Text = tostring(flingSpeed)
            print("Invalid speed value")
        end
    end)

    resetButton.MouseButton1Click:Connect(function()
        flingStrength = 500
        flingHeight = 50
        flingSpeed = 0.1
        flingMode = "Random"
        targetAllPlayers = true
        specificTargets = {}
        strengthBox.Text = tostring(flingStrength)
        heightBox.Text = tostring(flingHeight)
        speedBox.Text = tostring(flingSpeed)
        modeButton.Text = "Mode: " .. flingMode
        targetToggle.Text = "Target: All"
        print("Settings reset to default")
    end)

    targetListButton.MouseButton1Click:Connect(function()
        targetListFrame.Visible = not targetListFrame.Visible
        targetListButton.Text = targetListFrame.Visible and "Hide Targets" or "Show Targets"
        if targetListFrame.Visible then
            updateSpecificTargets()
            local targetText = "Current Targets:\n"
            for _, name in pairs(specificTargets) do
                targetText = targetText .. name .. "\n"
            end
            targetListLabel.Text = targetText
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        guiEnabled = false
    end)
end

local function flingPlayers()
    while flingEnabled do
        local targets = targetAllPlayers and Players:GetPlayers() or {}
        if not targetAllPlayers then
            targets = {}
            for _, player in pairs(Players:GetPlayers()) do
                for _, targetName in pairs(specificTargets) do
                    if player.Name == targetName and player ~= LocalPlayer then
                        table.insert(targets, player)
                    end
                end
            end
        end

        for _, player in pairs(targets) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = player.Character.HumanoidRootPart
                local flingForce
                if flingMode == "Random" then
                    flingForce = Vector3.new(
                        math.random(-flingStrength, flingStrength),
                        math.random(flingStrength / 2, flingStrength),
                        math.random(-flingStrength, flingStrength)
                    )
                elseif flingMode == "Upward" then
                    flingForce = Vector3.new(0, flingStrength, 0)
                elseif flingMode == "Circular" then
                    local angle = math.rad(math.random(0, 360))
                    flingForce = Vector3.new(
                        math.cos(angle) * flingStrength,
                        flingHeight,
                        math.sin(angle) * flingStrength
                    )
                elseif flingMode == "Spiral" then
                    local time = tick()
                    local angle = math.rad(time * 100 % 360)
                    flingForce = Vector3.new(
                        math.cos(angle) * flingStrength,
                        flingHeight + math.sin(time * 2) * flingHeight,
                        math.sin(angle) * flingStrength
                    )
                end
                humanoidRootPart.Velocity = flingForce
            end
        end
        wait(flingSpeed)
    end
end

UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
    if not gameProcessed and #touchPositions == 1 and not guiEnabled then
        guiEnabled = true
        createGui()
    end
end)

UserInputService.TouchSwipe:Connect(function(swipeDirection, numberOfTouches, gameProcessed)
    if not gameProcessed and numberOfTouches == 2 then
        flingEnabled = not flingEnabled
        print(flingEnabled and "Fling script enabled!" or "Fling script disabled!")
        if flingEnabled then spawn(flingPlayers) end
    end
end)

UserInputService.TouchLongPress:Connect(function(touchPositions, gameProcessed)
    if not gameProcessed and #touchPositions == 1 then
        flingStrength = flingStrength + 100
        print("Fling strength increased to " .. flingStrength)
    end
end)

LocalPlayer.Chatted:Connect(function(message)
    local strengthCommand = "/flingstrength "
    local heightCommand = "/flingheight "
    local modeCommand = "/flingmode "
    local addTargetCommand = "/addtarget "
    local speedCommand = "/flingspeed "
    if message:sub(1, #strengthCommand) == strengthCommand then
        local newStrength = tonumber(message:sub(#strengthCommand + 1))
        if newStrength and newStrength > 0 then
            flingStrength = newStrength
            print("Fling strength set to " .. flingStrength)
        else
            print("Invalid strength value")
        end
    elseif message:sub(1, #heightCommand) == heightCommand then
        local newHeight = tonumber(message:sub(#heightCommand + 1))
        if newHeight and newHeight > 0 then
            flingHeight = newHeight
            print("Fling height set to " .. flingHeight)
        else
            print("Invalid height value")
        end
    elseif message:sub(1, #modeCommand) == modeCommand then
        local newMode = message:sub(#modeCommand + 1)
        if newMode == "Random" or newMode == "Upward" or newMode == "Circular" or newMode == "Spiral" then
            flingMode = newMode
            print("Fling mode set to " .. flingMode)
        else
            print("Invalid mode. Use Random, Upward, Circular, or Spiral")
        end
    elseif message:sub(1, #addTargetCommand) == addTargetCommand then
        local playerName = message:sub(#addTargetCommand + 1)
        if playerName ~= "" then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Name == playerName and player ~= LocalPlayer then
                    if not table.find(specificTargets, playerName) then
                        table.insert(specificTargets, playerName)
                        print("Added " .. playerName .. " to specific targets")
                    end
                    break
                end
            end
        end
    elseif message:sub(1, #speedCommand) == speedCommand then
        local newSpeed = tonumber(message:sub(#speedCommand + 1))
        if newSpeed and newSpeed > 0 then
            flingSpeed = newSpeed
            print("Fling speed set to " .. flingSpeed)
        else
            print("Invalid speed value")
        end
    end
end)

Players.PlayerAdded:Connect(function()
    if not targetAllPlayers then
        updateSpecificTargets()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if not targetAllPlayers then
        for i, name in pairs(specificTargets) do
            if name == player.Name then
                table.remove(specificTargets, i)
                print("Removed " .. player.Name .. " from specific targets")
                break
            end
        end
    end
end)

if guiEnabled then
    createGui()
end

print("Mobile fling script loaded. Swipe with two fingers to toggle, tap to open GUI, long press to increase strength. Use commands to adjust settings.")
