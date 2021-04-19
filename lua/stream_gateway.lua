local ngx = ngx
local ngx_req = ngx.req
local ngx_var = ngx.var
local log = require("comm.log")
local resp = require("comm.resp")
local upstream = require("core.stream_upstream")
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
    log.info("phase: ", ngx.get_phase())
end


return _M