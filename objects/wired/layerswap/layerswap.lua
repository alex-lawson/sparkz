function init(virtual)
  if not virtual then
    entity.setInteractive(not entity.isInboundNodeConnected(0))

    self.swapHeight = entity.configParameter("swapHeight")
    if self.swapHeight == nil then
      self.swapHeight = 5
    end

    if storage.tileArea == nil then
      storage.tileArea = {}
      for y = 1, self.swapHeight do
        storage.tileArea[y] = {entity.position()[1], entity.position()[2] + y}
      end
    end

    if storage.swapState == nil then
      storage.swapState = false -- false = blocks in foreground, true = blocks in background
    end

    if storage.transitionState == nil then
      storage.transitionState = 0 -- >1 = breaking, 1 = placing, 0 = passive
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
  world.logInfo(string.format("%s initializing in world", entity.configParameter("objectName")))

  queryNodes()
  self.initialized = true
end

function updateAnimationState()
  if storage.swapState then
    entity.setAnimationState("layerState", "background")
  else
    entity.setAnimationState("layerState", "foreground")
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
  swapLayer(entity.getInboundNodeLevel(0))
end

function validateData(data, nodeId)
  world.logInfo(type(data))
  return type(data) == "table"
end

function onValidDataReceived(data, nodeId)
  if storage.transitionState > 0 then
    storage.pendingAreaData = data
  else
    storage.tileArea = data
  end
end

function onInteraction(args)
  if not entity.isInboundNodeConnected(0) then
    swapLayer(not storage.swapState)
  end
end

function swapLayer(newState)
  if newState ~= storage.swapState then
    world.logInfo("storage.tileArea")
    world.logInfo(storage.tileArea)

    storage.swapState = newState
    storage.transitionState = 3

    self.previousFailureCount = { foreground = 0, background = 0 }

    storage.bgData = scanLayer("background")
    storage.fgData = scanLayer("foreground")

    breakLayer("background", false)
    breakLayer("foreground", false)

    updateAnimationState()
  end
end

function main()
  if not self.initialized then
    initInWorld()
  end

  if storage.transitionState > 0 then
    if storage.transitionState == 1 then
      --place stored blocks
      placeLayer("background", storage.fgData)
      placeLayer("foreground", storage.bgData)

      if storage.pendingAreaData then
        storage.tileArea = storage.pendingAreaData
        storage.pendingAreaData = false
      end
    end

    storage.transitionState = storage.transitionState - 1
  end
end