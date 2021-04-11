## openresty dynamic upstream

openresty -p `pwd` -c conf/nginx.conf

most of the code is from [apisix](https://github.com/apache/apisix)

## api

**add host upstream**
```
curl "http://127.0.0.1:9080/upstreams" -X 'POST' -d '{"host": "demo.notr.tech", "ip": "127.0.0.1", "port": "8080"}' 
OK
```

**query host upstream**
```
curl "http://127.0.0.1:9080/upstreams?host=demo.notr.tech" -X 'GET'|python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    57    0    57    0     0  10083      0 --:--:-- --:--:-- --:--:-- 11400
{
    "host": "demo.notr.tech",
    "ip": "127.0.0.1",
    "port": "8080"
}
```

**delete host upstream**
```
curl "http://127.0.0.1:9080/upstreams?host=demo.notr.tech" -X 'DELETE'
OK
```
