function init(virtual)
  if not virtual then
    entity.setInteractive(not entity.isInboundNodeConnected(0))

    if storage.tileArea == nil then
      storage.tileArea = {}
    end

    -- if storage.swapState == nil then
    --   storage.swapState = false -- false = blocks in foreground, true = blocks in background
    -- end

    -- if storage.transitionState == nil then
    --   storage.transitionState = 0 -- >1 = breaking, 1 = placing, 0 = passive
    -- end

    if storage.inboundWireState == nil then
      storage.inboundWireState = false
    end

    if storage.bgData == nil then
      storage.bgData = {}
    end

    if storage.fgData == nil then
      storage.fgData = {}
    end

    -- self.previousFailureCount = { foreground = 0, background = 0 }

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
      doScan()
    end
  end
end

function validateData(data, nodeId) 
  if type(data) == "table" then
    for i, pos in ipairs(data) do
      if type(pos) ~= "table" or #pos ~= 2 then
        return false
      end
    end
  end
  return true
end

function onValidDataReceived(data, nodeId)
  storage.tileArea = data
end

function onInteraction(args)
  if not storage.inboundWireState then
    doScan()
  end
end

function doScan()
  if #storage.tileArea > 0 then
    storage.bgData = scanLayer("background")
    storage.fgData = scanLayer("foreground")

    local xmitData = {
      tileArea = absTileAreaToRel(storage.tileArea),
      bgData = storage.bgData,
      fgData = storage.fgData
    }

    sendData(xmitData, "all")
  end
end

function main()
  if not self.initialized then
    initInWorld()
  end
end