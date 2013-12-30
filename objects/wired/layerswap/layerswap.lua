function init(virtual)
  if not virtual then
    entity.setInteractive(not entity.isInboundNodeConnected(0))

    self.swapHeight = entity.configParameter("swapHeight")
    if self.swapHeight == nil then
      self.swapHeight = 5
    end

    if storage.swapArea == nil then
      storage.swapArea = {}
      for y = 1, self.swapHeight do
        storage.swapArea[y] = {entity.position()[1], entity.position()[2] + y}
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
    storage.swapArea = data
  end
end

function onInteraction(args)
  if not entity.isInboundNodeConnected(0) then
    swapLayer(not storage.swapState)
  end
end

function swapLayer(newState)
  if newState ~= storage.swapState then
    world.logInfo("storage.swapArea")
    world.logInfo(storage.swapArea)

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

function scanLayer(targetLayer)
  --world.logInfo("in scanLayer ("..targetLayer..")")
  --world.logInfo(storage.swapArea)
  local scanData = {}
  for i, pos in ipairs(storage.swapArea) do
    local sample = world.material(pos, targetLayer)
    if sample and sample ~= "invisitile" then
      scanData[i] = sample
    else
      scanData[i] = false
    end
  end

  return scanData
end

function breakLayer(targetLayer, dropItems)
  --world.logInfo("in breakLayer ("..targetLayer..")")
  if dropItems then
    world.damageTiles(storage.swapArea, targetLayer, entity.position(), "blockish", 9999)
  else
    world.damageTiles(storage.swapArea, targetLayer, entity.position(), "crushing", 9999)
  end
end

function placeLayer(targetLayer, blockData)
  --world.logInfo("in placeLayer ("..targetLayer..")")
  --world.logInfo(blockData)

  --TODO: track failures and retry while failuresLastRun < failuresRunBeforeLast
  local failureCount = 0

  world.logInfo(string.format("attempting to place blocks in %s with data:", targetLayer))
  world.logInfo(blockData)

  for i, pos in ipairs(storage.swapArea) do
    if blockData[i] then
      local success = world.placeMaterial(pos, targetLayer, blockData[i])
      getMatItemName(blockData[i])
      if success then
        --world.logInfo(string.format("successfully placed %s in %s", blockData[i], targetLayer))

        --remove data to prevent being placed again
        blockData[i] = false
      else
        --world.logInfo("failed to place block in "..targetLayer)

        --wouldn't this be cool? but NOPE
        --world.spawnItem(blockData[i].."material", pos, 1)

        failureCount = failureCount + 1
      end
    elseif targetLayer == "background" then
      local success = world.placeMaterial(pos, targetLayer, "invisitile")
      if not success then
        --world.logInfo("failed to place invisible tile in "..targetLayer)
      end
    end
  end

  world.logInfo(string.format("finished placement with %d failures (%d last run)", failureCount, self.previousFailureCount[targetLayer]))

  --keep calling recursively as long as placement improves with each call
  if failureCount > 0 then
    
    if failureCount ~= self.previousFailureCount[targetLayer] then
      --still improving placements
      self.previousFailureCount[targetLayer] = failureCount
      placeLayer(targetLayer, blockData)
    else
      --placements are stuck; give up and drop items
      dropUnplacedItems(blockData)
    end
  end
end

function getMatItemName(matName)
  local success = pcall(function () world.itemType(matName) end)
  if not success then
    success = pcall(function () world.itemType(matName.."material") end)
    if not success then
      world.logInfo(string.format("unable to get item name for %s", matName))
      return false
    else
      return matName.."material"
    end
  else
    return matName
  end
end

function dropUnplacedItems(blockData)
  for i, pos in ipairs(storage.swapArea) do
    if blockData[i] then
      local itemName = getMatItemName(blockData[i])
      if itemName then
        world.spawnItem(itemName, pos, 1)
      end
    end
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
        storage.swapArea = storage.pendingAreaData
        storage.pendingAreaData = false
      end
    end

    storage.transitionState = storage.transitionState - 1
  end
end