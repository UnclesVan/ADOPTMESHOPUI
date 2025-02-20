-- Create the Fluent UI if it doesn't exist
local ValentinesEvent, ValentinesEventTeleport, TeleportSpeed -- Placeholders

-- Check if the Fluent UI is already loaded
if _G.FluentLoaded then  -- Use a global flag
    local Fluent = _G.Fluent
    local SaveManager = _G.SaveManager
    local InterfaceManager = _G.InterfaceManager
    local Window = _G.FluentWindow
else
    -- Fluent UI doesn't exist, load everything
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    _G.Fluent = Fluent
    _G.SaveManager = SaveManager
    _G.InterfaceManager = InterfaceManager
    
    -- Create Main UI Window
    local Window = Fluent:CreateWindow({
        Title = "Fluent " .. Fluent.Version,
        SubTitle = "by dawid",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
    _G.FluentWindow = Window

    -- Create Tabs
    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
        ValentinesTeleports = Window:AddTab({ Title = "Teleports", Icon = "map" }),
        AdoptMeShop = Window:AddTab({ Title = "ADOPTMESHOP", Icon = "shopping-cart" }), -- New tab for AdoptMeShop
    }

    -- Local Variables
    local teleportSpeed = 1 -- Initial teleport speed (seconds between teleports)
    local stopTeleportFlag = { Value = false } -- Table to hold the flag so it can be modified by reference
    local shopUIVisible = false -- To track the visibility of the shop UI
    local shopScreenGui -- Variable to hold the ScreenGui instance

    -- Teleport Toggle
    local ValentinesTeleportToggle = Tabs.ValentinesTeleports:AddToggle("ValentinesTeleportToggle", {
        Title = "Teleport to Valentines Locations",
        Default = false,
        Description = "Teleports to various Valentine-themed locations."
    })

    ValentinesTeleportToggle:OnChanged(function(state)
        if state then
            stopTeleportFlag.Value = false
            task.spawn(teleportToLocations, stopTeleportFlag)
        else
            stopTeleportFlag.Value = true -- Signal to stop
        end
    end)

    -- Teleport Speed Slider
    Tabs.ValentinesTeleports:AddSlider("TeleportSpeedSlider", {
        Title = "Teleport Speed",
        Description = "Adjust the speed of the teleports (lower value = faster).",
        Default = 1,
        Min = 0.1,
        Max = 5,
        Rounding = 0.1,
        Callback = function(value)
            teleportSpeed = value
        end
    })

    -- Add a toggle for handling the shop UI in the new tab
    local shopToggle = Tabs.AdoptMeShop:AddToggle("AdoptMeShopToggle", {
        Title = "Show Adopt Me Shop",
        Default = false,
        Description = "Toggles the visibility of the Adopt Me Shop UI."
    })

    shopToggle:OnChanged(function(state)
        if state then
            if not shopUIVisible then
                shopUIVisible = true
                createShopUI() -- Call to create and show the shop UI
            end
        else
            if shopUIVisible then
                shopUIVisible = false
                hideShopUI() -- Call to hide or destroy the shop UI
            end
        end
    end)

    -- Function to create the shop UI
    function createShopUI()
        local player = game.Players.LocalPlayer

        -- Create the ScreenGui only if it doesn't exist
        if not shopScreenGui then
            shopScreenGui = Instance.new("ScreenGui")
            shopScreenGui.Name = "ShopScreenGui"
            shopScreenGui.Parent = player:WaitForChild("PlayerGui")

            -- Create the Main Frame
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0.4, 0, 0.6, 0)
            frame.Position = UDim2.new(0.3, 0, 0.2, 0)
            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            frame.BackgroundTransparency = 0.2
            frame.Parent = shopScreenGui

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
            closeButton.BackgroundTransparency = 0.2 
            closeButton.Font = Enum.Font.SourceSansBold
            closeButton.TextSize = 14
            closeButton.Parent = frame

            -- Connect the Close Button to hide the GUI
            closeButton.MouseButton1Click:Connect(function()
                hideShopUI() -- Call hide function instead of destroying it directly to maintain reference
            end)

            -- Set up items (Example structure)
            local shopCategories = {  
                ["Pets"] = {
                    {name = "valentines_2025_love_bird", maxAmount = 10, stock = 15},
                    {name = "royal_egg", maxAmount = 10, stock = 15},
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

            -- Continue with the rest of your shop UI creation code as necessary...
            
            -- Example of setting up tabs, items etc. goes here...
            -- Make sure to add the functionality for tabs and items as needed 
        else
            -- If the UI already exists, simply show it
            shopScreenGui.Enabled = true
        end
    end

    -- Function to hide the shop UI
    function hideShopUI()
        if shopScreenGui then
            shopScreenGui.Enabled = false -- Just hide the UI instead of destroying
            shopUIVisible = false -- Update the visibility flag
        end
    end

    -- Notify user
    Fluent:Notify({
        Title = "Fluent",
        Content = "The script has been loaded.",
        Duration = 8
    })

    SaveManager:LoadAutoloadConfig()
    _G.FluentLoaded = true
end
