-- Enhanced Roblox Fling Script with Toggle, Target Selection, and Adjustable Strength
local flingEnabled = false -- Toggle state (starts off)
local flingStrength = 500 -- Adjustable fling strength (default: 500)
local targetAllPlayers = true -- Set to false to target specific players
local specificTargets = {"Player1", "Player2"} -- Replace with target player names

-- Function to fling players
local function flingPlayers()
    while flingEnabled do
        local targets = targetAllPlayers and game.Players:GetPlayers() or {}
        if not targetAllPlayers then
            for _, player in pairs(game.Players:GetPlayers()) do
                for _, targetName in pairs(specificTargets) do
                    if player.Name == targetName then
                        table.insert(targets, player)
                    end
                end
            end
        end

        for _, player in pairs(targets) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = player.Character.HumanoidRootPart
                -- Apply random force with adjustable strength
                local flingForce = Vector3.new(
                    math.random(-flingStrength, flingStrength),
                    math.random(flingStrength / 2, flingStrength),
                    math.random(-flingStrength, flingStrength)
                )
                humanoidRootPart.Velocity = flingForce
            end
        end
        -- Small delay to prevent lag
        wait(0.1)
    end
end

-- Toggle fling on/off
local function toggleFling()
    flingEnabled = not flingEnabled
    if flingEnabled then
        print("Fling script enabled!")
        -- Start flinging in a new thread
        spawn(flingPlayers)
    else
        print("Fling script disabled!")
    end
end

-- Bind toggle to a key (e.g., "F" key)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggleFling()
    end
end)

-- Optional: Command to change fling strength
game.Players.LocalPlayer.Chatted:Connect(function(message)
    local strengthCommand = "/flingstrength "
    if message:sub(1, #strengthCommand) == strengthCommand then
        local newStrength = tonumber(message:sub(#strengthCommand + 1))
        if newStrength and newStrength > 0 then
            flingStrength = newStrength
            print("Fling strength set to " .. flingStrength)
        else
            print("Invalid strength value")
        end
    end
end)

print("Fling script loaded. Press 'F' to toggle. Use '/flingstrength <number>' to adjust strength.")
