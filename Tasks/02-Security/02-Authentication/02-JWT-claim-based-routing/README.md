```bash
istioctl install --set profile=demo --set hub=docker-mirrors.alauda.cn/istio --set "values.gateways.istio-ingressgateway.type=NodePort"

kubectl create ns foo
kubectl apply -f <(istioctl kube-inject -f samples-1.19.0/httpbin/httpbin.yaml) -n foo
kubectl apply -f samples-1.19.0/httpbin/httpbin-gateway.yaml -n foo

$ kubectl get nodes
NAME              STATUS   ROLES                               AGE   VERSION
192.168.130.193   Ready    <none>                              22h   v1.28.8
192.168.134.8     Ready    control-plane,cpaas-system,master   22h   v1.28.8
192.168.138.106   Ready    <none>                              22h   v1.28.8
192.168.143.35    Ready    <none>                              22h   v1.28.8

$ kubectl -n istio-system get services
NAME                   TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                                                                      AGE
istio-egressgateway    ClusterIP   10.4.95.169   <none>        80/TCP,443/TCP                                                               45s
istio-ingressgateway   NodePort    10.4.107.3    <none>        15021:31174/TCP,80:32552/TCP,443:31753/TCP,31400:30579/TCP,15443:30135/TCP   45s
istiod                 ClusterIP   10.4.78.68    <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP                                        52s


$ curl "192.168.134.8:32552"/headers -s -o /dev/null -w "%{http_code}\n"
200

$ kubectl get pods -A  -l istio=ingressgateway
NAMESPACE      NAME                                    READY   STATUS    RESTARTS   AGE
istio-system   istio-ingressgateway-79fbdb5d5f-fcls4   1/1     Running   0          4m45s
$

#############################################################################################

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata:
  name: ingress-jwt
  namespace: istio-system
spec:
  selector:
    matchLabels:
      istio: ingressgateway
  jwtRules:
  - issuer: "testing@secure.istio.io"
    jwksUri: "https://raw.githubusercontent.com/istio/istio/release-1.19/security/tools/jwt/samples/jwks.json"
EOF

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata:
  name: ingress-jwt
  namespace: istio-system
spec:
  selector:
    matchLabels:
      istio: ingressgateway
  jwtRules:
  - issuer: "testing@secure.istio.io"
    jwksUri: "https://gitee.com/lanzhiwang/istio/raw/learn-1.19.0/security/tools/jwt/samples/jwks.json"
EOF

$ curl "192.168.134.8:32552"/headers -s -o /dev/null -w "%{http_code}\n"
200
$ curl "192.168.134.8:32552"/ip -s -o /dev/null -w "%{http_code}\n"
200

$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:32552/headers" -s -o /dev/null -w "%{http_code}\n"
401
$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:32552/ip" -s -o /dev/null -w "%{http_code}\n"
401

TOKEN=eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjQ2ODU5ODk3MDAsImZvbyI6ImJhciIsImlhdCI6MTUzMjM4OTcwMCwiaXNzIjoidGVzdGluZ0BzZWN1cmUuaXN0aW8uaW8iLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.CfNnxWP2tcnR9q0vxyxweaF3ovQYHYZl82hAUsn21bwQd9zP7c-LS9qd_vpdLG4Tn1A15NxfCjp5f7QNBUo-KC9PJqYpgGbaXhaGx7bEdFWjcwv3nZzvc7M__ZpaCERdwU7igUmJqYGBYQ51vr2njU9ZimyKkfDe3axcyiBZde7G6dabliUosJvvKOPcKIWPccCgefSj_GNfwIip3-SsFdlR7BtbVUcqR-yv-XOxJ3Uc1MI0tz3uMiiZcyPV7sNCU4KRnemRIMHVOfuvHsU60_GhGbiSFzgPTAa9WTltbnarTbxudb_YEOx12JiwYToeX0DCPb43W1tzIBxgm8NxUg

$ curl --header "Authorization: Bearer $TOKEN" "192.168.134.8:32552/headers" -s -o /dev/null -w "%{http_code}\n"
200
$ curl --header "Authorization: Bearer $TOKEN" "192.168.134.8:32552/ip" -s -o /dev/null -w "%{http_code}\n"
200

kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: httpbin
  namespace: foo
spec:
  hosts:
  - "*"
  gateways:
  - httpbin-gateway
  http:
  - match:
    - uri:
        prefix: /headers
      headers:
        "@request.auth.claims.groups":
          exact: group1
    route:
    - destination:
        port:
          number: 8000
        host: httpbin
EOF


#############################################################################################

$ curl -s -I "http://192.168.134.8:32552/headers"
HTTP/1.1 404 Not Found
date: Sat, 13 Jul 2024 07:45:30 GMT
server: istio-envoy
transfer-encoding: chunked

$ curl -s -I "http://192.168.134.8:32552/ip"
HTTP/1.1 404 Not Found
date: Sat, 13 Jul 2024 07:45:50 GMT
server: istio-envoy
transfer-encoding: chunked


$ curl -s -I "http://192.168.134.8:32552/headers" -H "Authorization: Bearer some.invalid.token"
HTTP/1.1 401 Unauthorized
www-authenticate: Bearer realm="http://192.168.134.8:32552/headers", error="invalid_token"
content-length: 29
content-type: text/plain
date: Sat, 13 Jul 2024 07:46:29 GMT
server: istio-envoy

$ curl -s -I "http://192.168.134.8:32552/ip" -H "Authorization: Bearer some.invalid.token"
HTTP/1.1 401 Unauthorized
www-authenticate: Bearer realm="http://192.168.134.8:32552/ip", error="invalid_token"
content-length: 29
content-type: text/plain
date: Sat, 13 Jul 2024 07:46:45 GMT
server: istio-envoy

$


cat https://raw.githubusercontent.com/istio/istio/release-1.19/security/tools/jwt/samples/groups-scope.jwt
eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjM1MzczOTExMDQsImdyb3VwcyI6WyJncm91cDEiLCJncm91cDIiXSwiaWF0IjoxNTM3MzkxMTA0LCJpc3MiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyIsInNjb3BlIjpbInNjb3BlMSIsInNjb3BlMiJdLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.EdJnEZSH6X8hcyEii7c8H5lnhgjB5dwo07M5oheC8Xz8mOllyg--AHCFWHybM48reunF--oGaG6IXVngCEpVF0_P5DwsUoBgpPmK1JOaKN6_pe9sh0ZwTtdgK_RP01PuI7kUdbOTlkuUi2AO-qUyOm7Art2POzo36DLQlUXv8Ad7NBOqfQaKjE9ndaPWT7aexUsBHxmgiGbz1SyLH879f7uHYPbPKlpHU6P9S-DaKnGLaEchnoKnov7ajhrEhGXAQRukhDPKUHO9L30oPIr5IJllEQfHYtt6IZvlNUGeLUcif3wpry1R5tBXRicx2sXMQ7LyuDremDbcNy_iE76Upg


$ TOKEN_GROUP=eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjM1MzczOTExMDQsImdyb3VwcyI6WyJncm91cDEiLCJncm91cDIiXSwiaWF0IjoxNTM3MzkxMTA0LCJpc3MiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyIsInNjb3BlIjpbInNjb3BlMSIsInNjb3BlMiJdLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.EdJnEZSH6X8hcyEii7c8H5lnhgjB5dwo07M5oheC8Xz8mOllyg--AHCFWHybM48reunF--oGaG6IXVngCEpVF0_P5DwsUoBgpPmK1JOaKN6_pe9sh0ZwTtdgK_RP01PuI7kUdbOTlkuUi2AO-qUyOm7Art2POzo36DLQlUXv8Ad7NBOqfQaKjE9ndaPWT7aexUsBHxmgiGbz1SyLH879f7uHYPbPKlpHU6P9S-DaKnGLaEchnoKnov7ajhrEhGXAQRukhDPKUHO9L30oPIr5IJllEQfHYtt6IZvlNUGeLUcif3wpry1R5tBXRicx2sXMQ7LyuDremDbcNy_iE76Upg && echo "$TOKEN_GROUP" | cut -d '.' -f2 - | base64 --decode
{"exp":3537391104,"groups":["group1","group2"],"iat":1537391104,"iss":"testing@secure.istio.io","scope":["scope1","scope2"],"sub":"testing@secure.istio.io"}

$ curl -s -I "http://192.168.134.8:32552/headers" -H "Authorization: Bearer $TOKEN_GROUP"
HTTP/1.1 200 OK
server: istio-envoy
date: Sat, 13 Jul 2024 07:49:18 GMT
content-type: application/json
content-length: 609
access-control-allow-origin: *
access-control-allow-credentials: true
x-envoy-upstream-service-time: 12

$ curl -s -I "http://192.168.134.8:32552/ip" -H "Authorization: Bearer $TOKEN_GROUP"
HTTP/1.1 404 Not Found
date: Sat, 13 Jul 2024 07:49:28 GMT
server: istio-envoy
transfer-encoding: chunked


cat https://raw.githubusercontent.com/istio/istio/release-1.19/security/tools/jwt/samples/demo.jwt
eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjQ2ODU5ODk3MDAsImZvbyI6ImJhciIsImlhdCI6MTUzMjM4OTcwMCwiaXNzIjoidGVzdGluZ0BzZWN1cmUuaXN0aW8uaW8iLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.CfNnxWP2tcnR9q0vxyxweaF3ovQYHYZl82hAUsn21bwQd9zP7c-LS9qd_vpdLG4Tn1A15NxfCjp5f7QNBUo-KC9PJqYpgGbaXhaGx7bEdFWjcwv3nZzvc7M__ZpaCERdwU7igUmJqYGBYQ51vr2njU9ZimyKkfDe3axcyiBZde7G6dabliUosJvvKOPcKIWPccCgefSj_GNfwIip3-SsFdlR7BtbVUcqR-yv-XOxJ3Uc1MI0tz3uMiiZcyPV7sNCU4KRnemRIMHVOfuvHsU60_GhGbiSFzgPTAa9WTltbnarTbxudb_YEOx12JiwYToeX0DCPb43W1tzIBxgm8NxUg


$ TOKEN_NO_GROUP=eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjQ2ODU5ODk3MDAsImZvbyI6ImJhciIsImlhdCI6MTUzMjM4OTcwMCwiaXNzIjoidGVzdGluZ0BzZWN1cmUuaXN0aW8uaW8iLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.CfNnxWP2tcnR9q0vxyxweaF3ovQYHYZl82hAUsn21bwQd9zP7c-LS9qd_vpdLG4Tn1A15NxfCjp5f7QNBUo-KC9PJqYpgGbaXhaGx7bEdFWjcwv3nZzvc7M__ZpaCERdwU7igUmJqYGBYQ51vr2njU9ZimyKkfDe3axcyiBZde7G6dabliUosJvvKOPcKIWPccCgefSj_GNfwIip3-SsFdlR7BtbVUcqR-yv-XOxJ3Uc1MI0tz3uMiiZcyPV7sNCU4KRnemRIMHVOfuvHsU60_GhGbiSFzgPTAa9WTltbnarTbxudb_YEOx12JiwYToeX0DCPb43W1tzIBxgm8NxUg && echo "$TOKEN_NO_GROUP" | cut -d '.' -f2 - | base64 --decode
{"exp":4685989700,"foo":"bar","iat":1532389700,"iss":"testing@secure.istio.io","sub":"testing@secure.istio.io"}

$ curl -s -I "http://192.168.134.8:32552/headers" -H "Authorization: Bearer $TOKEN_NO_GROUP"
HTTP/1.1 404 Not Found
date: Sat, 13 Jul 2024 07:51:33 GMT
server: istio-envoy
transfer-encoding: chunked

$ curl -s -I "http://192.168.134.8:32552/ip" -H "Authorization: Bearer $TOKEN_NO_GROUP"
HTTP/1.1 404 Not Found
date: Sat, 13 Jul 2024 07:51:43 GMT
server: istio-envoy
transfer-encoding: chunked


```

