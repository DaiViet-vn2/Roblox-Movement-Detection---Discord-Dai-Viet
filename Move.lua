local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WEBHOOK_URL = "ur webhook url"
local MIN_DISTANCE = 0.1

local function getUnixTimestampUTC()
	return os.time(os.date("!*t"))
end

local function sendWebhook(playerName)
	local timestamp = getUnixTimestampUTC()
	local discordTimestamp = string.format("<t:%d:F>", timestamp)

	local data = {
		content = string.format("**%s** moved at %s", playerName, discordTimestamp)
	}

	local success, err = pcall(function()
		HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn("Failed to send webhook: " .. err)
	end
end

local function trackPlayer(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local lastPosition = hrp.Position

	while player and player.Parent do
		local currentPosition = hrp.Position
		local distance = (currentPosition - lastPosition).Magnitude

		if distance >= MIN_DISTANCE then
			sendWebhook(player.Name)
			lastPosition = currentPosition
			wait(0.5)
		end

		RunService.Heartbeat:Wait()
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		trackPlayer(player)
	end)
end)


-- WATCH YOUTUBE BEFORE COPY THIS
-- MADE BY DAI VIET
