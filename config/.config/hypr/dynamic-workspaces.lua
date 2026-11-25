-- Keep occupied workspaces and one empty workspace at the end of each bar.
-- Numbered slots keep their existing shortcuts. Named workspaces extend the
-- list without using the following monitor's numbered slots.
local overflow_pattern = "^omarchy%-dynamic%-(%d+)%-(%d+)$"

local function workspace_list(monitor)
  local slots = o.workspaces.slots
  local base = o.workspaces.workspace_id(monitor, 1) - 1
  local block = base // slots
  local active = monitor.active_workspace
  local owned, guests, taken = {}, {}, {}
  local highest, active_empty = 0, nil

  for _, workspace in ipairs(hl.get_workspaces()) do
    local id = workspace.id
    local overflow_block, overflow_slot = workspace.name:match(overflow_pattern)
    overflow_slot = tonumber(overflow_slot)
    if not workspace.special and (id > 0 or overflow_slot) then
      local slot
      local key = tostring(id)
      local local_workspace = workspace.monitor and workspace.monitor.name == monitor.name
      if id > base and id <= base + slots then
        slot = id - base
      elseif overflow_slot then
        key = "name:" .. workspace.name
        if tonumber(overflow_block) == block and overflow_slot > slots then
          if local_workspace then
            slot = overflow_slot
          else
            taken[overflow_slot] = true
          end
        end
      end

      local entry = {
        key = key,
        slot = slot,
        id = id,
        occupied = workspace.windows > 0,
        active = active ~= nil and id == active.id,
        guest = not slot,
      }
      if slot then
        if entry.occupied then
          highest = math.max(highest, slot)
          owned[#owned + 1] = entry
        elseif entry.active then
          active_empty = entry
        end
      elseif local_workspace and (entry.occupied or entry.active) then
        guests[#guests + 1] = entry
      end
    end
  end

  local trailing = highest + 1
  if active_empty then
    if active_empty.slot > highest then
      trailing = active_empty.slot
    else
      owned[#owned + 1] = active_empty
    end
  end
  while taken[trailing] do
    trailing = trailing + 1
  end

  table.sort(owned, function(left, right) return left.slot < right.slot end)
  table.sort(guests, function(left, right) return left.id < right.id end)
  for _, guest in ipairs(guests) do
    owned[#owned + 1] = guest
  end

  local key = trailing <= slots and tostring(base + trailing)
    or string.format("name:omarchy-dynamic-%d-%d", block, trailing)
  owned[#owned + 1] = {
    key = key,
    slot = trailing,
    occupied = false,
    active = active_empty ~= nil and active_empty.slot == trailing,
    guest = false,
  }
  return owned
end

-- Read by the bar with hyprctl repl. Keys contain only numeric IDs or the
-- generated names above, so their Lua-quoted form is also a JSON string.
function o.dynamic_workspace_model(monitor_name)
  local monitor = hl.get_monitor(monitor_name)
  local rows = {}
  if monitor then
    for _, entry in ipairs(workspace_list(monitor)) do
      rows[#rows + 1] = string.format(
        '{"key":%q,"occupied":%s,"active":%s,"guest":%s}',
        entry.key, tostring(entry.occupied), tostring(entry.active), tostring(entry.guest)
      )
    end
  end
  return "[" .. table.concat(rows, ",") .. "]"
end

local function focus(monitor, entry)
  if entry.slot and entry.slot <= o.workspaces.slots then
    o.workspaces.focus(entry.slot, monitor.name)()
  else
    if not monitor.focused then
      hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
    end
    hl.dispatch(hl.dsp.focus({ workspace = entry.key }))
  end
end

-- Called by the bar. Recheck the destination in case the list changed.
function o.focus_dynamic_workspace(monitor_name, key)
  return function()
    local monitor = hl.get_monitor(monitor_name)
    if not monitor then
      return
    end
    for _, entry in ipairs(workspace_list(monitor)) do
      if entry.key == key then
        focus(monitor, entry)
        return
      end
    end
  end
end

function o.step_dynamic_workspace(offset, move_window)
  local function step()
    local monitor = hl.get_active_monitor()
    local workspace = monitor and monitor.active_workspace
    if not workspace or workspace.special then
      return
    end

    local entries = workspace_list(monitor)
    local index
    for i, entry in ipairs(entries) do
      if entry.active then
        index = i
        break
      end
    end
    if not index then
      return
    end

    if move_window then
      local target = entries[index + offset]
      local window = hl.get_active_window()
      if not target or not window or window.pinned or not window.workspace
        or window.workspace.id ~= workspace.id then
        return
      end
      if target.slot and target.slot <= o.workspaces.slots then
        o.workspaces.move_window(target.slot)()
      else
        hl.dispatch(hl.dsp.window.move({ workspace = target.key, window = "address:" .. window.address }))
      end
    else
      local next_index = (index - 1 + offset) % #entries + 1
      if next_index ~= index then
        focus(monitor, entries[next_index])
      end
    end
  end
  o.bind_expressions[step] = string.format("o.step_dynamic_workspace(%d, %s)", offset, tostring(move_window))
  return step
end
