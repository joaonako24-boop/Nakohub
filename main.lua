repeat task.wait() until game:IsLoaded()

--////////////////////////////////////////////////////
-- SERVIÇOS
--////////////////////////////////////////////////////

local Players = game:GetService("Players")
local VirtualInputManager =
    game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

--////////////////////////////////////////////////////
-- FLUENT UI
--////////////////////////////////////////////////////

local Fluent = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/dawid-scripts/Fluent/main/source.lua"
))()

local SaveManager = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/InterfaceManager.lua"
))()

--////////////////////////////////////////////////////
-- JANELA
--////////////////////////////////////////////////////

local Window = Fluent:CreateWindow({
    Title = "Nako Hub | BLUE LOCK",
    SubTitle = "Edicao Egoista",
    TabWidth = 160,
    Size = UDim2.fromOffset(580,420),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

--////////////////////////////////////////////////////
-- ABAS
--////////////////////////////////////////////////////

local Tabs = {

    Principal = Window:AddTab({
        Title = "Atacante",
        Icon = "target"
    }),

    Jogador = Window:AddTab({
        Title = "Jogador",
        Icon = "user"
    }),

    Visual = Window:AddTab({
        Title = "Visual",
        Icon = "eye"
    }),

    Goleiro = Window:AddTab({
        Title = "Goleiro",
        Icon = "shield"
    }),

    Hitbox = Window:AddTab({
        Title = "Hitbox",
        Icon = "box"
    }),

    Config = Window:AddTab({
        Title = "Config",
        Icon = "settings"
    })
}

--////////////////////////////////////////////////////
-- VARIAVEIS
--////////////////////////////////////////////////////

shared.AutoChute = false
shared.AutoDrible = false
shared.AutoDefesa = false

shared.HitboxBola = false
shared.TamanhoHitbox = 10
shared.HitboxInvisivel = false

shared.ImaBola = false
shared.DistanciaIma = 20

--////////////////////////////////////////////////////
-- FUNCOES
--////////////////////////////////////////////////////

local function Personagem()
    return LocalPlayer.Character
end

local function Root()

    local Char = Personagem()

    if Char then
        return Char:FindFirstChild("HumanoidRootPart")
    end
end

local function Humanoid()

    local Char = Personagem()

    if Char then
        return Char:FindFirstChildOfClass("Humanoid")
    end
end

local function PegarBola()

    for _,v in pairs(workspace:GetDescendants()) do

        if v:IsA("BasePart") and
           v.Name:lower():find("ball") then

            return v
        end
    end
end

--////////////////////////////////////////////////////
-- ABA PRINCIPAL
--////////////////////////////////////////////////////

Tabs.Principal:AddParagraph({
    Title = "BLUE LOCK",
    Content = "Torne-se o atacante definitivo."
})

-- AUTO CHUTE
Tabs.Principal:AddToggle("AutoChute", {
    Title = "Auto Chute",
    Default = false,

    Callback = function(Value)

        shared.AutoChute = Value

        task.spawn(function()

            while shared.AutoChute do
                task.wait(0.15)

                local Bola = PegarBola()
                local HRP = Root()

                if Bola and HRP then

                    HRP.CFrame =
                        Bola.CFrame * CFrame.new(0,0,2)

                    pcall(function()

                        VirtualInputManager:SendMouseButtonEvent(
                            0,0,0,true,game,0
                        )

                        task.wait()

                        VirtualInputManager:SendMouseButtonEvent(
                            0,0,0,false,game,0
                        )

                    end)
                end
            end
        end)
    end
})

-- AUTO DRIBLE
Tabs.Principal:AddToggle("AutoDrible", {
    Title = "Auto Drible",
    Default = false,

    Callback = function(Value)

        shared.AutoDrible = Value

        task.spawn(function()

            while shared.AutoDrible do
                task.wait(1)

                pcall(function()

                    VirtualInputManager:SendKeyEvent(
                        true,
                        Enum.KeyCode.Q,
                        false,
                        game
                    )

                    task.wait(0.1)

                    VirtualInputManager:SendKeyEvent(
                        false,
                        Enum.KeyCode.Q,
                        false,
                        game
                    )

                end)
            end
        end)
