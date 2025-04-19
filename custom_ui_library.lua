-- Custom Dark Theme UI Library
-- Created based on analysis of multiple Roblox UI libraries
-- Features dark theme with colors #373a56 and #7e23bd

local CustomUILib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- Utility Functions
local function fromRGB(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local function fromHex(hex)
    hex = hex:gsub("#", "")
    local r = tonumber("0x" .. hex:sub(1, 2))
    local g = tonumber("0x" .. hex:sub(3, 4))
    local b = tonumber("0x" .. hex:sub(5, 6))
    return Color3.fromRGB(r, g, b)
end

-- Theme Definition
CustomUILib.Theme = {
    -- Primary Colors
    BackgroundPrimary = fromHex("#373a56"),  -- RGB: 55, 58, 86
    AccentPrimary = fromHex("#7e23bd"),      -- RGB: 126, 35, 189
    
    -- Secondary Colors
    BackgroundSecondary = fromHex("#2a2c42"), -- RGB: 42, 44, 66
    BackgroundTertiary = fromHex("#444869"),  -- RGB: 68, 72, 105
    AccentSecondary = fromHex("#9442d1"),     -- RGB: 148, 66, 209
    AccentTertiary = fromHex("#68189e"),      -- RGB: 104, 24, 158
    
    -- Text Colors
    TextPrimary = fromHex("#ffffff"),         -- RGB: 255, 255, 255
    TextSecondary = fromHex("#b8b9c7"),       -- RGB: 184, 185, 199
    TextDisabled = fromHex("#6a6d89"),        -- RGB: 106, 109, 137
    
    -- Border Colors
    BorderPrimary = fromHex("#2a2c42"),       -- RGB: 42, 44, 66
    BorderSecondary = fromHex("#444869"),     -- RGB: 68, 72, 105
    BorderAccent = fromHex("#7e23bd"),        -- RGB: 126, 35, 189
    
    -- Status Colors
    Success = fromHex("#43b581"),             -- RGB: 67, 181, 129
    Warning = fromHex("#faa61a"),             -- RGB: 250, 166, 26
    Error = fromHex("#f04747"),               -- RGB: 240, 71, 71
    Info = fromHex("#7289da"),                -- RGB: 114, 137, 218
    
    -- Font Settings
    Font = Enum.Font.Gotham,
    FontSizeHeader = 18,
    FontSizeSubheader = 16,
    FontSizeBody = 14,
    FontSizeSmall = 12,
    
    -- Z-Index Order
    ZIndexOrder = {
        Window = 1000,
        Dropdown = 1200,
        ColorPicker = 1100,
        Notification = 1400,
        Tooltip = 1300,
        Modal = 1500
    }
}

-- Library Structure
CustomUILib.Windows = {}
CustomUILib.Connections = {}
CustomUILib.Drawings = {}
CustomUILib.Notifications = {}
CustomUILib.Flags = {}
CustomUILib.Options = {}

-- Make GUI Draggable Function
function CustomUILib.MakeDraggable(topbar, object)
    local Dragging = false
    local DragInput, MousePos, FramePos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = input.Position
            FramePos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - MousePos
            object.Position = UDim2.new(
                FramePos.X.Scale, 
                FramePos.X.Offset + Delta.X, 
                FramePos.Y.Scale, 
                FramePos.Y.Offset + Delta.Y
            )
        end
    end)
end

-- Create Window Function
function CustomUILib:CreateWindow(title)
    local Window = {}
    
    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = self.Theme.BackgroundPrimary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = game.CoreGui
    
    -- Add Corner Radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame
    
    -- Window Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = self.Theme.ZIndexOrder.Window - 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = MainFrame
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = self.Theme.BackgroundSecondary
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    -- Topbar Corner Radius
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 6)
    TopbarCorner.Parent = Topbar
    
    -- Fix Corner Radius for Topbar
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Name = "TopbarFix"
    TopbarFix.Size = UDim2.new(1, 0, 0.5, 0)
    TopbarFix.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarFix.BackgroundColor3 = self.Theme.BackgroundSecondary
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = Topbar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = self.Theme.TextPrimary
    Title.TextSize = self.Theme.FontSizeHeader
    Title.Font = self.Theme.Font
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseButton"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = self.Theme.Error
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = self.Theme.TextPrimary
    CloseBtn.TextSize = self.Theme.FontSizeBody
    CloseBtn.Font = self.Theme.Font
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Topbar
    
    -- Close Button Corner Radius
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 4)
    CloseBtnCorner.Parent = CloseBtn
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -40)
    ContentContainer.Position = UDim2.new(0, 0, 0, 40)
    ContentContainer.BackgroundColor3 = self.Theme.BackgroundPrimary
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(0, 150, 1, 0)
    TabsContainer.BackgroundColor3 = self.Theme.BackgroundSecondary
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Parent = ContentContainer
    
    -- Tabs Container Corner Radius
    local TabsContainerCorner = Instance.new("UICorner")
    TabsContainerCorner.CornerRadius = UDim.new(0, 6)
    TabsContainerCorner.Parent = TabsContainer
    
    -- Fix Corner Radius for Tabs Container
    local TabsContainerFix = Instance.new("Frame")
    TabsContainerFix.Name = "TabsContainerFix"
    TabsContainerFix.Size = UDim2.new(0.5, 0, 1, 0)
    TabsContainerFix.Position = UDim2.new(0.5, 0, 0, 0)
    TabsContainerFix.BackgroundColor3 = self.Theme.BackgroundSecondary
    TabsContainerFix.BorderSizePixel = 0
    TabsContainerFix.Parent = TabsContainer
    
    -- Tabs List
    local TabsList = Instance.new("ScrollingFrame")
    TabsList.Name = "TabsList"
    TabsList.Size = UDim2.new(1, 0, 1, 0)
    TabsList.BackgroundTransparency = 1
    TabsList.BorderSizePixel = 0
    TabsList.ScrollBarThickness = 2
    TabsList.ScrollBarImageColor3 = self.Theme.AccentPrimary
    TabsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsList.Parent = TabsContainer
    
    -- Tabs List Layout
    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 5)
    TabsListLayout.Parent = TabsList
    
    -- Tabs List Padding
    local TabsListPadding = Instance.new("UIPadding")
    TabsListPadding.PaddingTop = UDim.new(0, 10)
    TabsListPadding.PaddingLeft = UDim.new(0, 10)
    TabsListPadding.PaddingRight = UDim.new(0, 10)
    TabsListPadding.Parent = TabsList
    
    -- Tab Content Container
    local TabContentContainer = Instance.new("Frame")
    TabContentContainer.Name = "TabContentContainer"
    TabContentContainer.Size = UDim2.new(1, -150, 1, 0)
    TabContentContainer.Position = UDim2.new(0, 150, 0, 0)
    TabContentContainer.BackgroundTransparency = 1
    TabContentContainer.BorderSizePixel = 0
    TabContentContainer.Parent = ContentContainer
    
    -- Make Window Draggable
    self.MakeDraggable(Topbar, MainFrame)
    
    -- Close Button Functionality
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = fromRGB(255, 100, 100)}):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Error}):Play()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame:Destroy()
    end)
    
    -- Tabs System
    local Tabs = {}
    local SelectedTab = nil
    
    function Window:AddTab(name, icon)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = self.Theme.BackgroundSecondary
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsList
        
        -- Tab Button Corner Radius
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Icon (if provided)
        if icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "Icon"
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = icon
            TabIcon.Parent = TabButton
            
            -- Tab Name (with icon)
            local TabName = Instance.new("TextLabel")
            TabName.Name = "Name"
            TabName.Size = UDim2.new(1, -50, 1, 0)
            TabName.Position = UDim2.new(0, 40, 0, 0)
            TabName.BackgroundTransparency = 1
            TabName.Text = name
            TabName.TextColor3 = self.Theme.TextSecondary
            TabName.TextSize = self.Theme.FontSizeBody
            TabName.Font = self.Theme.Font
            TabName.TextXAlignment = Enum.TextXAlignment.Left
            TabName.Parent = TabButton
        else
            -- Tab Name (without icon)
            local TabName = Instance.new("TextLabel")
            TabName.Name = "Name"
            TabName.Size = UDim2.new(1, -20, 1, 0)
            TabName.Position = UDim2.new(0, 10, 0, 0)
            TabName.BackgroundTransparency = 1
            TabName.Text = name
            TabName.TextColor3 = self.Theme.TextSecondary
            TabName.TextSize = self.Theme.FontSizeBody
            TabName.Font = self.Theme.Font
            TabName.TextXAlignment = Enum.TextXAlignment.Left
            TabName.Parent = TabButton
        end
        
        -- Tab Selection Indicator
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 3, 0.7, 0)
        TabIndicator.Position = UDim2.new(0, 0, 0.15, 0)
        TabIndicator.BackgroundColor3 = self.Theme.AccentPrimary
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabButton
        
        -- Tab Content Frame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = self.Theme.AccentPrimary
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.Parent = TabContentContainer
        
        -- Tab Content Layout
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 10)
        TabContentLayout.Parent = TabContent
        
        -- Tab Content Padding
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingTop = UDim.new(0, 15)
        TabContentPadding.PaddingLeft = UDim.new(0, 15)
        TabContentPadding.PaddingRight = UDim.new(0, 15)
        TabContentPadding.PaddingBottom = UDim.new(0, 15)
        TabContentPadding.Parent = TabContent
        
        -- Tab Button Functionality
        TabButton.MouseEnter:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundTertiary}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundSecondary}):Play()
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            -- Deselect current tab
            if SelectedTab then
                local prevTabButton = SelectedTab.TabButton
                local prevTabContent = SelectedTab.TabContent
                local prevTabIndicator = prevTabButton.Indicator
                local prevTabName = prevTabButton:FindFirstChild("Name")
                
                TweenService:Create(prevTabButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundSecondary}):Play()
                TweenService:Create(prevTabName, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextSecondary}):Play()
                prevTabIndicator.Visible = false
                prevTabContent.Visible = false
            end
            
            -- Select new tab
            SelectedTab = Tab
            local tabName = TabButton:FindFirstChild("Name")
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentPrimary}):Play()
            TweenService:Create(tabName, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextPrimary}):Play()
            TabIndicator.Visible = true
            TabContent.Visible = true
        end)
        
        -- Store tab references
        Tab.TabButton = TabButton
        Tab.TabContent = TabContent
        Tab.Name = name
        
        -- Add to tabs table
        table.insert(Tabs, Tab)
        
        -- Select first tab by default
        if #Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Section Creation Function
        function Tab:AddSection(sectionName)
            local Section = {}
            
            -- Section Container
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = sectionName .. "Section"
            SectionContainer.Size = UDim2.new(1, 0, 0, 40) -- Will be automatically resized
            SectionContainer.BackgroundColor3 = self.Theme.BackgroundSecondary
            SectionContainer.BorderSizePixel = 0
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
            SectionContainer.Parent = TabContent
            
            -- Section Container Corner Radius
            local SectionContainerCorner = Instance.new("UICorner")
            SectionContainerCorner.CornerRadius = UDim.new(0, 6)
            SectionContainerCorner.Parent = SectionContainer
            
            -- Section Header
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 40)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.BorderSizePixel = 0
            SectionHeader.Parent = SectionContainer
            
            -- Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = self.Theme.TextPrimary
            SectionTitle.TextSize = self.Theme.FontSizeSubheader
            SectionTitle.Font = self.Theme.Font
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader
            
            -- Section Content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Position = UDim2.new(0, 0, 0, 40)
            SectionContent.BackgroundTransparency = 1
            SectionContent.BorderSizePixel = 0
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.Parent = SectionContainer
            
            -- Section Content Layout
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Padding = UDim.new(0, 8)
            SectionContentLayout.Parent = SectionContent
            
            -- Section Content Padding
            local SectionContentPadding = Instance.new("UIPadding")
            SectionContentPadding.PaddingLeft = UDim.new(0, 10)
            SectionContentPadding.PaddingRight = UDim.new(0, 10)
            SectionContentPadding.PaddingBottom = UDim.new(0, 10)
            SectionContentPadding.Parent = SectionContent
            
            -- Button Creation Function
            function Section:AddButton(buttonText, callback)
                callback = callback or function() end
                
                -- Button Container
                local ButtonContainer = Instance.new("Frame")
                ButtonContainer.Name = buttonText .. "Button"
                ButtonContainer.Size = UDim2.new(1, 0, 0, 35)
                ButtonContainer.BackgroundTransparency = 1
                ButtonContainer.BorderSizePixel = 0
                ButtonContainer.Parent = SectionContent
                
                -- Button
                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.BackgroundColor3 = self.Theme.AccentPrimary
                Button.BorderSizePixel = 0
                Button.Text = buttonText
                Button.TextColor3 = self.Theme.TextPrimary
                Button.TextSize = self.Theme.FontSizeBody
                Button.Font = self.Theme.Font
                Button.AutoButtonColor = false
                Button.Parent = ButtonContainer
                
                -- Button Corner Radius
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                -- Button Functionality
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentSecondary}):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentPrimary}):Play()
                end)
                
                Button.MouseButton1Down:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.AccentTertiary, Size = UDim2.new(0.98, 0, 0.98, 0), Position = UDim2.new(0.01, 0, 0.01, 0)}):Play()
                end)
                
                Button.MouseButton1Up:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.AccentSecondary, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                return Button
            end
            
            -- Toggle Creation Function
            function Section:AddToggle(toggleText, default, callback)
                default = default or false
                callback = callback or function() end
                
                -- Toggle Container
                local ToggleContainer = Instance.new("Frame")
                ToggleContainer.Name = toggleText .. "Toggle"
                ToggleContainer.Size = UDim2.new(1, 0, 0, 35)
                ToggleContainer.BackgroundTransparency = 1
                ToggleContainer.BorderSizePixel = 0
                ToggleContainer.Parent = SectionContent
                
                -- Toggle Label
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleText
                ToggleLabel.TextColor3 = self.Theme.TextPrimary
                ToggleLabel.TextSize = self.Theme.FontSizeBody
                ToggleLabel.Font = self.Theme.Font
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleContainer
                
                -- Toggle Background
                local ToggleBackground = Instance.new("Frame")
                ToggleBackground.Name = "Background"
                ToggleBackground.Size = UDim2.new(0, 50, 0, 25)
                ToggleBackground.Position = UDim2.new(1, -50, 0.5, -12.5)
                ToggleBackground.BackgroundColor3 = self.Theme.BackgroundTertiary
                ToggleBackground.BorderSizePixel = 0
                ToggleBackground.Parent = ToggleContainer
                
                -- Toggle Background Corner Radius
                local ToggleBackgroundCorner = Instance.new("UICorner")
                ToggleBackgroundCorner.CornerRadius = UDim.new(0, 12.5)
                ToggleBackgroundCorner.Parent = ToggleBackground
                
                -- Toggle Handle
                local ToggleHandle = Instance.new("Frame")
                ToggleHandle.Name = "Handle"
                ToggleHandle.Size = UDim2.new(0, 21, 0, 21)
                ToggleHandle.Position = UDim2.new(0, 2, 0.5, -10.5)
                ToggleHandle.BackgroundColor3 = self.Theme.TextPrimary
                ToggleHandle.BorderSizePixel = 0
                ToggleHandle.Parent = ToggleBackground
                
                -- Toggle Handle Corner Radius
                local ToggleHandleCorner = Instance.new("UICorner")
                ToggleHandleCorner.CornerRadius = UDim.new(0, 10.5)
                ToggleHandleCorner.Parent = ToggleHandle
                
                -- Toggle Button (invisible button for interaction)
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleContainer
                
                -- Toggle State
                local Toggled = default
                
                -- Update Toggle Appearance
                local function UpdateToggle()
                    if Toggled then
                        TweenService:Create(ToggleBackground, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentPrimary}):Play()
                        TweenService:Create(ToggleHandle, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0.5, -10.5)}):Play()
                    else
                        TweenService:Create(ToggleBackground, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundTertiary}):Play()
                        TweenService:Create(ToggleHandle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10.5)}):Play()
                    end
                    
                    callback(Toggled)
                end
                
                -- Set initial state
                UpdateToggle()
                
                -- Toggle Functionality
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                end)
                
                -- Toggle API
                local ToggleAPI = {}
                
                function ToggleAPI:Set(value)
                    Toggled = value
                    UpdateToggle()
                end
                
                function ToggleAPI:Get()
                    return Toggled
                end
                
                return ToggleAPI
            end
            
            -- Slider Creation Function
            function Section:AddSlider(sliderText, min, max, default, increment, callback)
                min = min or 0
                max = max or 100
                default = default or min
                increment = increment or 1
                callback = callback or function() end
                
                -- Clamp default value
                default = math.clamp(default, min, max)
                
                -- Slider Container
                local SliderContainer = Instance.new("Frame")
                SliderContainer.Name = sliderText .. "Slider"
                SliderContainer.Size = UDim2.new(1, 0, 0, 55)
                SliderContainer.BackgroundTransparency = 1
                SliderContainer.BorderSizePixel = 0
                SliderContainer.Parent = SectionContent
                
                -- Slider Label
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(1, 0, 0, 25)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderText
                SliderLabel.TextColor3 = self.Theme.TextPrimary
                SliderLabel.TextSize = self.Theme.FontSizeBody
                SliderLabel.Font = self.Theme.Font
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderContainer
                
                -- Slider Value
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.Size = UDim2.new(0, 50, 0, 25)
                SliderValue.Position = UDim2.new(1, -50, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = self.Theme.TextSecondary
                SliderValue.TextSize = self.Theme.FontSizeBody
                SliderValue.Font = self.Theme.Font
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderContainer
                
                -- Slider Background
                local SliderBackground = Instance.new("Frame")
                SliderBackground.Name = "Background"
                SliderBackground.Size = UDim2.new(1, 0, 0, 10)
                SliderBackground.Position = UDim2.new(0, 0, 0, 35)
                SliderBackground.BackgroundColor3 = self.Theme.BackgroundTertiary
                SliderBackground.BorderSizePixel = 0
                SliderBackground.Parent = SliderContainer
                
                -- Slider Background Corner Radius
                local SliderBackgroundCorner = Instance.new("UICorner")
                SliderBackgroundCorner.CornerRadius = UDim.new(0, 5)
                SliderBackgroundCorner.Parent = SliderBackground
                
                -- Slider Fill
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = self.Theme.AccentPrimary
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBackground
                
                -- Slider Fill Corner Radius
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 5)
                SliderFillCorner.Parent = SliderFill
                
                -- Slider Handle
                local SliderHandle = Instance.new("Frame")
                SliderHandle.Name = "Handle"
                SliderHandle.Size = UDim2.new(0, 16, 0, 16)
                SliderHandle.Position = UDim2.new(0, 0, 0.5, -8)
                SliderHandle.BackgroundColor3 = self.Theme.TextPrimary
                SliderHandle.BorderSizePixel = 0
                SliderHandle.ZIndex = 2
                SliderHandle.Parent = SliderFill
                
                -- Slider Handle Corner Radius
                local SliderHandleCorner = Instance.new("UICorner")
                SliderHandleCorner.CornerRadius = UDim.new(0, 8)
                SliderHandleCorner.Parent = SliderHandle
                
                -- Slider Button (invisible button for interaction)
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "Button"
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Position = UDim2.new(0, 0, 0, 0)
                SliderButton.BackgroundTransparency = 1
                SliderButton.Text = ""
                SliderButton.Parent = SliderBackground
                
                -- Slider Variables
                local Dragging = false
                local Value = default
                
                -- Update Slider Appearance
                local function UpdateSlider(value)
                    -- Calculate percentage
                    local percent = (value - min) / (max - min)
                    
                    -- Update fill and handle position
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    
                    -- Update value text
                    SliderValue.Text = tostring(value)
                    
                    -- Call callback
                    callback(value)
                end
                
                -- Set initial value
                UpdateSlider(default)
                
                -- Slider Functionality
                SliderButton.MouseButton1Down:Connect(function()
                    Dragging = true
                    
                    -- Change handle color
                    TweenService:Create(SliderHandle, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentSecondary}):Play()
                    
                    -- Update slider based on mouse position
                    local function Update()
                        if not Dragging then return end
                        
                        -- Get mouse position relative to slider
                        local MousePos = UserInputService:GetMouseLocation()
                        local RelativePos = (MousePos.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X
                        RelativePos = math.clamp(RelativePos, 0, 1)
                        
                        -- Calculate value based on position
                        local NewValue = min + ((max - min) * RelativePos)
                        
                        -- Apply increment
                        NewValue = math.floor(NewValue / increment + 0.5) * increment
                        
                        -- Update if value changed
                        if NewValue ~= Value then
                            Value = NewValue
                            UpdateSlider(Value)
                        end
                    end
                    
                    -- Initial update
                    Update()
                    
                    -- Connect to mouse movement
                    local MoveConnection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            Update()
                        end
                    end)
                    
                    -- Handle mouse release
                    local ReleaseConnection
                    ReleaseConnection = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                            
                            -- Restore handle color
                            TweenService:Create(SliderHandle, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.TextPrimary}):Play()
                            
                            -- Disconnect events
                            MoveConnection:Disconnect()
                            ReleaseConnection:Disconnect()
                        end
                    end)
                end)
                
                -- Slider API
                local SliderAPI = {}
                
                function SliderAPI:Set(value)
                    value = math.clamp(value, min, max)
                    Value = value
                    UpdateSlider(value)
                end
                
                function SliderAPI:Get()
                    return Value
                end
                
                return SliderAPI
            end
            
            -- Dropdown Creation Function
            function Section:AddDropdown(dropdownText, options, default, callback)
                options = options or {}
                default = default or options[1]
                callback = callback or function() end
                
                -- Dropdown Container
                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = dropdownText .. "Dropdown"
                DropdownContainer.Size = UDim2.new(1, 0, 0, 40)
                DropdownContainer.BackgroundTransparency = 1
                DropdownContainer.BorderSizePixel = 0
                DropdownContainer.Parent = SectionContent
                
                -- Dropdown Label
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = dropdownText
                DropdownLabel.TextColor3 = self.Theme.TextPrimary
                DropdownLabel.TextSize = self.Theme.FontSizeBody
                DropdownLabel.Font = self.Theme.Font
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownContainer
                
                -- Dropdown Button
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Size = UDim2.new(1, 0, 0, 30)
                DropdownButton.Position = UDim2.new(0, 0, 0, 20)
                DropdownButton.BackgroundColor3 = self.Theme.BackgroundTertiary
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = default or "Select..."
                DropdownButton.TextColor3 = self.Theme.TextPrimary
                DropdownButton.TextSize = self.Theme.FontSizeBody
                DropdownButton.Font = self.Theme.Font
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = DropdownContainer
                
                -- Dropdown Button Padding
                local DropdownButtonPadding = Instance.new("UIPadding")
                DropdownButtonPadding.PaddingLeft = UDim.new(0, 10)
                DropdownButtonPadding.Parent = DropdownButton
                
                -- Dropdown Button Corner Radius
                local DropdownButtonCorner = Instance.new("UICorner")
                DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
                DropdownButtonCorner.Parent = DropdownButton
                
                -- Dropdown Arrow
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "Arrow"
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Image = "rbxassetid://6031091004"
                DropdownArrow.ImageColor3 = self.Theme.TextSecondary
                DropdownArrow.Parent = DropdownButton
                
                -- Dropdown Menu
                local DropdownMenu = Instance.new("Frame")
                DropdownMenu.Name = "Menu"
                DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
                DropdownMenu.Position = UDim2.new(0, 0, 1, 5)
                DropdownMenu.BackgroundColor3 = self.Theme.BackgroundTertiary
                DropdownMenu.BorderSizePixel = 0
                DropdownMenu.ClipsDescendants = true
                DropdownMenu.Visible = false
                DropdownMenu.ZIndex = self.Theme.ZIndexOrder.Dropdown
                DropdownMenu.Parent = DropdownButton
                
                -- Dropdown Menu Corner Radius
                local DropdownMenuCorner = Instance.new("UICorner")
                DropdownMenuCorner.CornerRadius = UDim.new(0, 4)
                DropdownMenuCorner.Parent = DropdownMenu
                
                -- Dropdown Menu List
                local DropdownMenuList = Instance.new("ScrollingFrame")
                DropdownMenuList.Name = "List"
                DropdownMenuList.Size = UDim2.new(1, 0, 1, 0)
                DropdownMenuList.BackgroundTransparency = 1
                DropdownMenuList.BorderSizePixel = 0
                DropdownMenuList.ScrollBarThickness = 2
                DropdownMenuList.ScrollBarImageColor3 = self.Theme.AccentPrimary
                DropdownMenuList.ZIndex = self.Theme.ZIndexOrder.Dropdown
                DropdownMenuList.Parent = DropdownMenu
                
                -- Dropdown Menu List Layout
                local DropdownMenuListLayout = Instance.new("UIListLayout")
                DropdownMenuListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownMenuListLayout.Padding = UDim.new(0, 5)
                DropdownMenuListLayout.Parent = DropdownMenuList
                
                -- Dropdown Menu List Padding
                local DropdownMenuListPadding = Instance.new("UIPadding")
                DropdownMenuListPadding.PaddingTop = UDim.new(0, 5)
                DropdownMenuListPadding.PaddingLeft = UDim.new(0, 5)
                DropdownMenuListPadding.PaddingRight = UDim.new(0, 5)
                DropdownMenuListPadding.PaddingBottom = UDim.new(0, 5)
                DropdownMenuListPadding.Parent = DropdownMenuList
                
                -- Dropdown Variables
                local Selected = default
                local Open = false
                
                -- Update Dropdown Menu Size
                local function UpdateDropdownMenuSize()
                    local OptionCount = #options
                    local MaxVisibleOptions = 5
                    local OptionHeight = 30
                    local PaddingHeight = 10
                    
                    local VisibleOptions = math.min(OptionCount, MaxVisibleOptions)
                    local MenuHeight = (VisibleOptions * OptionHeight) + PaddingHeight
                    
                    DropdownMenu.Size = UDim2.new(1, 0, 0, MenuHeight)
                    DropdownMenuList.CanvasSize = UDim2.new(0, 0, 0, (OptionCount * OptionHeight) + PaddingHeight)
                end
                
                -- Populate Dropdown Menu
                local function PopulateDropdownMenu()
                    -- Clear existing options
                    for _, child in pairs(DropdownMenuList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Add options
                    for i, option in ipairs(options) do
                        -- Option Button
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = "Option_" .. i
                        OptionButton.Size = UDim2.new(1, 0, 0, 30)
                        OptionButton.BackgroundColor3 = self.Theme.BackgroundTertiary
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Text = option
                        OptionButton.TextColor3 = option == Selected and self.Theme.AccentPrimary or self.Theme.TextPrimary
                        OptionButton.TextSize = self.Theme.FontSizeBody
                        OptionButton.Font = self.Theme.Font
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.AutoButtonColor = false
                        OptionButton.ZIndex = self.Theme.ZIndexOrder.Dropdown
                        OptionButton.Parent = DropdownMenuList
                        
                        -- Option Button Padding
                        local OptionButtonPadding = Instance.new("UIPadding")
                        OptionButtonPadding.PaddingLeft = UDim.new(0, 5)
                        OptionButtonPadding.Parent = OptionButton
                        
                        -- Option Button Corner Radius
                        local OptionButtonCorner = Instance.new("UICorner")
                        OptionButtonCorner.CornerRadius = UDim.new(0, 4)
                        OptionButtonCorner.Parent = OptionButton
                        
                        -- Option Button Functionality
                        OptionButton.MouseEnter:Connect(function()
                            if option ~= Selected then
                                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundSecondary}):Play()
                            end
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            if option ~= Selected then
                                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundTertiary}):Play()
                            end
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            -- Update selected option
                            Selected = option
                            DropdownButton.Text = option
                            
                            -- Close dropdown menu
                            Open = false
                            DropdownMenu.Visible = false
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                            
                            -- Update option colors
                            for _, child in pairs(DropdownMenuList:GetChildren()) do
                                if child:IsA("TextButton") then
                                    child.TextColor3 = child.Text == Selected and self.Theme.AccentPrimary or self.Theme.TextPrimary
                                    child.BackgroundColor3 = self.Theme.BackgroundTertiary
                                end
                            end
                            
                            -- Call callback
                            callback(option)
                        end)
                    end
                    
                    -- Update menu size
                    UpdateDropdownMenuSize()
                end
                
                -- Populate initial options
                PopulateDropdownMenu()
                
                -- Dropdown Button Functionality
                DropdownButton.MouseEnter:Connect(function()
                    TweenService:Create(DropdownButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundSecondary}):Play()
                end)
                
                DropdownButton.MouseLeave:Connect(function()
                    TweenService:Create(DropdownButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundTertiary}):Play()
                end)
                
                DropdownButton.MouseButton1Click:Connect(function()
                    Open = not Open
                    
                    if Open then
                        -- Open dropdown menu
                        DropdownMenu.Visible = true
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                        
                        -- Adjust container size
                        DropdownContainer.Size = UDim2.new(1, 0, 0, 40 + DropdownMenu.AbsoluteSize.Y + 5)
                    else
                        -- Close dropdown menu
                        DropdownMenu.Visible = false
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        
                        -- Reset container size
                        DropdownContainer.Size = UDim2.new(1, 0, 0, 50)
                    end
                end)
                
                -- Close dropdown when clicking outside
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local MousePos = UserInputService:GetMouseLocation()
                        local DropdownPos = DropdownButton.AbsolutePosition
                        local DropdownSize = DropdownButton.AbsoluteSize
                        local MenuPos = DropdownMenu.AbsolutePosition
                        local MenuSize = DropdownMenu.AbsoluteSize
                        
                        -- Check if click is outside dropdown and menu
                        if Open and not (
                            MousePos.X >= DropdownPos.X and MousePos.X <= DropdownPos.X + DropdownSize.X and
                            MousePos.Y >= DropdownPos.Y and MousePos.Y <= DropdownPos.Y + DropdownSize.Y
                        ) and not (
                            MousePos.X >= MenuPos.X and MousePos.X <= MenuPos.X + MenuSize.X and
                            MousePos.Y >= MenuPos.Y and MousePos.Y <= MenuPos.Y + MenuSize.Y
                        ) then
                            Open = false
                            DropdownMenu.Visible = false
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                            
                            -- Reset container size
                            DropdownContainer.Size = UDim2.new(1, 0, 0, 50)
                        end
                    end
                end)
                
                -- Dropdown API
                local DropdownAPI = {}
                
                function DropdownAPI:Set(option)
                    if table.find(options, option) then
                        Selected = option
                        DropdownButton.Text = option
                        
                        -- Update option colors
                        for _, child in pairs(DropdownMenuList:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.TextColor3 = child.Text == Selected and self.Theme.AccentPrimary or self.Theme.TextPrimary
                            end
                        end
                        
                        callback(option)
                    end
                end
                
                function DropdownAPI:Get()
                    return Selected
                end
                
                function DropdownAPI:Refresh(newOptions, keepSelection)
                    options = newOptions
                    
                    if not keepSelection or not table.find(options, Selected) then
                        Selected = options[1]
                        DropdownButton.Text = Selected
                    end
                    
                    PopulateDropdownMenu()
                    callback(Selected)
                end
                
                return DropdownAPI
            end
            
            -- Color Picker Creation Function
            function Section:AddColorPicker(colorText, default, callback)
                default = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                -- Color Picker Container
                local ColorPickerContainer = Instance.new("Frame")
                ColorPickerContainer.Name = colorText .. "ColorPicker"
                ColorPickerContainer.Size = UDim2.new(1, 0, 0, 40)
                ColorPickerContainer.BackgroundTransparency = 1
                ColorPickerContainer.BorderSizePixel = 0
                ColorPickerContainer.Parent = SectionContent
                
                -- Color Picker Label
                local ColorPickerLabel = Instance.new("TextLabel")
                ColorPickerLabel.Name = "Label"
                ColorPickerLabel.Size = UDim2.new(1, -60, 1, 0)
                ColorPickerLabel.BackgroundTransparency = 1
                ColorPickerLabel.Text = colorText
                ColorPickerLabel.TextColor3 = self.Theme.TextPrimary
                ColorPickerLabel.TextSize = self.Theme.FontSizeBody
                ColorPickerLabel.Font = self.Theme.Font
                ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorPickerLabel.Parent = ColorPickerContainer
                
                -- Color Display
                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Name = "ColorDisplay"
                ColorDisplay.Size = UDim2.new(0, 50, 0, 30)
                ColorDisplay.Position = UDim2.new(1, -50, 0.5, -15)
                ColorDisplay.BackgroundColor3 = default
                ColorDisplay.BorderSizePixel = 0
                ColorDisplay.Parent = ColorPickerContainer
                
                -- Color Display Corner Radius
                local ColorDisplayCorner = Instance.new("UICorner")
                ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
                ColorDisplayCorner.Parent = ColorDisplay
                
                -- Color Display Button
                local ColorDisplayButton = Instance.new("TextButton")
                ColorDisplayButton.Name = "Button"
                ColorDisplayButton.Size = UDim2.new(1, 0, 1, 0)
                ColorDisplayButton.BackgroundTransparency = 1
                ColorDisplayButton.Text = ""
                ColorDisplayButton.Parent = ColorDisplay
                
                -- Color Picker Menu
                local ColorPickerMenu = Instance.new("Frame")
                ColorPickerMenu.Name = "Menu"
                ColorPickerMenu.Size = UDim2.new(0, 200, 0, 220)
                ColorPickerMenu.Position = UDim2.new(1, -200, 1, 10)
                ColorPickerMenu.BackgroundColor3 = self.Theme.BackgroundSecondary
                ColorPickerMenu.BorderSizePixel = 0
                ColorPickerMenu.Visible = false
                ColorPickerMenu.ZIndex = self.Theme.ZIndexOrder.ColorPicker
                ColorPickerMenu.Parent = ColorPickerContainer
                
                -- Color Picker Menu Corner Radius
                local ColorPickerMenuCorner = Instance.new("UICorner")
                ColorPickerMenuCorner.CornerRadius = UDim.new(0, 6)
                ColorPickerMenuCorner.Parent = ColorPickerMenu
                
                -- Color Picker Title
                local ColorPickerTitle = Instance.new("TextLabel")
                ColorPickerTitle.Name = "Title"
                ColorPickerTitle.Size = UDim2.new(1, 0, 0, 30)
                ColorPickerTitle.BackgroundTransparency = 1
                ColorPickerTitle.Text = "Color Picker"
                ColorPickerTitle.TextColor3 = self.Theme.TextPrimary
                ColorPickerTitle.TextSize = self.Theme.FontSizeSubheader
                ColorPickerTitle.Font = self.Theme.Font
                ColorPickerTitle.ZIndex = self.Theme.ZIndexOrder.ColorPicker
                ColorPickerTitle.Parent = ColorPickerMenu
                
                -- Color Picker Close Button
                local ColorPickerCloseBtn = Instance.new("TextButton")
                ColorPickerCloseBtn.Name = "CloseButton"
                ColorPickerCloseBtn.Size = UDim2.new(0, 20, 0, 20)
                ColorPickerCloseBtn.Position = UDim2.new(1, -25, 0, 5)
                ColorPickerCloseBtn.BackgroundColor3 = self.Theme.Error
                ColorPickerCloseBtn.Text = "X"
                ColorPickerCloseBtn.TextColor3 = self.Theme.TextPrimary
                ColorPickerCloseBtn.TextSize = self.Theme.FontSizeSmall
                ColorPickerCloseBtn.Font = self.Theme.Font
                ColorPickerCloseBtn.ZIndex = self.Theme.ZIndexOrder.ColorPicker
                ColorPickerCloseBtn.AutoButtonColor = false
                ColorPickerCloseBtn.Parent = ColorPickerMenu
                
                -- Color Picker Close Button Corner Radius
                local ColorPickerCloseBtnCorner = Instance.new("UICorner")
                ColorPickerCloseBtnCorner.CornerRadius = UDim.new(0, 4)
                ColorPickerCloseBtnCorner.Parent = ColorPickerCloseBtn
                
                -- Color Picker Content
                local ColorPickerContent = Instance.new("Frame")
                ColorPickerContent.Name = "Content"
                ColorPickerContent.Size = UDim2.new(1, -20, 1, -40)
                ColorPickerContent.Position = UDim2.new(0, 10, 0, 30)
                ColorPickerContent.BackgroundTransparency = 1
                ColorPickerContent.ZIndex = self.Theme.ZIndexOrder.ColorPicker
                ColorPickerContent.Parent = ColorPickerMenu
                
                -- Color Picker Variables
                local SelectedColor = default
                local Open = false
                
                -- Color Display Button Functionality
                ColorDisplayButton.MouseButton1Click:Connect(function()
                    Open = not Open
                    ColorPickerMenu.Visible = Open
                end)
                
                -- Color Picker Close Button Functionality
                ColorPickerCloseBtn.MouseEnter:Connect(function()
                    TweenService:Create(ColorPickerCloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = fromRGB(255, 100, 100)}):Play()
                end)
                
                ColorPickerCloseBtn.MouseLeave:Connect(function()
                    TweenService:Create(ColorPickerCloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Error}):Play()
                end)
                
                ColorPickerCloseBtn.MouseButton1Click:Connect(function()
                    Open = false
                    ColorPickerMenu.Visible = false
                end)
                
                -- Close color picker when clicking outside
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local MousePos = UserInputService:GetMouseLocation()
                        local MenuPos = ColorPickerMenu.AbsolutePosition
                        local MenuSize = ColorPickerMenu.AbsoluteSize
                        local DisplayPos = ColorDisplay.AbsolutePosition
                        local DisplaySize = ColorDisplay.AbsoluteSize
                        
                        -- Check if click is outside color picker menu and display
                        if Open and not (
                            MousePos.X >= MenuPos.X and MousePos.X <= MenuPos.X + MenuSize.X and
                            MousePos.Y >= MenuPos.Y and MousePos.Y <= MenuPos.Y + MenuSize.Y
                        ) and not (
                            MousePos.X >= DisplayPos.X and MousePos.X <= DisplayPos.X + DisplaySize.X and
                            MousePos.Y >= DisplayPos.Y and MousePos.Y <= DisplayPos.Y + DisplaySize.Y
                        ) then
                            Open = false
                            ColorPickerMenu.Visible = false
                        end
                    end
                end)
                
                -- Color Picker API
                local ColorPickerAPI = {}
                
                function ColorPickerAPI:Set(color)
                    SelectedColor = color
                    ColorDisplay.BackgroundColor3 = color
                    callback(color)
                end
                
                function ColorPickerAPI:Get()
                    return SelectedColor
                end
                
                return ColorPickerAPI
            end
            
            -- Label Creation Function
            function Section:AddLabel(labelText)
                -- Label Container
                local LabelContainer = Instance.new("Frame")
                LabelContainer.Name = "Label"
                LabelContainer.Size = UDim2.new(1, 0, 0, 25)
                LabelContainer.BackgroundTransparency = 1
                LabelContainer.BorderSizePixel = 0
                LabelContainer.Parent = SectionContent
                
                -- Label
                local Label = Instance.new("TextLabel")
                Label.Name = "Text"
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = self.Theme.TextSecondary
                Label.TextSize = self.Theme.FontSizeBody
                Label.Font = self.Theme.Font
                Label.TextWrapped = true
                Label.Parent = LabelContainer
                
                -- Label API
                local LabelAPI = {}
                
                function LabelAPI:Set(text)
                    Label.Text = text
                end
                
                function LabelAPI:Get()
                    return Label.Text
                end
                
                return LabelAPI
            end
            
            -- Divider Creation Function
            function Section:AddDivider()
                -- Divider Container
                local DividerContainer = Instance.new("Frame")
                DividerContainer.Name = "Divider"
                DividerContainer.Size = UDim2.new(1, 0, 0, 10)
                DividerContainer.BackgroundTransparency = 1
                DividerContainer.BorderSizePixel = 0
                DividerContainer.Parent = SectionContent
                
                -- Divider Line
                local DividerLine = Instance.new("Frame")
                DividerLine.Name = "Line"
                DividerLine.Size = UDim2.new(1, 0, 0, 1)
                DividerLine.Position = UDim2.new(0, 0, 0.5, 0)
                DividerLine.BackgroundColor3 = self.Theme.BorderSecondary
                DividerLine.BorderSizePixel = 0
                DividerLine.Parent = DividerContainer
                
                return DividerContainer
            end
            
            -- Input Field Creation Function
            function Section:AddTextbox(boxText, placeholderText, default, callback)
                placeholderText = placeholderText or "Enter text..."
                default = default or ""
                callback = callback or function() end
                
                -- Textbox Container
                local TextboxContainer = Instance.new("Frame")
                TextboxContainer.Name = boxText .. "Textbox"
                TextboxContainer.Size = UDim2.new(1, 0, 0, 50)
                TextboxContainer.BackgroundTransparency = 1
                TextboxContainer.BorderSizePixel = 0
                TextboxContainer.Parent = SectionContent
                
                -- Textbox Label
                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Name = "Label"
                TextboxLabel.Size = UDim2.new(1, 0, 0, 20)
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Text = boxText
                TextboxLabel.TextColor3 = self.Theme.TextPrimary
                TextboxLabel.TextSize = self.Theme.FontSizeBody
                TextboxLabel.Font = self.Theme.Font
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Parent = TextboxContainer
                
                -- Textbox Background
                local TextboxBackground = Instance.new("Frame")
                TextboxBackground.Name = "Background"
                TextboxBackground.Size = UDim2.new(1, 0, 0, 30)
                TextboxBackground.Position = UDim2.new(0, 0, 0, 20)
                TextboxBackground.BackgroundColor3 = self.Theme.BackgroundTertiary
                TextboxBackground.BorderSizePixel = 0
                TextboxBackground.Parent = TextboxContainer
                
                -- Textbox Background Corner Radius
                local TextboxBackgroundCorner = Instance.new("UICorner")
                TextboxBackgroundCorner.CornerRadius = UDim.new(0, 4)
                TextboxBackgroundCorner.Parent = TextboxBackground
                
                -- Textbox
                local Textbox = Instance.new("TextBox")
                Textbox.Name = "Input"
                Textbox.Size = UDim2.new(1, -20, 1, 0)
                Textbox.Position = UDim2.new(0, 10, 0, 0)
                Textbox.BackgroundTransparency = 1
                Textbox.Text = default
                Textbox.PlaceholderText = placeholderText
                Textbox.TextColor3 = self.Theme.TextPrimary
                Textbox.PlaceholderColor3 = self.Theme.TextDisabled
                Textbox.TextSize = self.Theme.FontSizeBody
                Textbox.Font = self.Theme.Font
                Textbox.TextXAlignment = Enum.TextXAlignment.Left
                Textbox.ClearTextOnFocus = false
                Textbox.Parent = TextboxBackground
                
                -- Textbox Functionality
                Textbox.Focused:Connect(function()
                    TweenService:Create(TextboxBackground, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundSecondary}):Play()
                end)
                
                Textbox.FocusLost:Connect(function(enterPressed)
                    TweenService:Create(TextboxBackground, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.BackgroundTertiary}):Play()
                    callback(Textbox.Text, enterPressed)
                end)
                
                -- Textbox API
                local TextboxAPI = {}
                
                function TextboxAPI:Set(text)
                    Textbox.Text = text
                    callback(text, false)
                end
                
                function TextboxAPI:Get()
                    return Textbox.Text
                end
                
                return TextboxAPI
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:AddNotification(title, message, duration, notificationType)
        duration = duration or 5
        notificationType = notificationType or "Info" -- Info, Success, Warning, Error
        
        -- Determine notification color based on type
        local notificationColor
        if notificationType == "Success" then
            notificationColor = self.Theme.Success
        elseif notificationType == "Warning" then
            notificationColor = self.Theme.Warning
        elseif notificationType == "Error" then
            notificationColor = self.Theme.Error
        else
            notificationColor = self.Theme.Info
        end
        
        -- Notification Container
        local NotificationContainer = Instance.new("Frame")
        NotificationContainer.Name = "Notification"
        NotificationContainer.Size = UDim2.new(0, 300, 0, 80)
        NotificationContainer.Position = UDim2.new(1, -320, 1, -100)
        NotificationContainer.BackgroundColor3 = self.Theme.BackgroundSecondary
        NotificationContainer.BorderSizePixel = 0
        NotificationContainer.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationContainer.Parent = game.CoreGui
        
        -- Notification Container Corner Radius
        local NotificationContainerCorner = Instance.new("UICorner")
        NotificationContainerCorner.CornerRadius = UDim.new(0, 6)
        NotificationContainerCorner.Parent = NotificationContainer
        
        -- Notification Type Indicator
        local NotificationIndicator = Instance.new("Frame")
        NotificationIndicator.Name = "Indicator"
        NotificationIndicator.Size = UDim2.new(0, 5, 1, 0)
        NotificationIndicator.BackgroundColor3 = notificationColor
        NotificationIndicator.BorderSizePixel = 0
        NotificationIndicator.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationIndicator.Parent = NotificationContainer
        
        -- Notification Indicator Corner Radius
        local NotificationIndicatorCorner = Instance.new("UICorner")
        NotificationIndicatorCorner.CornerRadius = UDim.new(0, 6)
        NotificationIndicatorCorner.Parent = NotificationIndicator
        
        -- Fix Corner Radius for Indicator
        local NotificationIndicatorFix = Instance.new("Frame")
        NotificationIndicatorFix.Name = "Fix"
        NotificationIndicatorFix.Size = UDim2.new(0.5, 0, 1, 0)
        NotificationIndicatorFix.Position = UDim2.new(0.5, 0, 0, 0)
        NotificationIndicatorFix.BackgroundColor3 = notificationColor
        NotificationIndicatorFix.BorderSizePixel = 0
        NotificationIndicatorFix.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationIndicatorFix.Parent = NotificationIndicator
        
        -- Notification Content
        local NotificationContent = Instance.new("Frame")
        NotificationContent.Name = "Content"
        NotificationContent.Size = UDim2.new(1, -15, 1, 0)
        NotificationContent.Position = UDim2.new(0, 15, 0, 0)
        NotificationContent.BackgroundTransparency = 1
        NotificationContent.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationContent.Parent = NotificationContainer
        
        -- Notification Title
        local NotificationTitle = Instance.new("TextLabel")
        NotificationTitle.Name = "Title"
        NotificationTitle.Size = UDim2.new(1, -20, 0, 25)
        NotificationTitle.Position = UDim2.new(0, 10, 0, 5)
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Text = title
        NotificationTitle.TextColor3 = self.Theme.TextPrimary
        NotificationTitle.TextSize = self.Theme.FontSizeSubheader
        NotificationTitle.Font = self.Theme.Font
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotificationTitle.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationTitle.Parent = NotificationContent
        
        -- Notification Message
        local NotificationMessage = Instance.new("TextLabel")
        NotificationMessage.Name = "Message"
        NotificationMessage.Size = UDim2.new(1, -20, 0, 40)
        NotificationMessage.Position = UDim2.new(0, 10, 0, 30)
        NotificationMessage.BackgroundTransparency = 1
        NotificationMessage.Text = message
        NotificationMessage.TextColor3 = self.Theme.TextSecondary
        NotificationMessage.TextSize = self.Theme.FontSizeBody
        NotificationMessage.Font = self.Theme.Font
        NotificationMessage.TextXAlignment = Enum.TextXAlignment.Left
        NotificationMessage.TextYAlignment = Enum.TextYAlignment.Top
        NotificationMessage.TextWrapped = true
        NotificationMessage.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationMessage.Parent = NotificationContent
        
        -- Notification Close Button
        local NotificationCloseBtn = Instance.new("TextButton")
        NotificationCloseBtn.Name = "CloseButton"
        NotificationCloseBtn.Size = UDim2.new(0, 20, 0, 20)
        NotificationCloseBtn.Position = UDim2.new(1, -25, 0, 5)
        NotificationCloseBtn.BackgroundColor3 = self.Theme.Error
        NotificationCloseBtn.Text = "X"
        NotificationCloseBtn.TextColor3 = self.Theme.TextPrimary
        NotificationCloseBtn.TextSize = self.Theme.FontSizeSmall
        NotificationCloseBtn.Font = self.Theme.Font
        NotificationCloseBtn.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationCloseBtn.AutoButtonColor = false
        NotificationCloseBtn.Parent = NotificationContainer
        
        -- Notification Close Button Corner Radius
        local NotificationCloseBtnCorner = Instance.new("UICorner")
        NotificationCloseBtnCorner.CornerRadius = UDim.new(0, 4)
        NotificationCloseBtnCorner.Parent = NotificationCloseBtn
        
        -- Notification Progress Bar Background
        local NotificationProgressBg = Instance.new("Frame")
        NotificationProgressBg.Name = "ProgressBackground"
        NotificationProgressBg.Size = UDim2.new(1, 0, 0, 5)
        NotificationProgressBg.Position = UDim2.new(0, 0, 1, -5)
        NotificationProgressBg.BackgroundColor3 = self.Theme.BackgroundTertiary
        NotificationProgressBg.BorderSizePixel = 0
        NotificationProgressBg.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationProgressBg.Parent = NotificationContainer
        
        -- Notification Progress Bar
        local NotificationProgress = Instance.new("Frame")
        NotificationProgress.Name = "Progress"
        NotificationProgress.Size = UDim2.new(1, 0, 1, 0)
        NotificationProgress.BackgroundColor3 = notificationColor
        NotificationProgress.BorderSizePixel = 0
        NotificationProgress.ZIndex = self.Theme.ZIndexOrder.Notification
        NotificationProgress.Parent = NotificationProgressBg
        
        -- Notification Animation
        NotificationContainer.Position = UDim2.new(1, 20, 1, -100)
        TweenService:Create(NotificationContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -320, 1, -100)}):Play()
        
        -- Progress Bar Animation
        TweenService:Create(NotificationProgress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        
        -- Close Button Functionality
        NotificationCloseBtn.MouseEnter:Connect(function()
            TweenService:Create(NotificationCloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = fromRGB(255, 100, 100)}):Play()
        end)
        
        NotificationCloseBtn.MouseLeave:Connect(function()
            TweenService:Create(NotificationCloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Error}):Play()
        end)
        
        NotificationCloseBtn.MouseButton1Click:Connect(function()
            TweenService:Create(NotificationContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 1, -100)}):Play()
            wait(0.5)
            NotificationContainer:Destroy()
        end)
        
        -- Auto Close
        spawn(function()
            wait(duration)
            if NotificationContainer and NotificationContainer.Parent then
                TweenService:Create(NotificationContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 1, -100)}):Play()
                wait(0.5)
                NotificationContainer:Destroy()
            end
        end)
        
        return NotificationContainer
    end
    
    return Window
end

return CustomUILib
