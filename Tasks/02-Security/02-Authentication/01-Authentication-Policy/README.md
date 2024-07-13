```bash
# 使用 default 配置文件在 Kubernetes 集群上安装 Istio
istioctl install --set profile=default --set hub=docker-mirrors.alauda.cn/istio --set "values.gateways.istio-ingressgateway.type=NodePort"

# 我们的示例使用两个命名空间 foo 和 bar ，以及两个服务 httpbin 和 sleep ，两者都使用 Envoy 代理运行。
# 我们还使用 httpbin 和 sleep 的第二个实例，在 legacy 命名空间中没有 sidecar 的情况下运行。
kubectl create ns foo
kubectl apply -f <(istioctl kube-inject -f samples-1.19.0/httpbin/httpbin.yaml) -n foo
kubectl apply -f <(istioctl kube-inject -f samples-1.19.0/sleep/sleep.yaml) -n foo
kubectl create ns bar
kubectl apply -f <(istioctl kube-inject -f samples-1.19.0/httpbin/httpbin.yaml) -n bar
kubectl apply -f <(istioctl kube-inject -f samples-1.19.0/sleep/sleep.yaml) -n bar
kubectl create ns legacy
kubectl apply -f samples-1.19.0/httpbin/httpbin.yaml -n legacy
kubectl apply -f samples-1.19.0/sleep/sleep.yaml -n legacy

for from in "foo" "bar" "legacy"; do
	for to in "foo" "bar" "legacy"; do
		kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s "http://httpbin.${to}:8000/ip" -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"
	done
done

$ for from in "foo" "bar" "legacy"; do for to in "foo" "bar" "legacy"; do kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s "http://httpbin.${to}:8000/ip" -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"; done; done
sleep.foo to httpbin.foo: 200
sleep.foo to httpbin.bar: 200
sleep.foo to httpbin.legacy: 200
sleep.bar to httpbin.foo: 200
sleep.bar to httpbin.bar: 200
sleep.bar to httpbin.legacy: 200
sleep.legacy to httpbin.foo: 200
sleep.legacy to httpbin.bar: 200
sleep.legacy to httpbin.legacy: 200
$


# 自动双向 TLS
# 流量分为三种：
# 1、从网格外部进入网格的流量，也就是客户端在网格外部，服务端在网格内部
# 2、网格内部的流量，也就是客户端和服务端都在网格内部
# 3、从网格出去的流量，也就是客户端在网格内部，服务端在网格外部
# 自动双向 TLS指的是网格内部的流量会自动双向 TLS

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl -s http://httpbin.foo:8000/headers -s | grep X-Forwarded-Client-Cert | sed 's/Hash=[a-z0-9]*;/Hash=<redacted>;/'

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl http://httpbin.legacy:8000/headers -s | grep X-Forwarded-Client-Cert

for from in "foo" "bar" "legacy"; do
	for to in "foo" "bar" "legacy"; do
		echo "sleep.${from} to httpbin.${to}"
		kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s http://httpbin.${to}:8000/headers
	done
done

$ for from in "foo" "bar" "legacy"; do for to in "foo" "bar" "legacy"; do echo "sleep.${from} to httpbin.${to}"; kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s http://httpbin.${to}:8000/headers; done; done
sleep.foo to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "8c1493afd803493b",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "d0b1b7de58725137",
    "X-B3-Traceid": "4d6983c1dfafce7a8c1493afd803493b",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=1587e91b148718b3659692d0f495e3617743fb9e6c2cd2021b58ce1f4b017ee7;Subject=\"\";URI=spiffe://cluster.local/ns/foo/sa/sleep"
  }
}
sleep.foo to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "d661b6c157b7b419",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "0159f4158eb1cffe",
    "X-B3-Traceid": "7e1d31576cdfb64dd661b6c157b7b419",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/bar/sa/httpbin;Hash=1587e91b148718b3659692d0f495e3617743fb9e6c2cd2021b58ce1f4b017ee7;Subject=\"\";URI=spiffe://cluster.local/ns/foo/sa/sleep"
  }
}
sleep.foo to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "f0ccfc6ade8f50e6",
    "X-B3-Traceid": "fedf485ac6d1a201f0ccfc6ade8f50e6",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.legacy.svc.cluster.local:8000/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBXNsZWVwChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwosCgxJTlNUQU5DRV9JUFMSHBoaMTAuMy4yLjIxMSxmZDAwOjEwOjk2OjoyZDMKGQoNSVNUSU9fVkVSU0lPThIIGgYxLjE5LjAKoQEKBkxBQkVMUxKWASqTAQoOCgNhcHASBxoFc2xlZXAKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBXNsZWVwCi8KI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEggaBmxhdGVzdAoaCgdNRVNIX0lEEg8aDWNsdXN0ZXIubG9jYWwKHwoETkFNRRIXGhVzbGVlcC01NGNmOWNmYjgtdnJnanYKEgoJTkFNRVNQQUNFEgUaA2Zvbw==",
    "X-Envoy-Peer-Metadata-Id": "sidecar~10.3.2.211~sleep-54cf9cfb8-vrgjv.foo~foo.svc.cluster.local"
  }
}
sleep.bar to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "69af972ee10787bd",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "da14176b66cd6fab",
    "X-B3-Traceid": "3b468cfadb788a4e69af972ee10787bd",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=82934921c0b024906baf1612a42808986e0522bd302c91e4ddd7778d9c87bf62;Subject=\"\";URI=spiffe://cluster.local/ns/bar/sa/sleep"
  }
}
sleep.bar to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "8e397b44385738b1",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "a75f385242f94e77",
    "X-B3-Traceid": "96098607b5b418178e397b44385738b1",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/bar/sa/httpbin;Hash=82934921c0b024906baf1612a42808986e0522bd302c91e4ddd7778d9c87bf62;Subject=\"\";URI=spiffe://cluster.local/ns/bar/sa/sleep"
  }
}
sleep.bar to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "ace704b3e5d109da",
    "X-B3-Traceid": "82ddaa9fe46eee7eace704b3e5d109da",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.legacy.svc.cluster.local:8000/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBXNsZWVwChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwosCgxJTlNUQU5DRV9JUFMSHBoaMTAuMy4yLjIxMyxmZDAwOjEwOjk2OjoyZDUKGQoNSVNUSU9fVkVSU0lPThIIGgYxLjE5LjAKoQEKBkxBQkVMUxKWASqTAQoOCgNhcHASBxoFc2xlZXAKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBXNsZWVwCi8KI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEggaBmxhdGVzdAoaCgdNRVNIX0lEEg8aDWNsdXN0ZXIubG9jYWwKHwoETkFNRRIXGhVzbGVlcC01NGNmOWNmYjgteDR3YngKEgoJTkFNRVNQQUNFEgUaA2Jhcg==",
    "X-Envoy-Peer-Metadata-Id": "sidecar~10.3.2.213~sleep-54cf9cfb8-x4wbx.bar~bar.svc.cluster.local"
  }
}
sleep.legacy to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "c1af4295f2e2b7e9",
    "X-B3-Traceid": "04af338ab2a66d30c1af4295f2e2b7e9"
  }
}
sleep.legacy to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "81db25be1cef7d96",
    "X-B3-Traceid": "df778d81038cb48381db25be1cef7d96"
  }
}
sleep.legacy to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0"
  }
}
$

###########################################################################

# Globally enabling Istio mutual TLS in STRICT mode
# 流量分为三种：
# 1、从网格外部进入网格的流量，也就是客户端在网格外部，服务端在网格内部
# 2、网格内部的流量，也就是客户端和服务端都在网格内部
# 3、从网格出去的流量，也就是客户端在网格内部，服务端在网格外部
# 在 STRICT 模式下全局启用 Istio 双向 TLS，也就是从网格外部进入网格的流量和网格内部的流量必须是  mutual TLS，而从网格出去的流量可以是明文

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
  namespace: "istio-system"
spec:
  mtls:
    mode: STRICT
EOF

$ for from in "foo" "bar" "legacy"; do for to in "foo" "bar" "legacy"; do kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s "http://httpbin.${to}:8000/ip" -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"; done; done
sleep.foo to httpbin.foo: 200
sleep.foo to httpbin.bar: 200
sleep.foo to httpbin.legacy: 200
sleep.bar to httpbin.foo: 200
sleep.bar to httpbin.bar: 200
sleep.bar to httpbin.legacy: 200
sleep.legacy to httpbin.foo: 000
command terminated with exit code 56
sleep.legacy to httpbin.bar: 000
command terminated with exit code 56
sleep.legacy to httpbin.legacy: 200
$

$ for from in "foo" "bar" "legacy"; do for to in "foo" "bar" "legacy"; do echo "sleep.${from} to httpbin.${to}"; kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s http://httpbin.${to}:8000/headers; done; done
sleep.foo to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "73d9ff7582f03701",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "30c4603c9fcc7bc1",
    "X-B3-Traceid": "981e4e497cd783e673d9ff7582f03701",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=1587e91b148718b3659692d0f495e3617743fb9e6c2cd2021b58ce1f4b017ee7;Subject=\"\";URI=spiffe://cluster.local/ns/foo/sa/sleep"
  }
}
sleep.foo to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "6c9f14c33e7bc82c",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "e03e32cfd7dcce38",
    "X-B3-Traceid": "d7d159155fcaa0cb6c9f14c33e7bc82c",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/bar/sa/httpbin;Hash=1587e91b148718b3659692d0f495e3617743fb9e6c2cd2021b58ce1f4b017ee7;Subject=\"\";URI=spiffe://cluster.local/ns/foo/sa/sleep"
  }
}
sleep.foo to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "6f63084fb86657c7",
    "X-B3-Traceid": "3902e639a62baf466f63084fb86657c7",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.legacy.svc.cluster.local:8000/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBXNsZWVwChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwosCgxJTlNUQU5DRV9JUFMSHBoaMTAuMy4yLjIxMSxmZDAwOjEwOjk2OjoyZDMKGQoNSVNUSU9fVkVSU0lPThIIGgYxLjE5LjAKoQEKBkxBQkVMUxKWASqTAQoOCgNhcHASBxoFc2xlZXAKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBXNsZWVwCi8KI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEggaBmxhdGVzdAoaCgdNRVNIX0lEEg8aDWNsdXN0ZXIubG9jYWwKHwoETkFNRRIXGhVzbGVlcC01NGNmOWNmYjgtdnJnanYKEgoJTkFNRVNQQUNFEgUaA2Zvbw==",
    "X-Envoy-Peer-Metadata-Id": "sidecar~10.3.2.211~sleep-54cf9cfb8-vrgjv.foo~foo.svc.cluster.local"
  }
}
sleep.bar to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "5fd45aa4ce8a53d9",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "5c4156e9cdf137ef",
    "X-B3-Traceid": "44ac5c91ce08a4065fd45aa4ce8a53d9",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=82934921c0b024906baf1612a42808986e0522bd302c91e4ddd7778d9c87bf62;Subject=\"\";URI=spiffe://cluster.local/ns/bar/sa/sleep"
  }
}
sleep.bar to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "2d6437aa815f4a14",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "e66520906872c9c7",
    "X-B3-Traceid": "6fbeca320430f9532d6437aa815f4a14",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/bar/sa/httpbin;Hash=82934921c0b024906baf1612a42808986e0522bd302c91e4ddd7778d9c87bf62;Subject=\"\";URI=spiffe://cluster.local/ns/bar/sa/sleep"
  }
}
sleep.bar to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "8ada2919c71ec944",
    "X-B3-Traceid": "60359cdb3afcff0a8ada2919c71ec944",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.legacy.svc.cluster.local:8000/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBXNsZWVwChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwosCgxJTlNUQU5DRV9JUFMSHBoaMTAuMy4yLjIxMyxmZDAwOjEwOjk2OjoyZDUKGQoNSVNUSU9fVkVSU0lPThIIGgYxLjE5LjAKoQEKBkxBQkVMUxKWASqTAQoOCgNhcHASBxoFc2xlZXAKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBXNsZWVwCi8KI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEggaBmxhdGVzdAoaCgdNRVNIX0lEEg8aDWNsdXN0ZXIubG9jYWwKHwoETkFNRRIXGhVzbGVlcC01NGNmOWNmYjgteDR3YngKEgoJTkFNRVNQQUNFEgUaA2Jhcg==",
    "X-Envoy-Peer-Metadata-Id": "sidecar~10.3.2.213~sleep-54cf9cfb8-x4wbx.bar~bar.svc.cluster.local"
  }
}
sleep.legacy to httpbin.foo
command terminated with exit code 56
sleep.legacy to httpbin.bar
command terminated with exit code 56
sleep.legacy to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0"
  }
}
$

###########################################################################

# Enable mutual TLS per namespace or workload
# 流量分为三种：
# 1、从网格外部进入网格的流量，也就是客户端在网格外部，服务端在网格内部
# 2、网格内部的流量，也就是客户端和服务端都在网格内部
# 3、从网格出去的流量，也就是客户端在网格内部，服务端在网格外部

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
  namespace: "foo"
spec:
  mtls:
    mode: STRICT
EOF

$ for from in "foo" "bar" "legacy"; do for to in "foo" "bar" "legacy"; do kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s "http://httpbin.${to}:8000/ip" -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"; done; done
sleep.foo to httpbin.foo: 200
sleep.foo to httpbin.bar: 200
sleep.foo to httpbin.legacy: 200
sleep.bar to httpbin.foo: 200
sleep.bar to httpbin.bar: 200
sleep.bar to httpbin.legacy: 200
sleep.legacy to httpbin.foo: 000
command terminated with exit code 56
sleep.legacy to httpbin.bar: 200
sleep.legacy to httpbin.legacy: 200
$


$ for from in "foo" "bar" "legacy"; do for to in "foo" "bar" "legacy"; do echo "sleep.${from} to httpbin.${to}"; kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl -s http://httpbin.${to}:8000/headers; done; done
sleep.foo to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "2254baa478062f33",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "4bbbf5241608caf1",
    "X-B3-Traceid": "8c57baa136714c212254baa478062f33",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=1587e91b148718b3659692d0f495e3617743fb9e6c2cd2021b58ce1f4b017ee7;Subject=\"\";URI=spiffe://cluster.local/ns/foo/sa/sleep"
  }
}
sleep.foo to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "22192bbaded8e5d1",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "3423ec0dfa0b810e",
    "X-B3-Traceid": "5f98d952bec2855f22192bbaded8e5d1",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/bar/sa/httpbin;Hash=1587e91b148718b3659692d0f495e3617743fb9e6c2cd2021b58ce1f4b017ee7;Subject=\"\";URI=spiffe://cluster.local/ns/foo/sa/sleep"
  }
}
sleep.foo to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "ea9ccb5494a3c457",
    "X-B3-Traceid": "c7187202372fa2b2ea9ccb5494a3c457",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.legacy.svc.cluster.local:8000/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBXNsZWVwChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwosCgxJTlNUQU5DRV9JUFMSHBoaMTAuMy4yLjIxMSxmZDAwOjEwOjk2OjoyZDMKGQoNSVNUSU9fVkVSU0lPThIIGgYxLjE5LjAKoQEKBkxBQkVMUxKWASqTAQoOCgNhcHASBxoFc2xlZXAKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBXNsZWVwCi8KI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEggaBmxhdGVzdAoaCgdNRVNIX0lEEg8aDWNsdXN0ZXIubG9jYWwKHwoETkFNRRIXGhVzbGVlcC01NGNmOWNmYjgtdnJnanYKEgoJTkFNRVNQQUNFEgUaA2Zvbw==",
    "X-Envoy-Peer-Metadata-Id": "sidecar~10.3.2.211~sleep-54cf9cfb8-vrgjv.foo~foo.svc.cluster.local"
  }
}
sleep.bar to httpbin.foo
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.foo:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "cdff94d72d43d278",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "b4af30f0c3574d56",
    "X-B3-Traceid": "2c264c329e2c58abcdff94d72d43d278",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=82934921c0b024906baf1612a42808986e0522bd302c91e4ddd7778d9c87bf62;Subject=\"\";URI=spiffe://cluster.local/ns/bar/sa/sleep"
  }
}
sleep.bar to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Parentspanid": "db65c13086dfcfb6",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "dfd0ad0d806a5640",
    "X-B3-Traceid": "8b4fb26ff3271d58db65c13086dfcfb6",
    "X-Envoy-Attempt-Count": "1",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/bar/sa/httpbin;Hash=82934921c0b024906baf1612a42808986e0522bd302c91e4ddd7778d9c87bf62;Subject=\"\";URI=spiffe://cluster.local/ns/bar/sa/sleep"
  }
}
sleep.bar to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "9c92c029fc89566f",
    "X-B3-Traceid": "e12999a74d1841ae9c92c029fc89566f",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-Decorator-Operation": "httpbin.legacy.svc.cluster.local:8000/*",
    "X-Envoy-Peer-Metadata": "ChkKDkFQUF9DT05UQUlORVJTEgcaBXNsZWVwChoKCkNMVVNURVJfSUQSDBoKS3ViZXJuZXRlcwosCgxJTlNUQU5DRV9JUFMSHBoaMTAuMy4yLjIxMyxmZDAwOjEwOjk2OjoyZDUKGQoNSVNUSU9fVkVSU0lPThIIGgYxLjE5LjAKoQEKBkxBQkVMUxKWASqTAQoOCgNhcHASBxoFc2xlZXAKJAoZc2VjdXJpdHkuaXN0aW8uaW8vdGxzTW9kZRIHGgVpc3RpbwoqCh9zZXJ2aWNlLmlzdGlvLmlvL2Nhbm9uaWNhbC1uYW1lEgcaBXNsZWVwCi8KI3NlcnZpY2UuaXN0aW8uaW8vY2Fub25pY2FsLXJldmlzaW9uEggaBmxhdGVzdAoaCgdNRVNIX0lEEg8aDWNsdXN0ZXIubG9jYWwKHwoETkFNRRIXGhVzbGVlcC01NGNmOWNmYjgteDR3YngKEgoJTkFNRVNQQUNFEgUaA2Jhcg==",
    "X-Envoy-Peer-Metadata-Id": "sidecar~10.3.2.213~sleep-54cf9cfb8-x4wbx.bar~bar.svc.cluster.local"
  }
}
sleep.legacy to httpbin.foo
command terminated with exit code 56
sleep.legacy to httpbin.bar
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.bar:8000",
    "User-Agent": "curl/8.8.0",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "a7b6202fc587b67d",
    "X-B3-Traceid": "0ef5bf1570a8d40ba7b6202fc587b67d"
  }
}
sleep.legacy to httpbin.legacy
{
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.legacy:8000",
    "User-Agent": "curl/8.8.0"
  }
}
$


###########################################################################

cat <<EOF | kubectl apply -n bar -f -
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "httpbin"
  namespace: "bar"
spec:
  selector:
    matchLabels:
      app: httpbin
  mtls:
    mode: STRICT
EOF

cat <<EOF | kubectl apply -n bar -f -
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "httpbin"
  namespace: "bar"
spec:
  selector:
    matchLabels:
      app: httpbin
  mtls:
    mode: STRICT
  portLevelMtls:
    80:
      mode: DISABLE
EOF

cat <<EOF | kubectl apply -n foo -f -
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "overwrite-example"
  namespace: "foo"
spec:
  selector:
    matchLabels:
      app: httpbin
  mtls:
    mode: DISABLE
EOF

###########################################################################

$ kubectl apply -f samples-1.19.0/httpbin/httpbin-gateway.yaml -n foo
gateway.networking.istio.io/httpbin-gateway created
virtualservice.networking.istio.io/httpbin created
$

$ kubectl get nodes
NAME              STATUS   ROLES                               AGE   VERSION
192.168.130.193   Ready    <none>                              23h   v1.28.8
192.168.134.8     Ready    control-plane,cpaas-system,master   23h   v1.28.8
192.168.138.106   Ready    <none>                              23h   v1.28.8
192.168.143.35    Ready    <none>                              23h   v1.28.8

$ kubectl -n istio-system get services
NAME                   TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                                      AGE
istio-ingressgateway   NodePort    10.4.5.69     <none>        15021:32722/TCP,80:30533/TCP,443:30982/TCP   27m
istiod                 ClusterIP   10.4.43.133   <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP        27m

$ curl "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
200

$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
200
$

$ curl "192.168.134.8:30533/headers" -s
{
  "headers": {
    "Accept": "*/*",
    "Host": "192.168.134.8:30144",
    "User-Agent": "curl/7.29.0",
    "X-B3-Parentspanid": "b738c0d8305ee607",
    "X-B3-Sampled": "0",
    "X-B3-Spanid": "fe11e1be9d13624b",
    "X-B3-Traceid": "d7cb21a64837b6acb738c0d8305ee607",
    "X-Envoy-Attempt-Count": "1",
    "X-Envoy-External-Address": "100.64.0.3",
    "X-Forwarded-Client-Cert": "By=spiffe://cluster.local/ns/foo/sa/httpbin;Hash=c0ce337440178a9264b593c393e952fd165f30bee20b7bebcc81e11ee7d615a3;Subject=\"\";URI=spiffe://cluster.local/ns/istio-system/sa/istio-ingressgateway-service-account"
  }
}

###########################################################################

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata:
  name: "jwt-example"
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
  name: "jwt-example"
  namespace: istio-system
spec:
  selector:
    matchLabels:
      istio: ingressgateway
  jwtRules:
  - issuer: "testing@secure.istio.io"
    jwksUri: "https://gitee.com/lanzhiwang/istio/raw/learn-1.19.0/security/tools/jwt/samples/jwks.json"
EOF

cat https://raw.githubusercontent.com/istio/istio/release-1.19/security/tools/jwt/samples/jwks.json
{
  "keys":
  [
    {
      "e": "AQAB",
      "kid": "DHFbpoIUqrY8t2zpA2qXfCmr5VO5ZEr4RzHU_-envvQ",
      "kty": "RSA",
      "n": "xAE7eB6qugXyCAG3yhh7pkDkT65pHymX-P7KfIupjf59vsdo91bSP9C8H07pSAGQO1MV_xFj9VswgsCg4R6otmg5PV2He95lZdHtOcU5DXIg_pbhLdKXbi66GlVeK6ABZOUW3WYtnNHD-91gVuoeJT_DwtGGcp4ignkgXfkiEm4sw-4sfb4qdt5oLbyVpmW6x9cfa7vs2WTfURiCrBoUqgBo_-4WTiULmmHSGZHOjzwa8WtrtOQGsAFjIbno85jp6MnGGGZPYZbDAa_b3y5u-YpW7ypZrvD8BgtKVjgtQgZhLAGezMt0ua3DRrWnKqTZ0BJ_EyxOGuHJrLsn00fnMQ"
    }
  ]
}

# 如果您在授权标头（其隐式默认位置）中提供令牌，Istio 将使用公钥集验证令牌，并在持有令牌无效时拒绝请求。
# 但是，不带令牌的请求也会被接受。要观察此行为，请在不带令牌、使用错误令牌和使用有效令牌的情况下重试请求：

$ curl "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
200
$

$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
401
$

TOKEN=eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjQ2ODU5ODk3MDAsImZvbyI6ImJhciIsImlhdCI6MTUzMjM4OTcwMCwiaXNzIjoidGVzdGluZ0BzZWN1cmUuaXN0aW8uaW8iLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.CfNnxWP2tcnR9q0vxyxweaF3ovQYHYZl82hAUsn21bwQd9zP7c-LS9qd_vpdLG4Tn1A15NxfCjp5f7QNBUo-KC9PJqYpgGbaXhaGx7bEdFWjcwv3nZzvc7M__ZpaCERdwU7igUmJqYGBYQ51vr2njU9ZimyKkfDe3axcyiBZde7G6dabliUosJvvKOPcKIWPccCgefSj_GNfwIip3-SsFdlR7BtbVUcqR-yv-XOxJ3Uc1MI0tz3uMiiZcyPV7sNCU4KRnemRIMHVOfuvHsU60_GhGbiSFzgPTAa9WTltbnarTbxudb_YEOx12JiwYToeX0DCPb43W1tzIBxgm8NxUg
$ curl --header "Authorization: Bearer $TOKEN" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
200
$

cat https://raw.githubusercontent.com/istio/istio/release-1.19/security/tools/jwt/samples/demo.jwt
eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjQ2ODU5ODk3MDAsImZvbyI6ImJhciIsImlhdCI6MTUzMjM4OTcwMCwiaXNzIjoidGVzdGluZ0BzZWN1cmUuaXN0aW8uaW8iLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.CfNnxWP2tcnR9q0vxyxweaF3ovQYHYZl82hAUsn21bwQd9zP7c-LS9qd_vpdLG4Tn1A15NxfCjp5f7QNBUo-KC9PJqYpgGbaXhaGx7bEdFWjcwv3nZzvc7M__ZpaCERdwU7igUmJqYGBYQ51vr2njU9ZimyKkfDe3axcyiBZde7G6dabliUosJvvKOPcKIWPccCgefSj_GNfwIip3-SsFdlR7BtbVUcqR-yv-XOxJ3Uc1MI0tz3uMiiZcyPV7sNCU4KRnemRIMHVOfuvHsU60_GhGbiSFzgPTAa9WTltbnarTbxudb_YEOx12JiwYToeX0DCPb43W1tzIBxgm8NxUg

###########################################################################

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: "frontend-ingress"
  namespace: istio-system
spec:
  selector:
    matchLabels:
      istio: ingressgateway
  action: DENY
  rules:
  - from:
    - source:
        notRequestPrincipals: ["*"]
EOF

$ curl "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
403

$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
401

$ curl --header "Authorization: Bearer $TOKEN" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
200

###########################################################################

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: "frontend-ingress"
  namespace: istio-system
spec:
  selector:
    matchLabels:
      istio: ingressgateway
  action: DENY
  rules:
  - from:
    - source:
        notRequestPrincipals: ["*"]
    to:
    - operation:
        paths: ["/headers"]
EOF

$ curl "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
403

$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
401

$ curl --header "Authorization: Bearer $TOKEN" "192.168.134.8:30533/headers" -s -o /dev/null -w "%{http_code}\n"
200

$ curl "192.168.134.8:30533/ip" -s -o /dev/null -w "%{http_code}\n"
200

$ curl --header "Authorization: Bearer deadbeef" "192.168.134.8:30533/ip" -s -o /dev/null -w "%{http_code}\n"
401

$ curl --header "Authorization: Bearer $TOKEN" "192.168.134.8:30533/ip" -s -o /dev/null -w "%{http_code}\n"
200

```
