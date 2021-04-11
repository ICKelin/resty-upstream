
local ngx = ngx
local pcall = pcall
local log = require("comm.log")
local new_tab = require("table.new")

local _M = {}
local upstreams = {}

do 
    local running

function _M.print_stat(premature)
    if premature or running then
        return
    end

    running = true
    for k, v  in pairs(upstreams) do
        log.info(k, "=>", v.ip, ":", v.port)
    end
    running = false
end

end -- do


function _M.get_node(host) 
    return upstreams[host]
end


function _M.del_node(host)
    if upstreams[host] then
        upstreams[host] = nil
    end
end


function _M.set_node(node_info)
    local host = node_info.host
    local ip = node_info.ip
    local port = node_info.port
    log.info("host: ", host, " ip: ", ip, " port: ", port)
    upstreams[host] = node_info
end


function _M.init_worker()
    ngx.timer.every(10, _M.print_stat)
end


return _M