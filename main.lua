--[[
 ███╗   ██╗ █████╗ ██╗  ██╗ ██████╗
 ████╗  ██║██╔══██╗██║ ██╔╝██╔═══██╗
 ██╔██╗ ██║███████║█████╔╝ ██║   ██║
 ██║╚██╗██║██╔══██║██╔═██╗ ██║   ██║
 ██║ ╚████║██║  ██║██║  ██╗╚██████╔╝
 ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

 Nako Hub | BLUE LOCK
 Estilo Banana Hub
]]

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
    SubTitle = "Edição Egoísta",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 420),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

--////////////////////////////////////////////////////
-- ABAS
--////////////////////////////////////////////////////

local Tabs = {

    Principal = Window:AddTab({
        Title = "Atacante",
        Icon = "goal"
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
        Icon = "circle"
    }),

    Config = Window:AddTab({
        Title = "Config",
        Icon = "settings"
    })
}

--////////////////////////////////////////////////////
-- VARIÁVEIS
--////////////////////////////////////////////////////

shared.AutoChute = false
shared.AutoDrible = false
shared.AutoDefesa = false

shared.HitboxBola = false
shared.TamanhoHitbox = 10
shared.HitboxInvisivel = false

shared.ImãBola = false
shared.DistanciaImã = 20

--////////////////////////////////////////////////////
-- FUNÇÕES
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
    Content = "Torne-se o atacante egoísta definitivo."
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

                    VirtualInputManager:SendMouseButtonEvent(
                        0,0,0,true,game,0
                    )

                    task.wait()

                    VirtualInputManager:SendMouseButtonEvent(
                        0,0,0,false,game,0
                    )
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
            end
        end)
    end
})

-- TELEPORTAR PARA BOLA
Tabs.Principal:AddButton({
    Title = "Teleportar Para Bola",

    Callback = function()

        local Bola = PegarBola()
        local HRP = Root()

        if Bola and HRP then

            HRP.CFrame =
                Bola.CFrame * CFrame.new(0,0,3)
        end
    end
})

-- IMÃ DE BOLA
Tabs.Principal:AddToggle("ImaBola", {
    Title = "Imã de Bola",
    Default = false,

    Callback = function(Value)

        shared.ImãBola = Value

        task.spawn(function()

            while shared.ImãBola do
                task.wait(0.05)

                local Bola = PegarBola()
                local HRP = Root()

                if Bola and HRP then

                    local Distancia =
                        (HRP.Position - Bola.Position).Magnitude

                    if Distancia <= shared.DistanciaImã then

                        Bola.CFrame =
                            HRP.CFrame * CFrame.new(0,0,-3)

                        Bola.AssemblyLinearVelocity =
                            Vector3.zero

                        Bola.AssemblyAngularVelocity =
                            Vector3.zero
                    end
                end
            end
        end)
    end
})

Tabs.Principal:AddSlider("DistanciaIma", {
    Title = "Distância do Imã",
    Min = 5,
    Max = 50,
    Default = 20,
    Rounding = 1,

    Callback = function(Value)

        shared.DistanciaImã = Value
    end
})

--////////////////////////////////////////////////////
-- ABA JOGADOR
--////////////////////////////////////////////////////

Tabs.Jogador:AddSlider("Velocidade", {
    Title = "Velocidade",
    Min = 16,
    Max = 150,
    Default = 16,
    Rounding = 1,

    Callback = function(Value)

        local Hum = Humanoid()

        if Hum then
            Hum.WalkSpeed = Value
        end
    end
})

Tabs.Jogador:AddSlider("Pulo", {
    Title = "Pulo",
    Min = 50,
    Max = 250,
    Default = 50,
    Rounding = 1,

    Callback = function(Value)

        local Hum = Humanoid()

        if Hum then
            Hum.JumpPower = Value
        end
    end
})

Tabs.Jogador:AddButton({
    Title = "Resetar Status",

    Callback = function()

        local Hum = Humanoid()

        if Hum then
            Hum.WalkSpeed = 16
            Hum.JumpPower = 50
        end
    end
})

--////////////////////////////////////////////////////
-- ABA VISUAL
--////////////////////////////////////////////////////

Tabs.Visual:AddButton({
    Title = "ESP da Bola",

    Callback = function()

        local Bola = PegarBola()

        if Bola and
           not Bola:FindFirstChild("BlueLockESP") then

            local Highlight = Instance.new("Highlight")

            Highlight.Name = "BlueLockESP"

            Highlight.FillColor =
                Color3.fromRGB(0,170,255)

            Highlight.OutlineColor =
                Color3.fromRGB(255,255,255)

            Highlight.FillTransparency = 0.3

            Highlight.Parent = Bola
        end
    end
})

Tabs.Visual:AddButton({
    Title = "FullBright",

    Callback = function()

        game.Lighting.Brightness = 5
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
    end
})

--////////////////////////////////////////////////////
-- ABA GOLEIRO
--////////////////////////////////////////////////////

Tabs.Goleiro:AddToggle("AutoDefesa", {
    Title = "Auto Defesa",
    Default = false,

    Callback = function(Value)

        shared.AutoDefesa = Value

        task.spawn(function()

            while shared.AutoDefesa do
                task.wait(0.05)

                local Bola = PegarBola()
                local HRP = Root()

                if Bola and HRP then

                    local Distancia =
                        (HRP.Position - Bola.Position).Magnitude

                    if Distancia <= 25 then

                        HRP.CFrame =
                            Bola.CFrame * CFrame.new(0,0,1)
                    end
                end
            end
        end)
    end
})

--////////////////////////////////////////////////////
-- ABA HITBOX
--////////////////////////////////////////////////////

Tabs.Hitbox:AddToggle("HitboxBola", {
    Title = "Hitbox da Bola",
    Default = false,

    Callback = function(Value)

        shared.HitboxBola = Value

        task.spawn(function()

            while shared.HitboxBola do
                task.wait(0.1)

                local Bola = PegarBola()

                if Bola then

                    local Existente =
                        Bola:FindFirstChild("BlueLockHitbox")

                    if not Existente then

                        local Part = Instance.new("Part")

                        Part.Name = "BlueLockHitbox"

                        Part.Size = Vector3.new(
                            shared.TamanhoHitbox,
                            shared.TamanhoHitbox,
                            shared.TamanhoHitbox
                        )

                        Part.Shape = Enum.PartType.Ball

                        Part.Material =
                            Enum.Material.Neon

                        Part.Color =
                            Color3.fromRGB(0,170,255)

                        Part.Transparency =
                            shared.HitboxInvisivel and 1 or 0.45

                        Part.CanCollide = false
                        Part.Massless = true

                        local Weld =
                            Instance.new("WeldConstraint")

                        Weld.Part0 = Bola
                        Weld.Part1 = Part
                        Weld.Parent = Part

                        Part.CFrame = Bola.CFrame
                        Part.Parent = Bola

                    else

                        Existente.Size = Vector3.new(
                            shared.TamanhoHitbox,
                            shared.TamanhoHitbox,
                            shared.TamanhoHitbox
                        )

                        Existente.Transparency =
                            shared.HitboxInvisivel and 1 or 0.45
                    end
                end
            end

            local Bola = PegarBola()

            if Bola then

                local Hitbox =
                    Bola:FindFirstChild("BlueLockHitbox")

                if Hitbox then
                    Hitbox:Destroy()
                end
            end
        end)
    end
})

Tabs.Hitbox:AddSlider("TamanhoHitbox", {
    Title = "Tamanho da Hitbox",
    Min = 5,
    Max = 50,
    Default = 10,
    Rounding = 1,

    Callback = function(Value)

        shared.TamanhoHitbox = Value
    end
})

Tabs.Hitbox:AddToggle("HitboxInvisivel", {
    Title = "Hitbox Invisível",
    Default = false,

    Callback = function(Value)

        shared.HitboxInvisivel = Value
    end
})

--////////////////////////////////////////////////////
-- CONFIG
--////////////////////////////////////////////////////

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("NakoHub")
SaveManager:SetFolder("NakoHub/BlueLock")

InterfaceManager:BuildInterfaceSection(
    Tabs.Config
)

SaveManager:BuildConfigSection(
    Tabs.Config
)

--////////////////////////////////////////////////////
-- NOTIFICAÇÃO
--////////////////////////////////////////////////////

Fluent:Notify({
    Title = "Nako Hub",
    Content = "BLUE LOCK carregado com sucesso.",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()

print("Nako Hub carregado!")
