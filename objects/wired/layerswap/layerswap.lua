function init(virtual)
  if not virtual then
    entity.setInteractive(not entity.isInboundNodeConnected(0))

    self.swapHeight = entity.configParameter("swapHeight")
    if self.swapHeight == nil then
      self.swapHeight = 5
    end

    if storage.swapArea == nil then
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

    updateAnimationState()
  end
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
 
function onNodeConnectionChange() 
  checkNodes()
  entity.setInteractive(not entity.isInboundNodeConnected(0))
end

function checkNodes()
  swapLayer(entity.getInboundNodeLevel(0))
end

function onInteraction(args)
  if not entity.isInboundNodeConnected(0) then
    swapLayer(not storage.swapState)
  end
end

function swapLayer(newState)
  if newState ~= storage.swapState then
    storage.swapState = newState
    storage.transitionState = 3

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
  for i, pos in ipairs(storage.swapArea) do
    if blockData[i] then
      local success = world.placeMaterial(pos, targetLayer, blockData[i])
      if not success then
        --world.logInfo("failed to place block in "..targetLayer)

        --wouldn't this be cool? but NOPE
        --world.spawnItem(blockData[i].."material", pos, 1)
      end
    elseif targetLayer == "background" then
      local success = world.placeMaterial(pos, targetLayer, "invisitile")
      if not success then
        --world.logInfo("failed to place invisible tile in "..targetLayer)
      end
    end
  end
end

function main()
  if storage.transitionState > 0 then
    if storage.transitionState == 1 then
      --place stored blocks
      placeLayer("background", storage.fgData)
      placeLayer("foreground", storage.bgData)
    end

    storage.transitionState = storage.transitionState - 1
  end
end