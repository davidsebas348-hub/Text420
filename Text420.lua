local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().TRACERS_ENABLED = not (getgenv().TRACERS_ENABLED or false)
getgenv().TRACER_LINES = getgenv().TRACER_LINES or {}

if getgenv().TRACER_CONNECTION then
    getgenv().TRACER_CONNECTION:Disconnect()
    getgenv().TRACER_CONNECTION = nil
end

if getgenv().PLAYER_REMOVED_CONNECTION then
    getgenv().PLAYER_REMOVED_CONNECTION:Disconnect()
    getgenv().PLAYER_REMOVED_CONNECTION = nil
end

if not getgenv().TRACERS_ENABLED then
    for _, line in pairs(getgenv().TRACER_LINES) do
        if line then
            line:Remove()
        end
    end
    getgenv().TRACER_LINES = {}
    return
end

local function getLine(player)
    local line = getgenv().TRACER_LINES[player]

    if not line then
        line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Transparency = 1
        getgenv().TRACER_LINES[player] = line
    end

    return line
end

getgenv().PLAYER_REMOVED_CONNECTION = Players.PlayerRemoving:Connect(function(player)
    local line = getgenv().TRACER_LINES[player]
    if line then
        line:Remove()
        getgenv().TRACER_LINES[player] = nil
    end
end)

getgenv().TRACER_CONNECTION = RunService.RenderStepped:Connect(function()
    local size = Camera.ViewportSize
    local startPos = Vector2.new(size.X / 2, 0)

    for player, line in pairs(getgenv().TRACER_LINES) do
        if not player.Parent then
            line:Remove()
            getgenv().TRACER_LINES[player] = nil
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local line = getLine(player)
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if hrp then
                local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

                if visible then
                    line.From = startPos
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end
end)
