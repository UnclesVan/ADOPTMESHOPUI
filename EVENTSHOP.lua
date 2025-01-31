-- LocalScript placed in StarterPlayerScripts or StarterGui

local player = game.Players.LocalPlayer

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShopScreenGui"
screenGui.Parent = player:WaitForChild("PlayerGui") -- Ensure it's parented properly

-- Create the Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.6, 0)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

-- Create rounded corners for the frame
local corner = Instance.new("UICorner")
corner.Parent = frame

-- Create a Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.05, 0)
closeButton.Position = UDim2.new(0.85, 0, 0.05, 0)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 10)
closeButton.BackgroundTransparency = 0.2 -- Adjusted to make it visible
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.Parent = frame

-- Connect the Close Button to destroy the GUI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- This will destroy the GUI
end)

-- Set up items
local shopCategories = {
    ["Pets"] = {
       {name = "lunar_2025_blossom_snake cost: ★40 STARS LEAVING IN 12 HOURS!", maxAmount = 10, stock = 15},
       {name = "garden_2024_egg cost: 750$ BUCKS LEAVING SOON IN 1 DAY!", maxAmount = 10, stock = 15},
       {name = "royal_egg cost: $1450 BUCKS", maxAmount = 10, stock = 15},
       {name = "cracked_egg cost: $350 BUCKS", maxAmount = 10, stock = 15}, 
        
       -- {name = "cracked_egg", maxAmount = 1, stock = 0},
       -- {name = "royal_egg", maxAmount = 1, stock = 1}
    },
    ["Food"] = {
        {name = "tiny_pet_age_potion", maxAmount = 5, stock = 20},
        {name = "deluxe_pet_age_potion", maxAmount = 5, stock = 10},
    },
    ["Toys"] = {
        {name = "tiny_pet_toy", maxAmount = 5, stock = 15},
        {name = "deluxe_pet_toy", maxAmount = 5, stock = 10},
    }
}

-- Create a Tab Panel for each category
local tabPanel = Instance.new("Frame")
tabPanel.Size = UDim2.new(1, 0, 1, 0)
tabPanel.Position = UDim2.new(0, 0, 0.1, 0)
tabPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabPanel.BackgroundTransparency = 0.2
tabPanel.Parent = frame

-- Create tabs
local tabs = {}
local tabIndex = 1
for category, items in pairs(shopCategories) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.2, 0, 0.05, 0)
    tab.Position = UDim2.new((tabIndex - 1) * 0.2, 0, 0, 0)
    tab.Text = category
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.BackgroundColor3 = Color3.fromRGB(150, 0, 10)
    tab.Font = Enum.Font.SourceSansBold
    tab.TextSize = 14
    tab.Parent = tabPanel

    -- Create content for each tab
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0.8, 0)
    tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
    tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = tabIndex == 1
    tabFrame.Parent = tabPanel

    -- Create the items within each tab
    local itemIndex = 1
    for _, item in pairs(items) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, 0, 0.1, 0)
        itemFrame.Position = UDim2.new(0, 0, (itemIndex - 1) * 0.1, 0)
        itemFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        itemFrame.Parent = tabFrame

        -- Create rounded corners for the frame
        local itemCorner = Instance.new("UICorner")
        itemCorner.Parent = itemFrame

        -- Create a Label within the item frame
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.Text = item.name
        label.TextColor3 = Color3.fromRGB(0, 0, 0)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 20
        label.Parent = itemFrame

        -- Create a Frame for availability sign
        local availableFrame = Instance.new("Frame")
        availableFrame.Size = UDim2.new(0.2, 0, 1, 0)
        availableFrame.Position = UDim2.new(0.80, 0, 0, 0) -- Right aligned
        availableFrame.BackgroundTransparency = 1
        availableFrame.Parent = itemFrame

        -- Create a TextLabel for availability text
        local availableSign = Instance.new("TextLabel")
        availableSign.Size = UDim2.new(1, 0, 1, 0)
        availableSign.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red color for out of stock
        availableSign.Font = Enum.Font.SourceSansBold
        availableSign.TextSize = 18
        availableSign.BackgroundTransparency = 1
        availableSign.Parent = availableFrame

        -- Update availability based on stock
        if item.stock <= 0 then
            availableSign.Text = "OUT OF STOCK"
        else
            availableSign.Text = "AVAILABLE"
        end

        -- Create UI elements within the item frame
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.15, 0, 1, 0)
        textbox.Position = UDim2.new(0.5, 0, 0, 0)
        textbox.PlaceholderText = "Amount (max " .. item.maxAmount .. ")"
        textbox.TextColor3 = Color3.fromRGB(0, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        textbox.Font = Enum.Font.SourceSans
        textbox.TextSize = 18
        textbox.ClearTextOnFocus = true
        textbox.Parent = itemFrame

        local buyButton = Instance.new("TextButton")
        buyButton.Size = UDim2.new(0.15, 0, 1, 0)
        buyButton.Position = UDim2.new(0.65, 0, 0, 0)
        buyButton.Text = "Buy"
        buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        buyButton.Font = Enum.Font.SourceSansBold
        buyButton.TextSize = 20
        buyButton.Parent = itemFrame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.Parent = buyButton

        -- Connect buy button to the purchase logic
        buyButton.MouseButton1Click:Connect(function()
            local buyCount = tonumber(textbox.Text) or 0
            if buyCount > 0 and buyCount <= item.maxAmount and item.stock >= buyCount then
                local args = {
                    [1] = category:lower():gsub(" ", "_"),
                    [2] = item.name,
                    [3] = {
                        ["buy_count"] = buyCount
                    }
                }

                -- Call the purchase
                print("Attempting to buy " .. buyCount .. " of " .. item.name) -- Debug message
                game:GetService("ReplicatedStorage").API.BuyItem:InvokeServer(unpack(args))

                -- Clear the textbox after purchasing
                textbox.Text = ""
                item.stock = item.stock - buyCount -- Deduct the stock
                availableSign.Text = item.stock <= 0 and "OUT OF STOCK" or "AVAILABLE" -- Update availability
            else
                print("Invalid amount! Please enter a valid number.") -- Debug message
            end
        end)

        itemIndex = itemIndex + 1
    end

    tab.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Frame.Visible = false
        end
        tabFrame.Visible = true
    end)

    tabs[tabIndex] = {Tab = tab, Frame = tabFrame}
    tabIndex = tabIndex + 1
end
