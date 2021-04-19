
local ngx = ngx
local ngx_var = ngx.var
local pcall = pcall
local log = require("comm.log")
local new_tab = require("table.new")
local decode_json = require("cjson.safe").decode
local encode_json = require("cjson.safe").encode

local _M = {}
local upstream = ngx.shared.stream_upstream

function _M.get_node(scheme, listen_addr) 
    local key = scheme.."://"..listen_addr
    local val = streams:get(key)
    log.info("scheme ", scheme, " listen addr ", listen_addr, " node info: ", val)
    return decode_json(val)
end


function _M.del_node(scheme, listen_addr)
    local key = scheme.."://"..listen_addr
    log.info("del node ", key)
    streams:delete(key)
end


function _M.set_node(node_info)
    local listen_addr = node_info.listen_addr
    local scheme = node_info.scheme
    local value = encode_json(node_info)

    local key = scheme.."://"..host
    log.info("key: ", key, " listen addr: ", listen_addr)
    streams:set(key, value)
end


function _M.init_worker()
end


return _M