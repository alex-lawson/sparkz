function init(args)
  object.setInteractive(true)
  object.setAllOutboundNodes(false)
  object.setAnimationState("switchState", "off")
  self.countdown = 0
end

function trigger()
  object.setAllOutboundNodes(true)
  object.setAnimationState("switchState", "on")
  self.countdown = object.configParameter("detectTickDuration")
end

function onInteraction(args)
  trigger()
end

function main() 
  if self.countdown > 0 then
    self.countdown = self.countdown - 1
  else
    if self.countdown == 0 then
      local radius = object.configParameter("detectRadius")
      local entityIds = world.entityQuery(object.position(), radius, { notAnObject = true })
      if #entityIds > 0 then
        trigger()
      else
        object.setAllOutboundNodes(false)
        object.setAnimationState("switchState", "off")
      end
    end
  end
end