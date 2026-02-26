--[ Services & Safe Execution ]--
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SafeGuiParent = (gethui and gethui()) or (cloneref and cloneref(CoreGui)) or CoreGui

if SafeGuiParent:FindFirstChild("SwiftHub") then
    SafeGuiParent.SwiftHub:Destroy()
end
if SafeGuiParent:FindFirstChild("InstantStealUI") then
    SafeGuiParent.InstantStealUI:Destroy()
end
if SafeGuiParent:FindFirstChild("FloatingDiscordLabel") then
    SafeGuiParent.FloatingDiscordLabel:Destroy()
end

--[ Constants ]--
local DISCORD_LINK = "Лорна уебище"
local PROFILE_PIC = "https://www.roblox.com/headshot-thumbnail/image?userId=1&width=48&height=48&format=png"
local ACTIVE_COLOR = Color3.fromRGB(0, 200, 100)
local INACTIVE_COLOR = Color3.fromRGB(30, 30, 40)

--[ Dragging Utility ]--
local function MakeDraggable(dragArea, moveTarget)
    local dragging = false
    local dragInput, mousePos, framePos

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = moveTarget.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            moveTarget.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X, 
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

--[ 1. Main GUI Construction (SwiftHub) ]--
local SwiftHub = Instance.new("ScreenGui")
SwiftHub.Name = "SkidHyb"
SwiftHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SwiftHub.Parent = SafeGuiParent

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(0, 443, 0, 285)
Container.Position = UDim2.new(0.5, -221, 0.5, -142)
Container.BackgroundTransparency = 1
Container.Parent = SwiftHub
MakeDraggable(Container, Container) -- Make the whole hub draggable

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Container
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Name = "SidebarStroke"
SidebarStroke.Thickness = 2
SidebarStroke.Color = Color3.fromRGB(255, 255, 255)
SidebarStroke.Parent = Sidebar

local RainbowGradient = Instance.new("UIGradient")
RainbowGradient.Name = "RainbowGradient"
RainbowGradient.Parent = SidebarStroke

local SidebarHeader = Instance.new("Frame")
SidebarHeader.Name = "SidebarHeader"
SidebarHeader.Size = UDim2.new(1, 0, 0, 46)
SidebarHeader.BackgroundTransparency = 1
SidebarHeader.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -10, 0, 20)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = ".gg/bbN8Uk6JRb"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = SidebarHeader

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -10, 0, 14)
Subtitle.Position = UDim2.new(0, 8, 0, 26)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = DISCORD_LINK
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = SidebarHeader

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -16, 0, 1)
Divider.Position = UDim2.new(0, 8, 1, 0)
Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Divider.BorderSizePixel = 0
Divider.Parent = SidebarHeader

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -16, 1, -106)
TabContainer.Position = UDim2.new(0, 8, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.BorderSizePixel = 0
TabContainer.Parent = Sidebar
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

local TabButton = Instance.new("TextButton")
TabButton.Name = "Instant Steal V2Tab"
TabButton.Size = UDim2.new(1, 0, 0, 30)
TabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TabButton.BackgroundTransparency = 0.65
TabButton.Text = ""
TabButton.Parent = TabContainer
Instance.new("UICorner", TabButton)
Instance.new("UIStroke", TabButton).Color = Color3.fromRGB(50, 50, 60)

local Glow = Instance.new("Frame")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, -2, 1, -2)
Glow.Position = UDim2.new(0, 1, 0, 1)
Glow.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Glow.ZIndex = 2
Glow.Parent = TabButton
Instance.new("UICorner", Glow)
local GlowGrad = Instance.new("UIGradient", Glow)
GlowGrad.Rotation = 90
GlowGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85), NumberSequenceKeypoint.new(1, 1)})

local Accent = Instance.new("Frame")
Accent.Name = "Accent"
Accent.Size = UDim2.new(0, 3, 1, -10)
Accent.Position = UDim2.new(0, 7, 0, 5)
Accent.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Accent.ZIndex = 3
Accent.Parent = TabButton
Instance.new("UICorner", Accent)

local TabLabel = Instance.new("TextLabel")
TabLabel.Name = "Label"
TabLabel.Size = UDim2.new(1, -20, 1, 0)
TabLabel.Position = UDim2.new(0, 20, 0, 0)
TabLabel.BackgroundTransparency = 1
TabLabel.Text = "Instant Steal V2"
TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabel.TextSize = 12
TabLabel.Font = Enum.Font.GothamMedium
TabLabel.TextXAlignment = Enum.TextXAlignment.Left
TabLabel.ZIndex = 4
TabLabel.Parent = TabButton

local Footer = Instance.new("Frame")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 52)
Footer.Position = UDim2.new(0, 0, 1, -52)
Footer.BackgroundTransparency = 1
Footer.Parent = Sidebar

local ProfilePic = Instance.new("ImageLabel")
ProfilePic.Size = UDim2.new(0, 26, 0, 26)
ProfilePic.Position = UDim2.new(0, 8, 0, 12)
ProfilePic.Image = PROFILE_PIC
ProfilePic.Parent = Footer
Instance.new("UICorner", ProfilePic).CornerRadius = UDim.new(0, 4)

local UserName = Instance.new("TextLabel")
UserName.Size = UDim2.new(1, -38, 0, 13)
UserName.Position = UDim2.new(0, 38, 0, 12)
UserName.BackgroundTransparency = 1
UserName.Text = "leaked by twocando"
UserName.TextColor3 = Color3.fromRGB(240, 240, 240)
UserName.TextSize = 11
UserName.Font = Enum.Font.GothamMedium
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Parent = Footer

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 285, 1, 0)
MainFrame.Position = UDim2.new(0, 158, 0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Parent = Container
Instance.new("UICorner", MainFrame)

local TabFrameContainer = Instance.new("Frame")
TabFrameContainer.Name = "TabFrameContainer"
TabFrameContainer.Size = UDim2.new(1, -16, 1, -16)
TabFrameContainer.Position = UDim2.new(0, 8, 0, 8)
TabFrameContainer.BackgroundTransparency = 1
TabFrameContainer.Parent = MainFrame

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "Instant Steal V2Frame"
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.ScrollBarThickness = 3
ContentScroll.Parent = TabFrameContainer
Instance.new("UIListLayout", ContentScroll).Padding = UDim.new(0, 8)

--[ 2. Controls Factory (Toggles & Sliders) ]--
local function CreateToggle(name, titleText, subText, toggledState)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
    ToggleFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -46, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -46, 0, 13)
    SubLabel.Position = UDim2.new(0, 0, 0, 19)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = subText
    SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubLabel.TextSize = 10
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 36, 0, 18)
    Button.Position = UDim2.new(1, -40, 0, 8)
    Button.BackgroundColor3 = toggledState and ACTIVE_COLOR or INACTIVE_COLOR
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = ToggleFrame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = toggledState and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
    Dot.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    Dot.Parent = Button
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    -- Animation Logic
    local state = toggledState
    Button.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        TweenService:Create(Button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = state and ACTIVE_COLOR or INACTIVE_COLOR
        }):Play()
    end)
    
    ToggleFrame.Parent = ContentScroll
end

CreateToggle("Toggle Desync", "Toggle Desync", "Performs desync and maintains fflags", true)
CreateToggle("Enable", "Enable", "Instant Steal with Instant Grab", false)
CreateToggle("Use Potion on Steal", "Use Potion on Steal", "Activates Giant Potion during steal", false)
CreateToggle("Auto Teleport (Timer)", "Auto Teleport (Timer)", "Auto teleport when timer hits 1 second", false)
CreateToggle("Enable Ping Compensation", "Enable Ping Compensation", "Apply delay before teleport based on ping", false)

-- Slider for Ping Offset
local PingOffsetFrame = Instance.new("Frame")
PingOffsetFrame.Name = "PingOffsetFrame"
PingOffsetFrame.Size = UDim2.new(1, 0, 0, 42)
PingOffsetFrame.BackgroundTransparency = 1
PingOffsetFrame.Parent = ContentScroll

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, -52, 0, 16)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Manual Offset (μs)"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.TextSize = 13
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = PingOffsetFrame

local SliderValue = Instance.new("TextLabel")
SliderValue.Size = UDim2.new(0, 52, 0, 16)
SliderValue.Position = UDim2.new(1, -52, 0, 0)
SliderValue.BackgroundTransparency = 1
SliderValue.Text = "0"
SliderValue.TextColor3 = Color3.fromRGB(0, 170, 255)
SliderValue.Font = Enum.Font.GothamBold
SliderValue.TextSize = 13
SliderValue.TextXAlignment = Enum.TextXAlignment.Right
SliderValue.Parent = PingOffsetFrame

local Bar = Instance.new("TextButton")
Bar.Name = "Bar"
Bar.Size = UDim2.new(1, 0, 0, 6)
Bar.Position = UDim2.new(0, 0, 0, 24)
Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Bar.Text = ""
Bar.Parent = PingOffsetFrame
Instance.new("UICorner", Bar)

local Fill = Instance.new("Frame")
Fill.Name = "Fill"
Fill.Size = UDim2.new(0.5, 0, 1, 0) -- 50% default
Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Fill.Parent = Bar
Instance.new("UICorner", Fill)

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 14, 0, 14)
Dot.Position = UDim2.new(1, -7, 0.5, -7)
Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Dot.Parent = Fill
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

-- Slider Drag Logic
local draggingSlider = false
Bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = Bar.AbsolutePosition.X
        local barSize = Bar.AbsoluteSize.X
        local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        SliderValue.Text = tostring(math.floor(percent * 1000)) -- 0 to 1000 range
    end
end)

--[ 3. Instant Steal UI (Teleport Helper Popup) ]--
local InstantStealUI = Instance.new("ScreenGui")
InstantStealUI.Name = "InstantStealUI"
InstantStealUI.Parent = SafeGuiParent

local ISMainFrame = Instance.new("Frame")
ISMainFrame.Name = "MainFrame"
ISMainFrame.Size = UDim2.new(0, 220, 0, 108)
ISMainFrame.Position = UDim2.new(0.5, 200, 0.5, -54) -- Offset slightly
ISMainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ISMainFrame.Parent = InstantStealUI
Instance.new("UICorner", ISMainFrame)
local ISStroke = Instance.new("UIStroke", ISMainFrame)
ISStroke.Color = Color3.fromRGB(255, 255, 255)
local ISRainbowGrad = Instance.new("UIGradient", ISStroke)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = ISMainFrame
MakeDraggable(TitleBar, ISMainFrame) -- Make mini UI draggable via Title

local ISTitle = Instance.new("TextLabel", TitleBar)
ISTitle.Size = UDim2.new(1, -26, 0, 16)
ISTitle.Position = UDim2.new(0, 8, 0, 3)
ISTitle.BackgroundTransparency = 1
ISTitle.Text = "Instant Steal TP"
ISTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ISTitle.Font = Enum.Font.GothamBold
ISTitle.TextSize = 13
ISTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 16, 0, 16)
CloseBtn.Position = UDim2.new(1, -24, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()
    InstantStealUI:Destroy()
end)

local ContentArea = Instance.new("Frame", ISMainFrame)
ContentArea.Size = UDim2.new(1, -16, 1, -48)
ContentArea.Position = UDim2.new(0, 8, 0, 40)
ContentArea.BackgroundTransparency = 1

local DropdownBtn = Instance.new("TextButton", ContentArea)
DropdownBtn.Size = UDim2.new(1, 0, 0, 26)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DropdownBtn.Text = "Select Podium ▼"
DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownBtn.Font = Enum.Font.GothamMedium
DropdownBtn.TextSize = 11
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

local TeleportBtn = Instance.new("TextButton", ContentArea)
TeleportBtn.Size = UDim2.new(1, 0, 0, 28)
TeleportBtn.Position = UDim2.new(0, 0, 0, 32)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
TeleportBtn.Text = "Teleport"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextSize = 12
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)

--[ 4. Floating Discord Label ]--
local FloatingDiscordLabel = Instance.new("ScreenGui")
FloatingDiscordLabel.Name = "FloatingDiscordLabel"
FloatingDiscordLabel.Parent = SafeGuiParent

local LabelFrame = Instance.new("Frame")
LabelFrame.Name = "LabelFrame"
LabelFrame.Size = UDim2.new(0, 240, 0, 40)
LabelFrame.Position = UDim2.new(0.5, -120, 0, 10)
LabelFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
LabelFrame.Parent = FloatingDiscordLabel
Instance.new("UICorner", LabelFrame).CornerRadius = UDim.new(0, 10)
local LblStroke = Instance.new("UIStroke", LabelFrame)
LblStroke.Thickness = 2.5
LblStroke.Color = Color3.fromRGB(255, 255, 255)
local LblGrad = Instance.new("UIGradient", LblStroke)

local LblText = Instance.new("TextLabel", LabelFrame)
LblText.Size = UDim2.new(1, -10, 1, 0)
LblText.Position = UDim2.new(0, 5, 0, 0)
LblText.BackgroundTransparency = 1
LblText.Text = "Discord: " .. DISCORD_LINK
LblText.TextColor3 = Color3.fromRGB(255, 255, 255)
LblText.Font = Enum.Font.GothamBold
LblText.TextSize = 14

--[ 5. Rainbow Animation Loop ]--
local hue = 0
RunService.RenderStepped:Connect(function(deltaTime)
    hue = hue + (deltaTime * 0.15)
    if hue > 1 then hue = 0 end
    
    local c1 = Color3.fromHSV(hue, 1, 1)
    local c2 = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
    local seq = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    })
    
    if RainbowGradient then RainbowGradient.Color = seq end
    if ISRainbowGrad then ISRainbowGrad.Color = seq end
    if LblGrad then LblGrad.Color = seq end
end)
