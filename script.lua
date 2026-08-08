-- KSA Hub - MM2 Edition (Delta Executor)
-- Inspired by Ibrahim Al-Fadl style

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- إنشاء واجهة المستخدم (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KSA_MM2_Hub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "KSA Hub - MM2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- زر إيم بوت القاتل (كبير ومعقول)
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(0.85, 0, 0, 55)
AimbotBtn.Position = UDim2.new(0.075, 0, 0, 60)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
AimbotBtn.Text = "إيم بوت القاتل: مطفأ"
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.TextSize = 16
AimbotBtn.Font = Enum.Font.SourceSansBold
AimbotBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 8)
BtnCorner1.Parent = AimbotBtn

-- زر كشف أدوار MM2 (القاتل بالشريف)
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.85, 0, 0, 55)
ESPBtn.Position = UDim2.new(0.075, 0, 0, 130)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPBtn.Text = "كشف القاتل والشريف (ESP): مطفأ"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.TextSize = 16
ESPBtn.Font = Enum.Font.SourceSansBold
ESPBtn.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = ESPBtn

-- زر طيران القاتل/الشخصية
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.85, 0, 0, 55)
FlyBtn.Position = UDim2.new(0.075, 0, 0, 200)
FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyBtn.Text = "الطيران (Fly): مطفأ"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.TextSize = 16
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.Parent = MainFrame

local BtnCorner3 = Instance.new("UICorner")
BtnCorner3.CornerRadius = UDim.new(0, 8)
BtnCorner3.Parent = FlyBtn

-- زر السرعة
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.85, 0, 0, 55)
SpeedBtn.Position = UDim2.new(0.075, 0, 0, 270)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBtn.Text = "سرعة خارقة: مطفأ"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextSize = 16
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.Parent = MainFrame

local BtnCorner4 = Instance.new("UICorner")
BtnCorner4.CornerRadius = UDim.new(0, 8)
BtnCorner4.Parent = SpeedBtn

-- دالة للبحث عن القاتل في MM2 (الذي يحمل السكين)
local function getMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- التحقق مما إذا كان يحمل السكين في اليد أو الحقيبة
            if player.Character:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife")) then
                return player.Character
            end
        end
    end
    return nil
end

-- 1. إيم بوت موجه حصرياً للقاتل
local aimbotEnabled = false
AimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimbotBtn.Text = "إيم بوت القاتل: شغال"
        AimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        AimbotBtn.Text = "إيم بوت القاتل: مطفأ"
        AimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local murdererChar = getMurderer()
        if murdererChar and murdererChar:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, murdererChar.HumanoidRootPart.Position)
        end
    end
end)

-- 2. كشف أدوار MM2 (القاتل باللون الأحمر، الشريف باللون الأزرق)
local espEnabled = false
ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPBtn.Text = "كشف القاتل والشريف (ESP): شغال"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "MM2_ESP"
                highlight.Adornee = p.Character
                
                -- تحديد اللون حسب السلاح (سكين = قاتل أحمر، مسدس = شريف أزرق)
                if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- قاتل
                elseif p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255) -- شريف
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- عادي
                end
                
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = p.Character
            end
        end
    else
        ESPBtn.Text = "كشف القاتل والشريف (ESP): مطفأ"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MM2_ESP") then
                p.Character.MM2_ESP:Destroy()
            end
        end
    end
end)

-- 3. السرعة
local speedEnabled = false
SpeedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedBtn.Text = "سرعة خارقة: شغال"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 24
        end
    else
        SpeedBtn.Text = "سرعة خارقة: مطفأ"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)
