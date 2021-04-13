
local ngx = ngx
local ngx_var = ngx.var
local pcall = pcall
local log = require("comm.log")
local new_tab = require("table.new")
local decode_json = require("cjson.safe").decode
local encode_json = require("cjson.safe").encode

local _M = {}
local upstreams = ngx.shared.upstreams


function _M.get_node(scheme, host) 
    local key = scheme.."://"..host
    local val = upstreams:get(key)
    log.info("scheme ", scheme, " host ", host, " node info: ", val)
    return decode_json(val)
end


function _M.del_node(scheme, host)
    local key = scheme.."://"..host
    upstreams:delete(key)
end


function _M.set_node(node_info)
    local host = node_info.host
    local ip = node_info.ip
    local port = node_info.port
    local scheme = node_info.scheme
    local value = encode_json(node_info)

    local key = scheme.."://"..host
    log.info("key: ", key, " ip: ", ip, " port: ", port)
    upstreams:set(key, value)
end


function _M.init_worker()
end


return _M