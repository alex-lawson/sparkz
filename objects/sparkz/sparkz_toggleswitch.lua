function init(args)
  object.setInteractive(true)
  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end

  if storage.triggered == nil then
    storage.triggered = false
  end

  object.setAllOutboundNodes(object.animationState("switchState") == "on")
end

function onInteraction(args)
  output(not storage.state)
end

function output(state)
  storage.state = state
  if state then
    object.setAnimationState("switchState", "on")
    object.playSound("onSounds");
    object.setAllOutboundNodes(true)
  else
    object.setAnimationState("switchState", "off")
    object.playSound("offSounds");
    object.setAllOutboundNodes(false)
  end
end

function main(args)
  if object.getInboundNodeLevel(0) and not storage.triggered then
    storage.triggered = true
    output(not storage.state)
  elseif storage.triggered and not object.getInboundNodeLevel(0) then
    storage.triggered = false
  end
end