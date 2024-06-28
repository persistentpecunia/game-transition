local Assets = game:GetService("ReplicatedStorage").Assets
local Library = game:GetService("ReplicatedStorage").Library

local TweenState = {
    Idle = 0,
    Animating = 1
}

local Sizes = {
    In = UDim2.new(0, 0, 0, 0),
    Out = UDim2.new(3, 0, 3, 0)
}

local function TweenGui(type, frame)
    frame:TweenSize(
        (type == "close") and Sizes.In or Sizes.Out,
        Enum.EasingDirection[(type == "close") and "In" or "Out"],
        Enum.EasingStyle.Quart,
        .8
    )
end

local CircularTransitionManager = {}
CircularTransitionManager.__index = CircularTransitionManager

function CircularTransitionManager.new()
    local self = setmetatable({}, CircularTransitionManager)
    self.State = TweenState.Idle
    self.Sound = Assets.Sounds.AirPass:Clone()
    self.Sound.Parent = workspace

    self.ScreenGui = script.Transition:Clone()
    self.ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
    self.ScreenGui.Enabled = false

    function self:Init()
        TweenGui("open", self.ScreenGui.Main)
        wait(1)
        self.ScreenGui.Enabled = true
        self.State = TweenState.Idle
    end

    self:Init()

    function self:Play(length)
        if self.State ~= TweenState.Animating then
            self.State = TweenState.Animating
            length = (length and length > 0.5) and length or 0.6

            self:PlaySound()
            TweenGui("close", self.ScreenGui.Main)
            wait(length)
            TweenGui("open", self.ScreenGui.Main)        

            self.State = TweenState.Idle
            self.Sound:Destroy()
            self.Sound = nil;
        end
    end

    function self:PlaySound()                
        self.Sound:Play()
    end

    function self:GetScreenGui()
        return self.ScreenGui
    end

    return self
end

return CircularTransitionManager
