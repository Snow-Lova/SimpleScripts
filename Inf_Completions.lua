-- Function to create a platform at a specific position
local function createPlatform(x, y, z)
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(10, 1, 10) -- Adjust the size of the platform
    platform.Position = Vector3.new(x, y - 1, z) -- Place it slightly below the teleport location
    platform.Anchored = true -- Prevent the platform from falling
    platform.CanCollide = true -- Make it solid so the player can stand on it
    platform.Material = Enum.Material.SmoothPlastic -- Optional: Set the material
    platform.BrickColor = BrickColor.new("Bright blue") -- Optional: Set the color
    platform.Parent = workspace -- Add the platform to the game world
end

-- Function to teleport the player and create a platform
local function teleport(x, y, z, waitTime)
    print(string.format("Teleporting to coordinates: X: %d, Y: %d, Z: %d", x, y, z))
    
    -- Create a platform at the teleport location
    createPlatform(x, y, z)

    -- Teleport the player
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    else
        warn("Teleport failed: Player or HumanoidRootPart not found.")
    end

    -- Wait for the specified duration
    task.wait(waitTime)
end

-- List of locations with coordinates and wait times
local locations = {
    {-56, 28, 2068, 2},
    {-56, 28, 2846, 2},
    {-56, 28, 3607, 2},
    {-56, 28, 4387, 2},
    {-55, -360, 9494, 0.5},
    {-56, 28, 5089, 2},
    {-56, 28, 5942, 2},
    {-56, 28, 6690, 2},
    {-56, 28, 7473, 2},
    {-56, 40, 8274, 2}
}

-- Infinite loop for teleportation
while true do
    for _, location in ipairs(locations) do
        local x, y, z, waitTime = unpack(location)
        teleport(x, y, z, waitTime)
    end
end
