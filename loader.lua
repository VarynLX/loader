-- Discord START
local success, err = pcall(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/VarynLX/loader/refs/heads/main/discord.lua",
        true
    ))()
end)

if not success then
    warn("[VarynLX] Discord script error: " .. tostring(err))
end
-- Discord END

if getgenv and getgenv().VarynLX_LOADED then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "VarynLX Hub",
            Text = "VarynLX is already loaded and running!",
            Duration = 5
        })
    end)
    return
end

-- [ Services ]
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "VarynLX Loader",
            Text = text or "",
            Duration = duration or 5
        })
    end)
end

-- [ Fetch Game Info ]
local placeId = game.PlaceId
local gameName = "Unknown Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(placeId)
    if info and info.Name then
        gameName = info.Name
    end
end)

print("\n=============================================")
print("🌟 VarynLX Universal Loader v2.0 Started")
print("📍 Place ID: " .. tostring(placeId))
print("🎮 Game Name: " .. gameName)
print("=============================================\n")

-- =============================================
-- GAME SCRIPT REPOSITORY CONFIGURATION
-- =============================================
local GamesConfig = {
    [142823291] = "https://test.com",
}

-- Fallback Script URL (runs when game is not supported)
local FallbackURL = "https://pastebin.com/raw/ZsyUHGFX"

-- Helper to safely load and execute script from URL
local function ExecuteScriptFromURL(url, isFallback)
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not content or content == "" then
        warn("❌ [VarynLX Loader] Failed to fetch script from URL: " .. tostring(url))
        Notify("VarynLX Error", "Failed to download script from server!", 6)
        return false
    end
    
    local func, compileErr = loadstring(content)
    if not func then
        warn("❌ [VarynLX Loader] Compilation error: " .. tostring(compileErr))
        Notify("VarynLX Error", "Script syntax compilation failed!", 6)
        return false
    end
    
    if getgenv then
        getgenv().VarynLX_LOADED = true
    end
    
    if not isFallback then
        Notify("VarynLX Loaded!", "Successfully loaded script for " .. gameName, 5)
    end
    
    task.spawn(func)
    return true
end

-- =============================================
-- MAIN LOADER DISPATCHER
-- =============================================
local scriptURL = GamesConfig[placeId]

if scriptURL then
    -- Supported Game Detected
    print("✅ [VarynLX] Game Supported! Initializing script...")
    Notify("VarynLX Loader", "Game Supported! Loading " .. gameName .. "...", 4)
    task.wait(0.5)
    ExecuteScriptFromURL(scriptURL, false)
else
    -- Unsupported Game
    warn("❌ [VarynLX] This game (" .. gameName .. " | " .. tostring(placeId) .. ") is not supported yet.")
    Notify("VarynLX Loader", "Game not supported yet. Loading fallback...", 5)
    print("🔄 [VarynLX] Executing fallback script...")
    task.wait(0.8)
    
    ExecuteScriptFromURL(FallbackURL, true)
end
