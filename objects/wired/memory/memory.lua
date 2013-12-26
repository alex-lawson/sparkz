function init(virtual)
  if not virtual then
    if not storage.data then
      storage.data = 0
    end

    self.initialized = false
  end
end

function initInWorld()
  --world.logInfo(string.format("%s initializing in world", entity.configParameter("objectName")))

  self.flipStr = ""
  if entity.direction() == -1 then
    self.flipStr = "flipped."
  end

  updateAnimationState()
  
  queryNodes()

  self.initialized = true
end

function onInteraction(args)
  reset()
end

function onInboundNodeChange(args)
  output()
  updateAnimationState()
end

function updateAnimationState()
  if entity.getInboundNodeLevel(1) and entity.getInboundNodeLevel(2) then
    entity.setAnimationState("lockState", self.flipStr.."both")
  elseif entity.getInboundNodeLevel(1) then
    entity.setAnimationState("lockState", self.flipStr.."in")
  elseif entity.getInboundNodeLevel(2) then
    entity.setAnimationState("lockState", self.flipStr.."out")
  else
    entity.setAnimationState("lockState", self.flipStr.."none")
  end
end

function validateData(data, nodeId)
  --only receive data on node 0 and when unlocked
  return nodeId == 0 and not entity.getInboundNodeLevel(1)
end

function onValidDataReceived(data, nodeId)
  storage.data = data
  output()
end

function output()
  if not entity.getInboundNodeLevel(2) then
    sendData(storage.data, 0)
  end
end

function main(args)
  if not self.initialized then
    initInWorld()
  end

  output()
end