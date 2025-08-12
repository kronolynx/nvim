local M = {}


---@enum MsgEvent
M.events = {
  show = "msg_show",
  clear = "msg_clear",
  showmode = "msg_showmode",
  showcmd = "msg_showcmd",
  ruler = "msg_ruler",
  history_show = "msg_history_show",
  history_clear = "msg_history_clear",
}

---@enum MsgKind
M.kinds = {
  -- echo
  empty = "",                      -- (empty) Unknown (consider a feature-request: |bugs|)
  echo = "echo",                   --  |:echo| message
  echomsg = "echomsg",             -- |:echomsg| message
  -- input related
  confirm = "confirm",             -- |confirm()| or |:confirm| dialog
  confirm_sub = "confirm_sub",     -- |:substitute| confirm dialog |:s_c|
  return_prompt = "return_prompt", -- |press-enter| prompt after a multiple messages
  -- error/warnings
  emsg = "emsg",                   --  Error (|errors|, internal error, |:throw|, …)
  echoerr = "echoerr",             -- |:echoerr| message
  lua_error = "lua_error",         -- Error in |:lua| code
  rpc_error = "rpc_error",         -- Error response from |rpcrequest()|
  wmsg = "wmsg",                   --  Warning ("search hit BOTTOM", |W10|, …)
  -- hints
  quickfix = "quickfix",           -- Quickfix navigation message
  search_count = "search_count",   -- Search count message ("S" flag of 'shortmess')
}

function M.is_error(kind)
  return vim.tbl_contains({ M.kinds.echoerr, M.kinds.lua_error, M.kinds.rpc_error, M.kinds.emsg }, kind)
end

function M.is_warning(kind)
  return kind == M.kinds.wmsg
end

function M.on_confirm(event, kind, content)
  vim.nofity("Got on confirm" .. event .. " kind: " .. kind .. " " .. content)
  return false
end

function M.on_return_prompt()
  return vim.api.nvim_input("<cr>")
end

function M.handler(event, kind, content)
  if kind == M.kinds.return_prompt then
    return M.on_return_prompt()
  elseif kind == M.kinds.confirm or kind == M.kinds.confirm_sub then
    return M.on_confirm(event, kind, content)
  end

  if M.is_error(kind) then
    print(content, "error")
    return true
  elseif M.is_warning(kind) then
    print(content, "warn")
    return true
  end

  -- we are not handling the event
  print("unhandled event: " .. event .. " kind: " .. kind .. " content: " .. content, "warn")
  return false
end

-- function M.handler2(event, ...) 
--     if event == 'msg_showcmd' then
--         -- handle msg_showcmd event
--         local args = {...}
--         print('msg_showcmd', unpack(args))
--     elseif event == 'msg_show' then
--         -- handle msg_show event
--         local args = {...}
--         print('msg_show', unpack(args))
--     elseif event == 'msg_clear' then
--         -- handle msg_clear event
--         print('msg_clear')
--     elseif event == 'msg_history_show' then
--         -- handle msg_history_show event
--         local args = {...}
--         print('msg_history_show', unpack(args))
--     end
-- end

function M.attach()
  vim.ui_attach(M.namespace, { ext_messages = true }, function(event, ...)
    if event == M.events.show then
    local kind, content, _ = ...
    -- print('msg event', event, kind, content)
    -- if event:match("msg") ~= nil then
    --   print('msg event', event, kind, content)
    return M.handler(event, kind, content)
    --   -- M.handler2(event, ...)---M.handler(event, kind, content)
    --   return true
    end
    return false -- not handled
  end)
end

function M.init()
  M.namespace = vim.api.nvim_create_namespace("Msg")
  M.attach()
end

return M
