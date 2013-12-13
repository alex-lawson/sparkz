function init(args)
  object.setInteractive(true)

  if storage.state == nil then
    output("off")
  else
    output(storage.state)
  end
end

function onInteraction(args)
  return({ "OpenCraftingInterface", { config = "/interface/windowconfig/sparkz_wiringstation.config", filter = { "sparkz" }  } })
end

function checkInboundNodes()
  if not object.getInboundNodeLevel(0) and not object.getInboundNodeLevel(1) then
    output("off")
  elseif object.getInboundNodeLevel(0) and not object.getInboundNodeLevel(1) then
    output("left")
  elseif not object.getInboundNodeLevel(0) and object.getInboundNodeLevel(1) then
    output("right")
  else
    output("both")
  end
end

function output(state)
  if state ~= storage.state then
    storage.state = state
    object.setAnimationState("lightState", state )
  end
end

function onInboundNodeChange(args)
  checkInboundNodes()
end

function onNodeConnectionChange()
  checkInboundNodes()
end