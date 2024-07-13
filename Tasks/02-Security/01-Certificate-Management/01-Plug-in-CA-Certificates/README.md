```bash

$ make -f ../tools/certs/Makefile.selfsigned.mk -n --just-print root-ca
echo "generating root-key.pem"
openssl genrsa -out root-key.pem 4096
echo "[ req ]" > root-ca.conf
echo "encrypt_key = no" >> root-ca.conf
echo "prompt = no" >> root-ca.conf
echo "utf8 = yes" >> root-ca.conf
echo "default_md = sha256" >> root-ca.conf
echo "default_bits = 4096" >> root-ca.conf
echo "req_extensions = req_ext" >> root-ca.conf
echo "x509_extensions = req_ext" >> root-ca.conf
echo "distinguished_name = req_dn" >> root-ca.conf
echo "[ req_ext ]" >> root-ca.conf
echo "subjectKeyIdentifier = hash" >> root-ca.conf
echo "basicConstraints = critical, CA:true" >> root-ca.conf
echo "keyUsage = critical, digitalSignature, nonRepudiation, keyEncipherment, keyCertSign" >> root-ca.conf
echo "[ req_dn ]" >> root-ca.conf
echo "O = Istio" >> root-ca.conf
echo "CN = Root CA" >> root-ca.conf
echo "generating root-cert.csr"
openssl req -sha256 -new -key root-key.pem -config root-ca.conf -out root-cert.csr
echo "generating root-cert.pem"
openssl x509 -req -sha256 -days 3650 -signkey root-key.pem \
		-extensions req_ext -extfile root-ca.conf \
		-in root-cert.csr -out root-cert.pem


$ make -f ../tools/certs/Makefile.selfsigned.mk root-ca
generating root-key.pem
generating root-cert.csr
generating root-cert.pem
Certificate request self-signature ok
subject=O=Istio, CN=Root CA


$ tree -a .
.
├── root-ca.conf  # openssl 生成根证书的配置
├── root-cert.csr  # 为根证书生成的 CSR
├── root-cert.pem  # 生成的根证书
└── root-key.pem  # 生成的根密钥

1 directory, 4 files
$


$ make -f ../tools/certs/Makefile.selfsigned.mk -n --just-print cluster1-cacerts
echo "generating cluster1/ca-key.pem"
mkdir -p cluster1/
openssl genrsa -out cluster1/ca-key.pem 4096
echo "[ req ]" > cluster1/intermediate.conf
echo "encrypt_key = no" >> cluster1/intermediate.conf
echo "prompt = no" >> cluster1/intermediate.conf
echo "utf8 = yes" >> cluster1/intermediate.conf
echo "default_md = sha256" >> cluster1/intermediate.conf
echo "default_bits = 4096" >> cluster1/intermediate.conf
echo "req_extensions = req_ext" >> cluster1/intermediate.conf
echo "x509_extensions = req_ext" >> cluster1/intermediate.conf
echo "distinguished_name = req_dn" >> cluster1/intermediate.conf
echo "[ req_ext ]" >> cluster1/intermediate.conf
echo "subjectKeyIdentifier = hash" >> cluster1/intermediate.conf
echo "basicConstraints = critical, CA:true, pathlen:0" >> cluster1/intermediate.conf
echo "keyUsage = critical, digitalSignature, nonRepudiation, keyEncipherment, keyCertSign" >> cluster1/intermediate.conf
echo "subjectAltName=@san" >> cluster1/intermediate.conf
echo "[ san ]" >> cluster1/intermediate.conf
echo "DNS.1 = istiod.istio-system.svc" >> cluster1/intermediate.conf
echo "[ req_dn ]" >> cluster1/intermediate.conf
echo "O = Istio" >> cluster1/intermediate.conf
echo "CN = Intermediate CA" >> cluster1/intermediate.conf
echo "L = cluster1" >> cluster1/intermediate.conf
echo "generating cluster1/cluster-ca.csr"
openssl req -sha256 -new -config cluster1//intermediate.conf -key cluster1/ca-key.pem -out cluster1/cluster-ca.csr
echo "generating cluster1/ca-cert.pem"
openssl x509 -req -sha256 -days 3650 \
		-CA root-cert.pem -CAkey root-key.pem -CAcreateserial\
		-extensions req_ext -extfile cluster1//intermediate.conf \
		-in cluster1/cluster-ca.csr -out cluster1/ca-cert.pem
echo "generating cluster1/cert-chain.pem"
cat cluster1/ca-cert.pem root-cert.pem > cluster1/cert-chain.pem
echo "Intermediate inputs stored in cluster1/"
cp root-cert.pem cluster1/
echo "done"
rm cluster1/cluster-ca.csr cluster1/intermediate.conf


$ make -f ../tools/certs/Makefile.selfsigned.mk cluster1-cacerts
generating cluster1/ca-key.pem
generating cluster1/cluster-ca.csr
generating cluster1/ca-cert.pem
Certificate request self-signature ok
subject=O=Istio, CN=Intermediate CA, L=cluster1
generating cluster1/cert-chain.pem
Intermediate inputs stored in cluster1/
done
rm cluster1/cluster-ca.csr cluster1/intermediate.conf


$ tree -a .
.
├── cluster1
│   ├── ca-cert.pem  # 生成的中间证书
│   ├── ca-key.pem  # 生成的中间密钥
│   ├── cert-chain.pem  # 生成的 istiod 使用的证书链
│   └── root-cert.pem  # 根证书
├── root-ca.conf
├── root-cert.csr
├── root-cert.pem
├── root-cert.srl
└── root-key.pem

2 directories, 9 files
$


$ make -f ../tools/certs/Makefile.selfsigned.mk cluster2-cacerts
generating cluster2/ca-key.pem
generating cluster2/cluster-ca.csr
generating cluster2/ca-cert.pem
Certificate request self-signature ok
subject=O=Istio, CN=Intermediate CA, L=cluster2
generating cluster2/cert-chain.pem
Intermediate inputs stored in cluster2/
done
rm cluster2/cluster-ca.csr cluster2/intermediate.conf


$ tree -a .
.
├── cluster1
│   ├── ca-cert.pem
│   ├── ca-key.pem
│   ├── cert-chain.pem
│   └── root-cert.pem
├── cluster2
│   ├── ca-cert.pem
│   ├── ca-key.pem
│   ├── cert-chain.pem
│   └── root-cert.pem
├── root-ca.conf
├── root-cert.csr
├── root-cert.pem
├── root-cert.srl
└── root-key.pem

3 directories, 13 files
$


# create a secret cacerts
$ kubectl create namespace istio-system

$ kubectl create secret generic cacerts -n istio-system \
      --from-file=cluster1/ca-cert.pem \
      --from-file=cluster1/ca-key.pem \
      --from-file=cluster1/root-cert.pem \
      --from-file=cluster1/cert-chain.pem

$ kubectl -n istio-system get secret cacerts -o yaml
apiVersion: v1
data:
  ca-cert.pem: LS0tL0FURS0tLS0tCg==
  ca-key.pem: LS0tLS1CRUdJTiBLS0tLQo=
  cert-chain.pem: LS0tLS1CRUdJTiBEUtLS0tLQo=
  root-cert.pem: LS0tLS1CRUtLS0tCg==
kind: Secret
metadata:
  creationTimestamp: "2024-07-12T12:17:16Z"
  name: cacerts
  namespace: istio-system
  resourceVersion: "420"
  uid: 510b4f91-f131-4860-92eb-36ee065faf36
type: Opaque
$


# 使用 demo 配置文件部署 Istio
# Istio 的 CA 将从秘密挂载文件中读取证书和密钥
istioctl install --set profile=demo


# 部署 httpbin 和 sleep 示例服务
kubectl create ns foo
kubectl apply -f <(istioctl kube-inject -f samples/httpbin/httpbin.yaml) -n foo
kubectl apply -f <(istioctl kube-inject -f samples/sleep/sleep.yaml) -n foo


# 为 foo 命名空间中的工作负载部署策略，以仅接受相互 TLS 流量
kubectl apply -n foo -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
spec:
  mtls:
    mode: STRICT
EOF


# 检索 httpbin 的证书链
sleep 20;

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c istio-proxy -n foo -- openssl s_client -showcerts -connect httpbin.foo:8000 > httpbin-proxy-cert.txt


# 解析证书链上的证书
sed -n '/-----BEGIN CERTIFICATE-----/{:start /-----END CERTIFICATE-----/!{N;b start};/.*/p}' httpbin-proxy-cert.txt > certs.pem

awk 'BEGIN {counter=0;} /BEGIN CERT/{counter++} { print > "proxy-cert-" counter ".pem"}' < certs.pem


# 验证根证书与管理员指定的根证书是否相同
openssl x509 -in certs/cluster1/root-cert.pem -text -noout > /tmp/root-cert.crt.txt

openssl x509 -in ./proxy-cert-3.pem -text -noout > /tmp/pod-root-cert.crt.txt

diff -s /tmp/root-cert.crt.txt /tmp/pod-root-cert.crt.txt


# 验证CA证书是否与管理员指定的一致
openssl x509 -in certs/cluster1/ca-cert.pem -text -noout > /tmp/ca-cert.crt.txt

openssl x509 -in ./proxy-cert-2.pem -text -noout > /tmp/pod-cert-chain-ca.crt.txt

diff -s /tmp/ca-cert.crt.txt /tmp/pod-cert-chain-ca.crt.txt


# 验证从根证书到工作负载证书的证书链
openssl verify -CAfile <(cat certs/cluster1/ca-cert.pem certs/cluster1/root-cert.pem) ./proxy-cert-1.pem
./proxy-cert-1.pem: OK

```

结论:

PeerAuthentication defines how traffic will be tunneled (or not) to the sidecar.
PeerAuthentication 定义流量如何通过隧道传输（或不传输）到 sidecar。
