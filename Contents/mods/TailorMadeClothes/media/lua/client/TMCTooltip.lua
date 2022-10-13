require "ISUI/ISToolTipInv"

local old_ISToolTipInv_render = ISToolTipInv.render
function ISToolTipInv:render()
    if self.item == nil or not self.item:IsClothing() or self.item:getModData()["bodyMeasurementsID"] == nil then
        return old_ISToolTipInv_render(self)
    end
    local tailorText = "Tailor-Made for: "..self.item:getModData()["bodyMeasurementsID"]
    local numRows = 1 -- Cause it's just one row, duh
    local stage = 1
    local old_y = 0
    local lineSpacing = self.tooltip:getLineSpacing() + 0.5
    local old_setHeight = self.setHeight
    self.setHeight = function(self, num, ...)
        if stage == 1 then
            stage = 2
            old_y = num
            num = num + numRows * lineSpacing
        else
            stage = -1 --error
        end
        return old_setHeight(self, num, ...)
    end
    local old_drawRectBorder = self.drawRectBorder
    self.drawRectBorder = function(self, ...)
        if numRows > 0 then
            local color = { 0.68, 0.64, 0.96 }
            local font = UIFont[getCore():getOptionTooltipFont()];
            self.tooltip:DrawText(font, tailorText, 5, old_y - 3, color[1], color[2], color[3], 1);
            stage = 3
        else
            stage = -1 --error
        end
        return old_drawRectBorder(self, ...)
    end
    old_ISToolTipInv_render(self)
    self.setHeight = old_setHeight
    self.drawRectBorder = old_drawRectBorder
end
