repeat
    wait()
until game:IsLoaded()

local Player = game.Players.LocalPlayer
local Accounts = Player.UserId .. "Accounts" .. ".json"

Des = {}
if makefolder then
    makefolder("Accounts")
end

local Settings

if not pcall(function()
    readfile("ReQiu Helper//" .. Accounts)
end) then
    writefile("ReQiu Helper//" .. Accounts, HttpService:JSONEncode(Des))
end
if readfile("ReQiu Helper//" .. Accounts) then
    Settings = HttpService:JSONDecode(readfile("ReQiu Helper//" .. Accounts))
end

local function Save()
    writefile("ReQiu Helper//" .. Name, HttpService:JSONEncode(Settings))
end

local Neon = {}
local Spec = {}
Settings.Key = {}
local PetID
local Pet
local PetsShow = {}
local List = {}
local JoJo = {}
local GGO = {}

local function refresh_pets()

    table.clear(JoJo)
    table.clear(GGO)
    table.clear(List)

    for i, v in pairs(require(ReplicatedStorage.ClientModules.Core.ClientData).get_data()[Player.Name].inventory.pets) do
        local Key = tostring(v["id"]) .. " - " .. tostring(v["properties"]["age"]) .. " years old"
        PetsShow[Key] = v
        table.insert(List, Key)
        table.sort(List, key)

    end

    for i, v in pairs(require(ReplicatedStorage.ClientModules.Core.ClientData).get_data()[Player.Name].inventory.pets) do
        if not table.find(JoJo, tostring(v["id"])) then
            local Key2 = tostring(v["id"])
            GGO[Key2] = v
            table.insert(JoJo, Key2)
            table.sort(JoJo)
        end
    end

    print("Refreshed Pets")
    print(JoJo)
    print(GGO)
    print(List)

end

refresh_pets()

pcall(function()
    ReplicatedStorage.API:FindFirstChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
end)

if CoreGui:FindFirstChild("ReQiuYTL Hub Helper") then
    CoreGui:FindFirstChild("ReQiuYTL Hub Helper"):Destroy()
end

local Library =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/13Works/Account-Controller/main/Library.lua"))()
local Window = Library:CreateWindow()

