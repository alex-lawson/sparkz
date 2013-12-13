function init(args)
  object.setInteractive(true)

  if storage.state == nil then
    output("off")
  else
    output(storage.state)
  end

  if object.direction() == 1 then
    object.outLR = {"left", "right"}
  else
    object.outLR = {"right", "left"}
  end
end

function onInteraction(args)
  return({ "OpenCraftingInterface", { config = "/interface/windowconfig/sparkz_wiringstation.config", filter = { "sparkz" }  } })
end

function checkInboundNodes()
  if not object.getInboundNodeLevel(0) and not object.getInboundNodeLevel(1) then
    output("off")
  elseif object.getInboundNodeLevel(0) and not object.getInboundNodeLevel(1) then
    output(object.outLR[1])
  elseif not object.getInboundNodeLevel(0) and object.getInboundNodeLevel(1) then
    output(object.outLR[2])
  else
    output("both")
  end
end

function output(state)
  if state ~= storage.state then
    storage.state = state
    
    if object.direction() == -1 then
      state = "flip"..state
    end
    
    world.logInfo("Setting state to "..state.." since direction is "..object.direction())

    object.setAnimationState("lightState", state )
  end
end

function onInboundNodeChange(args)
  checkInboundNodes()
end

function onNodeConnectionChange()
  checkInboundNodes()
end