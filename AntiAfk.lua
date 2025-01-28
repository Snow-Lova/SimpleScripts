-- Simulate player activity to prevent AFK kick every 5 minutes and random intervals
local function simulateMouseMovement()
    local playerMouse = player:GetMouse()

    -- Randomize a mouse position within the screen bounds
    local screenWidth = game.Workspace.CurrentCamera.ViewportSize.X
    local screenHeight = game.Workspace.CurrentCamera.ViewportSize.Y

    local randomX = math.random(0, screenWidth)
    local randomY = math.random(0, screenHeight)

    -- Simulate mouse movement by updating its position (using Hit property)
    local ray = game.Workspace.CurrentCamera:ScreenPointToRay(randomX, randomY)
    playerMouse.Hit = ray.Origin
end

-- Prevent AFK kick by simulating activity every 5 minutes and random intervals
while true do
    wait(300)  -- Wait for 5 minutes (300 seconds)
    
    -- Simulate mouse movement to keep the player active
    simulateMouseMovement()

    -- Wait for a random time between activity to simulate realistic behavior
    wait(math.random(30, 90))  -- Random delay between activities to avoid too predictable behavior
end
