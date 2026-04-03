local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if getgenv().TRACERS_ENABLED == nil then
    getgenv().TRACERS_ENABLED = false
end

getgenv().TRACERS_ENABLED = not getgenv().TRACERS_ENABLED

getgenv().TRACER_LINES = getgenv().TRACER_LINES or {}

if getgenv().TRACER_CONNECTION then
    getgenv().TRACER_CONNECTION:Disconnect()
    getgenv().TRACER_CONNECTION = nil
end

if not getgenv().TRACERS_ENABLED then
    for _, line in pairs(getgenv().TRACER_LINES) do
        if line then
            line.Visible = false
        end
    end
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

getgenv().TRACER_CONNECTION = RunService.RenderStepped:Connect(function()
    local size = Camera.ViewportSize
    local startPos = Vector2.new(size.X / 2, 0)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local line = getLine(player)

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
