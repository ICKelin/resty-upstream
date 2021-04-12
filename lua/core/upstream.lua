
local ngx = ngx
local pcall = pcall
local log = require("comm.log")
local new_tab = require("table.new")
local decode_json = require("cjson.safe").decode
local encode_json = require("cjson.safe").encode

local _M = {}
local upstreams = ngx.shared.upstreams


function _M.get_node(host) 
    local val = upstreams:get(host)
    log.info("host ", host, " node info: ", val)
    return decode_json(val)
end


function _M.del_node(host)
    upstreams:delete(host)
end


function _M.set_node(node_info)
    local host = node_info.host
    local ip = node_info.ip
    local port = node_info.port
    local value = encode_json(node_info)
    log.info("host: ", host, " ip: ", ip, " port: ", port)
    upstreams:set(host, value)
end


function _M.init_worker()
end


return _M