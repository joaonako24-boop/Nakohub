--[[
███╗   ██╗ █████╗ ██╗  ██╗ ██████╗
████╗  ██║██╔══██╗██║ ██╔╝██╔═══██╗
██╔██╗ ██║███████║█████╔╝ ██║   ██║
██║╚██╗██║██╔══██║██╔═██╗ ██║   ██║
██║ ╚████║██║  ██║██║  ██╗╚██████╔╝
╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

Nako Hub 🇧🇷
Versão Otimizada Delta Executor
]]

--// SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

--// RAYFIELD NOVO
local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

--// JANELA
local Window = Rayfield:CreateWindow({
    Name = "Nako Hub | Blue Lock ⚽",
    LoadingTitle = "Nako Hub",
    LoadingSubtitle = "Carregando...",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

--// VARIÁVEIS
getgenv().AutoChute = false
getgenv().AutoDrible = false
getgenv().AutoDefesa = false
getgenv().AutoPulo = false

getgenv().HitboxAtiva = false
getgenv().HitboxInvisivel = false
getgenv().TamanhoHitbox = 10

--////////////////////////////////////////////////////
-- FUNÇÕES
--////////////////////////////////////////////////////

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetRoot()
    local Character = GetCharacter()

    if Character then
        return Character:FindFirstChild("HumanoidRootPart")
    end
end

local function GetHumanoid()
    local Character = GetCharacter()

    if Character then
        return Character:FindFirstChildOfClass("Humanoid")
    end
end

-- PROCURA BOLA
local function GetBall()

    for _,v in pairs(workspace:GetDescendants()) do

        if v:IsA("BasePart") and v.Name:lower():find("ball") then
            return v
        end
    end
end

--////////////////////////////////////////////////////
-- NOTIFICAÇÃO
--////////////////////////////////////////////////////

Rayfield:Notify({
    Title = "Nako Hub",
    Content = "Script carregado!",
    Duration = 5,
    Image = 4483362458
})

--////////////////////////////////////////////////////
-- ABA PRINCIPAL
--////////////////////////////////////////////////////

local Main = Window:CreateTab("⚽ Principal", 4483362458)

Main:CreateSection("Funções")

-- AUTO CHUTE
Main:CreateToggle({
    Name = "Auto Chute",
    CurrentValue = false,
    Flag = "AutoChute",
    Callback = function(Value)

        getgenv().AutoChute = Value

        task.spawn(function()

            while getgenv().AutoChute do
                task.wait(0.2)

                local Root = GetRoot()
                local Ball = GetBall()

                if Root and Ball then

                    Root.CFrame = Ball.CFrame * CFrame.new(0,0,2)

                    pcall(function()

                        VirtualInputManager:SendMouseButtonEvent(
                            0,
                            0,
                            0,
                            true,
                            game,
                            0
                        )

                        task.wait()

                        VirtualInputManager:SendMouseButtonEvent(
                            0,
                            0,
                            0,
                            false,
                            game,
                            0
                        )

                    end)
                end
            end
        end)
    end
})

-- TELEPORTAR BOLA
Main:CreateButton({
    Name = "Teleportar Para Bola",
    Callback = function()

        local Root = GetRoot()
        local Ball = GetBall()

        if Root and Ball then
            Root.CFrame = Ball.CFrame * CFrame.new(0,0,3)
        end
    end
})

-- AUTO DRIBLE
Main:CreateToggle({
    Name = "Auto Drible",
    CurrentValue = false,
    Flag = "AutoDrible",
    Callback = function(Value)

        getgenv().AutoDrible = Value

        task.spawn(function()

            while getgenv().AutoDrible do
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
    end
})

--////////////////////////////////////////////////////
-- ABA PLAYER
--////////////////////////////////////////////////////

local PlayerTab = Window:CreateTab("🏃 Jogador", 4483362458)

PlayerTab:CreateSection("Player")

-- SPEED
PlayerTab:CreateSlider({
    Name = "Velocidade",
    Range = {16,150},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Speed",
    Callback = function(Value)

        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

-- JUMP
PlayerTab:CreateSlider({
    Name = "Pulo",
    Range = {50,250},
    Increment = 1,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "Jump",
    Callback = function(Value)

        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

-- RESET
PlayerTab:CreateButton({
    Name = "Resetar",
    Callback = function()

        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
        end
    end
})

--////////////////////////////////////////////////////
-- VISUAL
--////////////////////////////////////////////////////

local Visual = Window:CreateTab("👁️ Visual", 4483362458)

Visual:CreateSection("Visual")

-- ESP
Visual:CreateButton({
    Name = "ESP Bola",
    Callback = function()

        local Ball = GetBall()

        if Ball and not Ball:FindFirstChild("NakoESP") then

            local Highlight = Instance.new("Highlight")

            Highlight.Name = "NakoESP"
            Highlight.FillColor = Color3.fromRGB(0,170,255)
            Highlight.OutlineColor = Color3.fromRGB(255,255,255)
            Highlight.FillTransparency = 0.3
            Highlight.Parent = Ball
        end
    end
})

-- FULLBRIGHT
Visual:CreateButton({
    Name = "FullBright",
    Callback = function()

        game.Lighting.Brightness = 5
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
    end
})

--////////////////////////////////////////////////////
-- GOLEIRO
--////////////////////////////////////////////////////

local Goalkeeper = Window:CreateTab("🧤 Goleiro", 4483362458)

Goalkeeper:CreateSection("Defesa")

-- AUTO DEFESA
Goalkeeper:CreateToggle({
    Name = "Auto Defesa",
    CurrentValue = false,
    Flag = "AutoDefesa",
    Callback = function(Value)

        getgenv().AutoDefesa = Value

        task.spawn(function()

            while getgenv().AutoDefesa do
                task.wait(0.05)

                local Root = GetRoot()
                local Ball = GetBall()

                if Root and Ball then

                    local Distance =
                        (Root.Position - Ball.Position).Magnitude

                    if Distance <= 25 then

                        Root.CFrame = Ball.CFrame * CFrame.new(0,0,1)

                        pcall(function()

                            VirtualInputManager:SendMouseButtonEvent(
                                0,
                                0,
                                0,
                                true,
                                game,
                                0
                            )

                            task.wait()

                            VirtualInputManager:SendMouseButtonEvent(
                                0,
                                0,
                                0,
                                false,
                                game,
                                0
                            )

                        end)
                    end
                end
            end
        end)
    end
})

-- AUTO PULO
Goalkeeper:CreateToggle({
    Name = "Auto Pulo",
    CurrentValue = false,
    Flag = "AutoPulo",
    Callback = function(Value)

        getgenv().AutoPulo = Value

        task.spawn(function()

            while getgenv().AutoPulo do
                task.wait(0.1)

                local Root = GetRoot()
                local Humanoid = GetHumanoid()
                local Ball = GetBall()

                if Root and Humanoid and Ball then

                    local Distance =
                        (Root.Position - Ball.Position).Magnitude

                    if Distance <= 15 then

                        if Ball.Position.Y > Root.Position.Y + 3 then
                            Humanoid:ChangeState(
                                Enum.HumanoidStateType.Jumping
                            )
                        end
                    end
                end
            end
        end)
    end
})

--////////////////////////////////////////////////////
-- HITBOX
--////////////////////////////////////////////////////

local Hitbox = Window:CreateTab("🥅 Hitbox", 4483362458)

Hitbox:CreateSection("Hitbox Bola")

-- TOGGLE
Hitbox:CreateToggle({
    Name = "Hitbox Gigante",
    CurrentValue = false,
    Flag = "Hitbox",
    Callback = function(Value)

        getgenv().HitboxAtiva = Value

        task.spawn(function()

            while getgenv().HitboxAtiva do
                task.wait(0.1)

                local Ball = GetBall()

                if Ball then

                    local Existing =
                        Ball:FindFirstChild("NakoHitbox")

                    if not Existing then

                        local Part = Instance.new("Part")

                        Part.Name = "NakoHitbox"
                        Part.Size = Vector3.new(
                            getgenv().TamanhoHitbox,
                            getgenv().TamanhoHitbox,
                            getgenv().TamanhoHitbox
                        )

                        Part.Transparency = 0.5
                        Part.Color = Color3.fromRGB(0,170,255)
                        Part.Material = Enum.Material.Neon
                        Part.CanCollide = false
                        Part.Massless = true

                        local Weld = Instance.new("WeldConstraint")
                        Weld.Part0 = Ball
                        Weld.Part1 = Part
                        Weld.Parent = Part

                        Part.CFrame = Ball.CFrame
                        Part.Parent = Ball

                    else

                        Existing.Size = Vector3.new(
                            getgenv().TamanhoHitbox,
                            getgenv().TamanhoHitbox,
                            getgenv().TamanhoHitbox
                        )

                        Existing.Transparency =
                            getgenv().HitboxInvisivel and 1 or 0.5
                    end
                end
            end

            -- REMOVE
            local Ball = GetBall()

            if Ball then

                local HitboxObj =
                    Ball:FindFirstChild("NakoHitbox")

                if HitboxObj then
                    HitboxObj:Destroy()
                end
            end
        end)
    end
})

-- TAMANHO
Hitbox:CreateSlider({
    Name = "Tamanho",
    Range = {5,50},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = 10,
    Flag = "Size",
    Callback = function(Value)

        getgenv().TamanhoHitbox = Value
    end
})

-- INVISÍVEL
Hitbox:CreateToggle({
    Name = "Hitbox Invisível",
    CurrentValue = false,
    Flag = "Invisible",
    Callback = function(Value)

        getgenv().HitboxInvisivel = Value
    end
})

--////////////////////////////////////////////////////
-- INFO
--////////////////////////////////////////////////////

local Info = Window:CreateTab("⭐ Info", 4483362458)

Info:CreateParagraph({
    Title = "Nako Hub 🇧🇷",
    Content = "Versão otimizada para Delta Executor"
})

Info:CreateButton({
    Name = "Copiar Discord",
    Callback = function()

        if setclipboard then
            setclipboard("discord.gg/nakohub")
        end
    end
})

--////////////////////////////////////////////////////
-- FINAL
--////////////////////////////////////////////////////

Rayfield:Notify({
    Title = "Nako Hub",
    Content = "Hub carregado com sucesso!",
    Duration = 5,
    Image = 4483362458
})

print("Nako Hub carregado!")
