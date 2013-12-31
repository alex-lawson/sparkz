function init(virtual)
  if not virtual then
    entity.setInteractive(true)

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

    self.forcePrint = true
    self.printDelay = 0

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
end

function checkNodes()
  if entity.getInboundNodeLevel(0) ~= storage.inboundWireState then
    storage.inboundWireState = entity.getInboundNodeLevel(0)
    if storage.inboundWireState then
      initiatePrint()
    end
  end
end

function validateData(data, nodeId) 
  return isPrintData(data)
end

function onValidDataReceived(data, nodeId)
  storage.tileArea = relTileAreaToAbs(data["tileArea"])
  storage.fgData = data["fgData"]
  storage.bgData = data["bgData"]
end

function onInteraction(args)
  if not storage.inboundWireState then
    initiatePrint()
  end
end

function initiatePrint()
  if self.forcePrint then
    self.printDelay = 3
    breakLayer("foreground", false)
    breakLayer("background", false)
  end

  self.previousFailureCount = { foreground = 0, background = 0 }

  doPrint()
end

function doPrint()
  if #storage.tileArea > 0 and self.printDelay <= 0 then
    placeLayer("background", storage.bgData)
    placeLayer("foreground", storage.fgData)
  end
end

function main()
  if not self.initialized then
    initInWorld()
  end

  if self.printDelay > 0 then
    self.printDelay = self.printDelay - 1
    if self.printDelay <= 0 then
      doPrint()
    end
  end
end