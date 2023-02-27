local Library = {
    Hidden = false
}

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local tInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UserInputService = game:GetService("UserInputService")

local function MakeDraggable(ClickObject, Object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    ClickObject.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    ClickObject.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

function Library:CreateWindow(Config, Parent)
    local WindowInit = {}
    local Folder = game:GetObjects("rbxassetid://12619894162")[1]
    local Screen = Folder.Panel:Clone()
    if syn and syn.protect_gui then
        syn.protect_gui(Screen)
        Screen.Parent = CoreGui
    elseif gethui then
        Screen.Parent = gethui()
    else
        Screen.Parent = CoreGui
    end
    local Main = Screen.Main

    local Loading = Screen.Loading
    Loading.Text.Title.Text = "ReQiuYTL Hub Helper"
    Loading.Text.Description.Text = "by Bones"
    Loading.Text.Version.Text = "v0.01"
    wait(3)

    Loading:TweenSize(Main.Size, "Out", "Quint", 0.8)
    wait(0.8)

    Main.Visible = true
    TweenService:Create(Loading.Text, tInfo, {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(Loading, tInfo, {
        BackgroundTransparency = 1
    }):Play()

    local Topbar = Main.TopBar
    Topbar.Title.Text = "ReQiuYTL Hub Helper"

    local TabList = Main.TabList
    local Elements = Main.Elements

    MakeDraggable(TopBar, Main)

    local itemTemplates = {}
    for _, item in ipairs(Elements.Template:GetChildren()) do
        if item:IsA("Frame") then
            table.insert(itemTemplates, item)
            Elements.Template[item.Name]:Destroy()
        end
    end

    function WindowInit:createTab(name, icon)
        local pageInIt = {}
        local newTab = TabList.Template:Clone()
        newTab.Name = name
        newTab.Title.Text = name
        newTab.Image.Image = icon
        newTab.Parent = TabList

        local newPage = Elements.Template:Clone()
        newPage.Parent = Elements

        function pageInIt:createButton(name, callback)
            local newItem = itemTemplates["Button"]:Clone()
            newItem.Name = name
            newItem.Title.Text = name
            newItem.Parent = newPage
            newItem.Visible = true
            newItem.Interact.MouseButton1Click:Connect(callback)
            return newItem
        end

        function pageInIt:createDropdown(name, List, callback)
            local newItem = itemTemplates["Dropdown"]:Clone()

            local function createListItem(item_name)
                local ListItem = newItem.List.Template:Clone()
                ListItem.Title.Text = item_name
                ListItem.Name = item_name
                ListItem.Parent = newItem.List
                ListItem.Interact.MouseButton1Click:Connect(callback)
            end

            for _, item in List do
                createListItem(item)
            end
            return newItem
        end

        function pageInIt:createInput(name, placeholder)
            local newItem = itemTemplates["Input"]:Clone()
            newItem.Name = name
            newItem.Title.Text = name
            newItem.InputFrame.TextBox.PlaceholderText = placeholder
            newItem.Parent = newPage
            newItem.Visible = true
            return newItem
        end

        function pageInIt:createLabel(name, title)
            local newItem = itemTemplates["Label"]:Clone()
            newItem.Name = name
            newItem.Title.Text = title
            newItem.Parent = newPage
            newItem.Visible = true
            return newItem
        end

        function pageInIt:createParagraph(name, title, desc)
            local newItem = itemTemplates["Paragraph"]:Clone()
            newItem.Name = name
            newItem.Title.Text = title
            newItem.Description.Text = desc
            newItem.Parent = newPage
            newItem.Visible = true
            return newItem
        end

        function pageInIt:createSpacing()
            local newItem = itemTemplates["SectionSpacing"]:Clone()
            newItem.Parent = newPage
            newItem.Visible = true
            return newItem
        end

        function pageInIt:createTitle(name)
            local newItem = itemTemplates["SectionSpacing"]:Clone()
            newItem.Parent = newPage
            newItem.Name = name
            newItem.Title.Text = name
            newItem.Visible = true
            return newItem
        end

        function pageInIt:createToggle(name, callback, toggle)
            local newItem = itemTemplates["Toggle"]:Clone()
            newItem.Parent = newPage
            newItem.Name = name
            newItem.Title.Text = name
            newItem.Visible = true
            local Toggle = toggle
            local function switch(status)
                if not status then
                    TweenService:Create(newItem.Switch.Indicator, tInfo, {
                        Position = UDim2.fromScale(1, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(30, 184, 255)
                    }):Play()
                    Toggle = true
                else
                    TweenService:Create(newItem.Switch.Indicator, tInfo, {
                        Position = UDim2.fromScale(0, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    }):Play()
                    Toggle = false
                end
            end
            switch(not Toggle)
            newItem.Interact.MouseButton1Click:Connect(function()
                switch(toggle)
                spawn(callback)
            end)
            return newItem
        end

        return newTab, newPage
    end
    return WindowInit
end

return Library
