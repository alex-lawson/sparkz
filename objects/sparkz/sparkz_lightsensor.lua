function init(args)

end

function main(args)
  if world.lightLevel(object.position()) >= object.configParameter("detectThresholdLow") then
    object.setOutboundNodeLevel(0, true)
  else
    object.setOutboundNodeLevel(0, false)
  end

  if world.lightLevel(object.position()) >= object.configParameter("detectThresholdHigh") then
    object.setOutboundNodeLevel(1, true)
  else
    object.setOutboundNodeLevel(1, false)
  end
end