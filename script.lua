-- ========================================================
-- واجهة النزول والتحكم بالثبات تحت الأرض
-- حقوق النشر والتطوير: سلطان، خراب
-- ========================================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- إنشاء الواجهة (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SultanKharabGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- إطار القائمة الرئيسي
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- عنوان القائمة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "سلطان & خراب"
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- زر النزول تحت الأرض
local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0.9, 0, 0, 35)
downBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.Text = "نزول تحت الأرض"
downBtn.TextSize = 13
downBtn.Font = Enum.Font.SourceSansBold
downBtn.Parent = frame

-- زر إيقاف السقوط / الثبات
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.9, 0, 0, 35)
stopBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "إيقاف السقوط (ثبات)"
stopBtn.TextSize = 13
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.Parent = frame

-- وظيفة النزول تحت الأرض
downBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            -- إنزال اللاعب 15 خطوة للأسفل
            root.CFrame = root.CFrame - Vector3.new(0, 15, 0)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- وظيفة إيقاف السقوط والثبات التام
stopBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if root then
            -- تصفير السرعة تماماً عشان يوقف في مكانه ولا يطيح
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            if humanoid then
                humanoid.PlatformStand = true
            end
            -- تثبيت القطع لمنع الحركة أو السقوط بالجاذبية
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end
    end
end)
