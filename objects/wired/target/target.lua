function onEntityDetected(entityId, entityType)
  if entityType == "projectile" then
    --clean up projectiles that hit targets, not sure whether this a good way to do it
    --world.logInfo(world.callScriptedEntity(entityId, "moveDown", 100))
    entity.setColliding(true)
  end
end

function onTick()
  if entity.animationState("switchState") == "off" then
    entity.setColliding(false)
  end
end