function init(virtual)
  if not virtual then
    entity.setInteractive(not entity.isInboundNodeConnected(0))

    if storage.tileArea == nil then
      storage.tileArea = {}
    end

    if storage.inboundWireState == nil then
      storage.inboundWireState = false
    end

    if storage.bgData == nil then
      storage.bgData = {}
    end

    if storage.fgData == nil then
      storage.fgData = {}
    end

    self.previousFailureCount = { foreground = 0, background = 0 }

    self.initialized = false

    updateAnimationState()
  end
end

function initInWorld()
  --world.logInfo(string.format("%s initializing in world", entity.configParameter("objectName")))

  queryNodes()
  self.initialized = true
end

function updateAnimationState()
  if entity.direction() == 1 then
    entity.setAnimationState("flipState", "default")
  else
    entity.setAnimationState("flipState", "flipped")
  end
end

function onInboundNodeChange(args) 
  checkNodes()
end

oldOnNodeConnectionChange = onNodeConnectionChange
 
function onNodeConnectionChange()
  if oldOnNodeConnectionChange then
    oldOnNodeConnectionChange()
  end

  checkNodes()
  entity.setInteractive(not entity.isInboundNodeConnected(0))
end

function checkNodes()
  if entity.getInboundNodeLevel(0) ~= storage.inboundWireState then
    storage.inboundWireState = entity.getInboundNodeLevel(0)
    if storage.inboundWireState then
      doPrint()
    end
  end
end

function validateData(data, nodeId) 
  if type(data) == "table" then
    return data["tileArea"] ~= nil and data["fgData"] ~= nil and data["bgData"] ~= nil
  end
end

function onValidDataReceived(data, nodeId)
  storage.tileArea = relTileAreaToAbs(data["tileArea"])
  storage.fgData = data["fgData"]
  storage.bgData = data["bgData"]
end

function onInteraction(args)
  if not storage.inboundWireState then
    doPrint()
  end
end

function doPrint()
  if #storage.tileArea > 0 then
    placeLayer("background", storage.bgData)
    placeLayer("foreground", storage.fgData)
  end
end

function main()
  if not self.initialized then
    initInWorld()
  end
end