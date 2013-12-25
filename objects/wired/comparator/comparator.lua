function init(virtual)
  if not virtual then
    if not storage.data1 then
      storage.data1 = 0
    end

    if not storage.data2 then
      storage.data2 = 0
    end

    if not storage.nodeStates then
      storage.nodeStates = {}
    end

    if storage.state == nil then
      storage.state = false
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
  
  queryNodes()
  self.initialized = true
end

function validateData(data, nodeId)
  return type(data) == "number"
end

function onValidDataReceived(data, nodeId)
  if nodeId == 0 then
    storage.data1 = data
  else
    storage.data2 = data
  end

  compare()
end

function compare()
  storage.state = entity.isInboundNodeConnected(0) and entity.isInboundNodeConnected(1) and storage.data1 > storage.data2
  entity.setOutboundNodeLevel(0, storage.state)

  if (storage.state) then
    sendData(storage.data1, "all")
  else
    sendData(storage.data2, "all")
  end

  updateAnimationState()
end

function updateAnimationState()
  if storage.state then
    entity.setAnimationState("comparatorState", self.flipStr.."on")
  else
    entity.setAnimationState("comparatorState", self.flipStr.."off")
  end
end

function main(args)
  if not self.initialized then
    initInWorld()
  end

  compare()
end