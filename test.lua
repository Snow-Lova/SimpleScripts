local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player.PlayerGui
local seedShop = PlayerGui.Seed_Shop.Frame.ScrollingFrame
local Sheckles = game:GetService("Players").LocalPlayer.leaderstats.Sheckles.Value
local SellPos = Vector3.new(62, 3, 0)
local playerName = Player.Name
local SellInterval = 60

local seedNames = {
    "Apple", "Bamboo", "Blueberry", "Cacao", "Cactus", "Carrot", "Coconut", "Corn", "Daffodil", "Dragon Fruit", "Grape", "Mango", "Mushroom", "Orange Tulip", "Pepper", "Pumpkin", "Strawberry", "Tomato", "Watermelon"
}

local seeds = {}

local Playerplot = nil

for _, plot in ipairs(workspace.Farm:GetChildren()) do
    local important = plot:FindFirstChild("Important")
    local data = important and important:FindFirstChild("Data")
    local owner = data and data:FindFirstChild("Owner")
    
    if owner and owner.Value == playerName then
        Playerplot = plot
        break
    end
end

local canPlantFolder = Playerplot.Important.Plant_Locations
local allLocations = canPlantFolder:GetChildren()

print("Player's plot index: ", Playerplot)

for _, name in ipairs(seedNames) do
    local seed = seedShop:FindFirstChild(name)
    seeds[name] = seed.Main_Frame.Cost_Text.Text
end

local function Sell()
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(SellPos)
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
    end
end

local function BuySeed(Buy)
    while true do
        local args = {
            Buy
        }
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(unpack(args))
        task.wait(0.1)
        local cost = seeds[Buy]
        if cost ~= "NO STOCK" then
            local numericCost = tonumber(cost:gsub("%D", "")) -- Remove any non-digit characters
            if numericCost and numericCost > Sheckles then
                break
            end
        else
            break
        end    
    end
end

local function CheckStock(FruitSeed)
    local cost = seeds[FruitSeed]
    if cost ~= "NO STOCK" then
        local numericCost = tonumber(cost:gsub("%D", "")) -- Remove any non-digit characters
        if numericCost and numericCost <= Sheckles then
            BuySeed(FruitSeed)
        end
    end
end

local function getRandomPositionInPart(part)
    local size = part.Size
    local randomOffset = Vector3.new(
        (math.random() - 0.5) * size.X,
        0.13552513718605042,  
        (math.random() - 0.5) * size.Z
    )
    return part.Position + randomOffset
end

local function PlantSeed(seedName, location)
    local args = {
        seedName,
        location
    }
    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Grow A Garden",
    Footer = "v1.0.0",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true,
    Font = Enum.Font.SciFi
})

local MainTab = Window:AddTab("Main", "home") 

local LeftGroupbox = MainTab:AddLeftGroupbox("Automation")

local RightGroupbox = MainTab:AddRightGroupbox("Settings")

local Slider = RightGroupbox:AddSlider("SellSlider", {
    Text = "SellInterval",
    Default = 60,
    Min = 20,
    Max = 240,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        SellInterval = Value
    end
})

local ToggleValue = false

local MultiDropdown = RightGroupbox:AddDropdown("SeedDropdown", {
    Values = seedNames,
    Default = {"Pepper"},
    Multi = true,
    Text = "Select Seeds",
    Tooltip = "Select the seeds you want to automatically buy.",
    Callback = function(Values)
        SelectedSeeds = Values
    end
})

local MyCheckbox = LeftGroupbox:AddCheckbox("BuySeeds", {
    Text = "Auto Buy Seeds",
    Default = false,
    Callback = function(Value)
        ToggleValue = Value
    end
})

task.spawn(function()
    while true do
        if ToggleValue then
            for seed, selected in pairs(SelectedSeeds) do
                if selected then
                    CheckStock(seed)
                end
            end
        end
        task.wait(1) -- Check every 1 second
    end
end)

local Toggle = false

local Toggle = LeftGroupbox:AddToggle("AutoSell", {
    Text = "Auto Sell",
    Default = false,
    Tooltip = "Automatically sells your crops every " .. SellInterval .. " seconds.",
    Callback = function(Value)
        if Value then
            while Toggle do
                wait(SellInterval)
                if Toggle == false then
                    break
                end
                Sell()
            end
        end
    end
})

local Toggle = LeftGroupbox:AddToggle("AutoPlant", {
    Text = "Auto Plant",
    Default = false,
    Tooltip = "Automatically plants seeds.",
    Callback = function(Value)
        if Value then
            while Toggle do
                for _, seed in ipairs(seedNames) do
                    for _, location in ipairs(allLocations) do
                        local randomPosition = getRandomPositionInPart(location)
                        PlantSeed(seed, randomPosition)
                        task.wait(1)
                    end
                end
            end
        end
    end
})
