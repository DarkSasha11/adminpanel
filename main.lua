-- titanz rework flx hub - TITANZ x SHADOWNOVA4567 EDITION
repeat task.wait() until game:IsLoaded()
task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not playerGui then return end

-- ══════════════════════════════════════════════════════════════
-- THEME & CONFIGURATION
-- ══════════════════════════════════════════════════════════════

local THEME = {
    DarkBg = Color3.fromRGB(15, 15, 20),
    CardBg = Color3.fromRGB(25, 25, 30),
    HeaderBg = Color3.fromRGB(30, 30, 35),
    AccentPurple = Color3.fromRGB(140, 0, 255),
    AccentWhite = Color3.fromRGB(240, 240, 240),
    AccentGreen = Color3.fromRGB(46, 204, 113),
    AccentRed = Color3.fromRGB(231, 76, 60),
    AccentOrange = Color3.fromRGB(243, 156, 18),
    AccentCyan = Color3.fromRGB(52, 152, 219),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    TextMuted = Color3.fromRGB(100, 100, 100),
    Border = Color3.fromRGB(60, 60, 60),
}

-- ══════════════════════════════════════════════════════════════
-- UI HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════

local function smoothTween(object, properties, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function addCorners(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or THEME.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.5
    stroke.Parent = parent
    return stroke
end

local function addGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, THEME.AccentPurple),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
    }
    gradient.Parent = parent
    return gradient
end

-- ══════════════════════════════════════════════════════════════
-- MAIN GUI CREATION
-- ══════════════════════════════════════════════════════════════

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "TitanZ_ShadowNova"
mainGui.Parent = playerGui
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function showNotification(text, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 250, 0, 40)
    notification.Position = UDim2.new(1, -260, 0, 20)
    notification.BackgroundColor3 = THEME.CardBg
    notification.Parent = mainGui
    addCorners(notification, 8)
    addStroke(notification, color or THEME.AccentPurple, 1.5)

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = 12
    notifText.TextColor3 = THEME.TextPrimary
    notifText.Parent = notification

    smoothTween(notification, {Position = UDim2.new(1, -260, 0, 20)}, 0.3) -- Entry

    task.delay(2.5, function()
        smoothTween(notification, {Position = UDim2.new(1, 10, 0, 20)}, 0.3) -- Exit
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- ══════════════════════════════════════════════════════════════
-- DRAGGABLE PANEL SYSTEM
-- ══════════════════════════════════════════════════════════════

local function createPanel(name, size, pos, title)
    local panel = Instance.new("Frame")
    panel.Name = name
    panel.Size = size
    panel.Position = pos
    panel.BackgroundColor3 = THEME.DarkBg
    panel.Parent = mainGui
    addCorners(panel, 8)
    addStroke(panel, THEME.AccentPurple, 2)
    
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 24)
    topBar.BackgroundColor3 = THEME.HeaderBg
    topBar.Parent = panel
    addCorners(topBar, 8)
    
    -- Fix corners for bottom of topbar
    local filler = Instance.new("Frame")
    filler.Size = UDim2.new(1, 0, 0, 5)
    filler.Position = UDim2.new(0, 0, 1, -5)
    filler.BackgroundColor3 = THEME.HeaderBg
    filler.BorderSizePixel = 0
    filler.Parent = topBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -60, 1, 0)
    titleLbl.Position = UDim2.new(0, 8, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11 -- Slightly smaller to fit long name
    titleLbl.TextColor3 = THEME.AccentWhite
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = topBar
    addGradient(titleLbl)

    -- Control Buttons Container (Symmetrical)
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 50, 1, 0)
    controls.Position = UDim2.new(1, -50, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = topBar
    
    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 4)
    controlLayout.Parent = controls
    
    local padding = Instance.new("UIPadding")
    padding.PaddingRight = UDim.new(0, 4)
    padding.Parent = controls

    local function createControlBtn(text, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 18, 0, 18)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextColor3 = THEME.TextPrimary
        btn.AutoButtonColor = false
        btn.Parent = controls
        addCorners(btn, 4)
        return btn
    end

    local minBtn = createControlBtn("—", THEME.AccentOrange)
    local closeBtn = createControlBtn("X", THEME.AccentRed)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -30)
    content.Position = UDim2.new(0, 5, 0, 28)
    content.BackgroundTransparency = 1
    content.Parent = panel

    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Toggle Logic
    local minimized = false
    local openSize = size
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            smoothTween(panel, {Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 24)}, 0.2)
            content.Visible = false
        else
            smoothTween(panel, {Size = openSize}, 0.2)
            content.Visible = true
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        panel.Visible = false
    end)

    return panel, content
end

-- ══════════════════════════════════════════════════════════════
-- PANELS SETUP
-- ══════════════════════════════════════════════════════════════

-- Admin Panel (Renamed)
local adminPanel, adminContent = createPanel(
    "AdminPanel", 
    UDim2.new(0, 260, 0, 320), -- Compact Size
    UDim2.new(0, 20, 0, 50), 
    "TitanZ x ShadowNova4567" -- NEW NAME
)

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 1, 0)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.ScrollBarImageColor3 = THEME.AccentPurple
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = adminContent

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = playerList

-- Cooldowns Panel
local cdPanel, cdContent = createPanel(
    "CDPanel", 
    UDim2.new(0, 200, 0, 120), 
    UDim2.new(1, -220, 0, 50), 
    "Cooldowns"
)

local cdGrid = Instance.new("ScrollingFrame")
cdGrid.Size = UDim2.new(1, 0, 1, 0)
cdGrid.BackgroundTransparency = 1
cdGrid.BorderSizePixel = 0
cdGrid.ScrollBarThickness = 2
cdGrid.Parent = cdContent

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.5, -4, 0, 20) -- 2 Columns
gridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
gridLayout.Parent = cdGrid

-- ══════════════════════════════════════════════════════════════
-- COMMAND LOGIC
-- ══════════════════════════════════════════════════════════════

local commandCooldowns = {
    rocket = 120, ragdoll = 30, balloon = 30, inverse = 60,
    nightvision = 60, jail = 60, tiny = 60, jumpscare = 60, morph = 60
}
local lastUses = {}

local function findRemote()
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d.Name:lower():find("executecommand") and d:IsA("RemoteEvent") then
            return d
        end
    end
end
local remote = findRemote()

local function isCooldown(cmd)
    local last = lastUses[cmd]
    if not last then return false end
    return (tick() - last) < (commandCooldowns[cmd] or 0)
end

local function execute(player, cmd)
    if not remote then remote = findRemote() end
    if not remote then return end
    
    if isCooldown(cmd) then return end
    
    local s, e = pcall(function() remote:FireServer(player, cmd) end)
    if s then
        lastUses[cmd] = tick()
    end
end

-- ══════════════════════════════════════════════════════════════
-- LIST POPULATION LOGIC (FIXED 8 SLOTS)
-- ══════════════════════════════════════════════════════════════

local function createSlot(index)
    local frame = Instance.new("Frame")
    frame.Name = "Slot_" .. index
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = THEME.CardBg
    frame.Parent = playerList
    addCorners(frame, 4)
    addStroke(frame, THEME.Border, 1)
    return frame
end

local function updatePlayerList()
    -- Clear current list
    for _, c in pairs(playerList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    -- Get players, Sort so LocalPlayer is first
    local plrs = Players:GetPlayers()
    table.sort(plrs, function(a, b)
        if a == LocalPlayer then return true end
        if b == LocalPlayer then return false end
        return a.Name < b.Name
    end)

    -- Create exactly 8 slots (or more if more players, but min 8)
    local totalSlots = math.max(8, #plrs)

    for i = 1, totalSlots do
        local slot = createSlot(i)
        local player = plrs[i]

        if player then
            -- PLAYER NAME
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0, 80, 1, 0)
            nameLbl.Position = UDim2.new(0, 5, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Font = Enum.Font.GothamSemibold
            nameLbl.TextSize = 10
            nameLbl.Parent = slot

            local btnsContainer = Instance.new("Frame")
            btnsContainer.Size = UDim2.new(1, -90, 1, -4)
            btnsContainer.Position = UDim2.new(0, 90, 0, 2)
            btnsContainer.BackgroundTransparency = 1
            btnsContainer.Parent = slot
            
            local btnLayout = Instance.new("UIListLayout")
            btnLayout.FillDirection = Enum.FillDirection.Horizontal
            btnLayout.Padding = UDim.new(0, 2)
            btnLayout.Parent = btnsContainer

            if player == LocalPlayer then
                -- YOURSELF ROW
                nameLbl.Text = "YOU (Self)"
                nameLbl.TextColor3 = THEME.AccentCyan
                slot.BackgroundColor3 = Color3.fromRGB(20, 30, 40) -- Slight blue tint
                
                -- Only Ragdoll Self button
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundColor3 = THEME.AccentPurple
                btn.Text = "RAGDOLL SELF"
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.TextColor3 = THEME.TextPrimary
                btn.Parent = btnsContainer
                addCorners(btn, 4)
                
                btn.MouseButton1Click:Connect(function()
                    execute(LocalPlayer, "ragdoll")
                end)
            else
                -- OTHER PLAYERS ROW
                nameLbl.Text = player.DisplayName
                nameLbl.TextColor3 = THEME.TextSecondary

                local cmds = {
                    {txt="J", col=THEME.AccentRed, cmd="jail"},
                    {txt="R", col=THEME.AccentPurple, cmd="ragdoll"},
                    {txt="RK", col=THEME.AccentOrange, cmd="rocket"},
                    {txt="B", col=THEME.AccentGreen, cmd="balloon"},
                    {txt="ALL", col=THEME.AccentCyan, cmd="ALL"} -- The ALL Button
                }

                for _, cInfo in ipairs(cmds) do
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(0, 28, 1, 0)
                    btn.BackgroundColor3 = cInfo.col
                    btn.Text = cInfo.txt
                    btn.Font = Enum.Font.GothamBold
                    btn.TextSize = 9
                    btn.TextColor3 = THEME.TextPrimary
                    btn.AutoButtonColor = false
                    btn.Parent = btnsContainer
                    addCorners(btn, 3)

                    btn.MouseButton1Click:Connect(function()
                        if cInfo.cmd == "ALL" then
                            -- Apply All Sequence
                            task.spawn(function()
                                execute(player, "jail") task.wait(0.1)
                                execute(player, "ragdoll") task.wait(0.1)
                                execute(player, "rocket") task.wait(0.1)
                                execute(player, "balloon")
                            end)
                            smoothTween(btn, {BackgroundTransparency = 0.5}, 0.1)
                            task.wait(0.2)
                            smoothTween(btn, {BackgroundTransparency = 0}, 0.1)
                        else
                            execute(player, cInfo.cmd)
                        end
                    end)
                end
            end
        else
            -- EMPTY SLOT
            slot.BackgroundTransparency = 0.8 -- Dimmed
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "-"
            lbl.TextColor3 = THEME.TextMuted
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.Parent = slot
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- ══════════════════════════════════════════════════════════════
-- COOLDOWN DISPLAY (GRID)
-- ══════════════════════════════════════════════════════════════

local cdLabels = {}

for name, dur in pairs(commandCooldowns) do
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = THEME.CardBg
    frame.Parent = cdGrid
    addCorners(frame, 4)

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name:sub(1,1):upper()..name:sub(2)
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 10
    txt.TextColor3 = THEME.AccentGreen
    txt.Parent = frame
    
    cdLabels[name] = txt
end

-- Update Loop
task.spawn(function()
    while true do
        for cmd, label in pairs(cdLabels) do
            local last = lastUses[cmd]
            if last and (tick() - last) < commandCooldowns[cmd] then
                local left = math.ceil(commandCooldowns[cmd] - (tick() - last))
                label.Text = cmd:sub(1,1):upper()..cmd:sub(2) .. ": " .. left
                label.TextColor3 = THEME.AccentRed
            else
                label.Text = cmd:sub(1,1):upper()..cmd:sub(2)
                label.TextColor3 = THEME.AccentGreen
            end
        end
        task.wait(0.5)
    end
end)

-- ══════════════════════════════════════════════════════════════
-- TOGGLE MENU BUTTON
-- ══════════════════════════════════════════════════════════════

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = THEME.DarkBg
toggleBtn.Text = "T"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = THEME.AccentPurple
toggleBtn.Parent = mainGui
addCorners(toggleBtn, 8)
addStroke(toggleBtn, THEME.AccentPurple, 2)

toggleBtn.MouseButton1Click:Connect(function()
    adminPanel.Visible = not adminPanel.Visible
    cdPanel.Visible = not cdPanel.Visible
end)

showNotification("TitanZ x ShadowNova4567 Loaded", THEME.AccentPurple)
