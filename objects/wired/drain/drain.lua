function init(args)
  if storage.state == nil then
    output(false)
  else
    output(storage.state)
  end
end

function output(state)
  if state ~= storage.state then
    storage.state = state
    if state then
      entity.setAnimationState("drainState", "on")
    else
      entity.setAnimationState("drainState", "off")
    end
  end
end

function main(args)
  if entity.getInboundNodeLevel(0) then
    output(true)

    pos = {entity.position(), {entity.position()[1] + 1, entity.position()[2]}, {entity.position()[1] - 1, entity.position()[2]}}

    if world.liquidAt(pos[1]) then
      world.spawnProjectile("destroyliquid", pos[2], entity.id(), {-1, 0}, false, {})
      world.spawnProjectile("destroyliquid", pos[3], entity.id(), {1, 0}, false, {})
    end
  else
    output(false)
  end
end