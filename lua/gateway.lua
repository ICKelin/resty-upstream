local ngx = ngx
local ngx_req = ngx.req
local ngx_var = ngx.var
local log = require("comm.log")
local resp = require("comm.resp")
local upstream = require("core.upstream")
local ngx_balancer = require("ngx.balancer") 

local _M = {}

function _M.init()
    require("resty.core")
    require("ngx.re").opt("jit_stack_size", 200 * 1024)
    require("jit.opt").start("minstitch=2", "maxtrace=4000",
                             "maxrecord=8000", "sizemcode=64",
                             "maxmcode=4000", "maxirconst=1000")
end


function _M.init_worker()
    log.info("phase: ", ngx.get_phase())
    upstream.init_worker()
end


function _M.balancer_phase()
    local scheme = ngx_var.scheme
    local http2 = ngx_var.http2
    local host = ngx_var.host
    if http2 ~= "" then
        scheme = http2
    end

    local node = upstream.get_node(scheme, host)
    if not node then
        resp(502)
        return
    end

    local ok, err = ngx_balancer.set_current_peer(node.ip, node.port)
    if not ok then
        log.error("set to set peer: ",err)
        resp(502)
    end
end

return _M