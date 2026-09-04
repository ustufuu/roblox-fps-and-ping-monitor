local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FpsPingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 150, 0, 40)
-- Позиция строго посередине между "Сверху в центре" (0.5) и "Справа сверху" (1.0) -> 0.75
container.Position = UDim2.new(0.75, 0, 0, 10)
container.AnchorPoint = Vector2.new(0.5, 0)
container.BackgroundTransparency = 1
container.Parent = screenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.Parent = container

-- Функция для создания текста
local function createLabel(name, text, order)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.new(1, 0, 0, 14)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 12 -- Маленький шрифт
	label.Font = Enum.Font.SourceSans -- Четкий аккуратный шрифт
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Text = text
	label.LayoutOrder = order
	label.Parent = container
	
	-- Лёгкая тень для лучшей читаемости на светлом фоне
	label.TextStrokeTransparency = 0.5
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	
	return label
end

local fpsLabel = createLabel("FpsLabel", "FPS: --", 1)
local pingLabel = createLabel("PingLabel", "PING: -- ms", 2)

-- Расчет FPS и Ping
local frameCount = 0
local lastCheck = tick()

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local currentTime = tick()
	
	-- Обновление значений раз в 0.5 секунды, чтобы текст не рябил
	if currentTime - lastCheck >= 0.5 then
		local fps = math.floor(frameCount / (currentTime - lastCheck))
		
		-- Безопасный расчет пинга через Stats сервис
		local ping = 0
		local networkStats = Stats:FindFirstChild("Network")
		if networkStats and networkStats:FindFirstChild("ServerStatsItem") then
			ping = math.floor(networkStats.ServerStatsItem["Data Ping"]:GetValue())
		end
		
		fpsLabel.Text = "FPS: " .. tostring(fps)
		pingLabel.Text = "PING: " .. tostring(ping) .. " ms"
		
		frameCount = 0
		lastCheck = currentTime
	end
end)