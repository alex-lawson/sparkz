function isDataWireObject()
  return true
end

function onInboundNodeChange(args)
  --do we even do anything with boolean wire signals? have to think about this as an additional data channel
  --should probably ignore it since some objects use both binary and data wires for separate functions
end

function onNodeConnectionChange()
  --world.logInfo("in onNodeConnectionChange()")
  queryNodes()
end

function queryNodes()
  storage.outboundConnections = {}
  local i = 0
  while i < entity.outboundNodeCount() do
    storage.outboundConnections[i] = entity.getOutboundNodeIds(i)
    i = i + 1
  end

  storage.inboundConnections = {}
  local entityIds
  i = 0
  while i < entity.inboundNodeCount() do
    entityIds = entity.getInboundNodeIds(i)
    for j, entityId in ipairs(entityIds) do
      storage.inboundConnections[entityId] = i
    end
    i = i + 1
  end

  --world.logInfo(string.format("%s finished querying %d outbound and %d inbound nodes", entity.configParameter("objectName"), entity.outboundNodeCount(), entity.inboundNodeCount()))
  --world.logInfo(storage.outboundConnections)
  --world.logInfo(storage.inboundConnections)
end

function sendData(data, nodeId)
  if nodeId == "all" then
    local i = 0
    while i < entity.outboundNodeCount() do
      sendData(data, i)
      i = i + 1
    end
  else
    if storage.outboundConnections[nodeId] and #storage.outboundConnections[nodeId] > 0 then 
      --world.logInfo(storage.outboundConnections[nodeId])
      for i, entityId in ipairs(storage.outboundConnections[nodeId]) do
        if entityId ~= entity.id() then
          world.callScriptedEntity(entityId, "receiveData", { data, entity.id() })
        end
      end
    end
  end
end

function receiveData(args)
  local data = args[1]
  local sourceEntityId = args[2]
  
  --convert entityId to nodeId
  local nodeId = storage.inboundConnections[sourceEntityId]

  if nodeId ~= nil and validateData(data, nodeId) then
    onValidDataReceived(data, nodeId)

    --TODO: remove for production
    --world.logInfo(string.format("DataWire: object received data"))
    --world.logInfo(data)
  else
    --TODO: remove for production
    --world.logInfo(string.format("DataWire: object received INVALID data"))
    --world.logInfo(data)
  end

  return true
end

function validateData(data, nodeId)
  --to be implemented by object
  return true
end

function onValidDataReceived(data, nodeId)
  --to be implemented by object
end