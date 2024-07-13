```bash

# 部署 cert-manager

################################################################################

# ClusterIssuer/selfsigned-bar-issuer 签名命名空间 cert-manager 中的证书 bar-ca，生成的证书存放在 secret bar-ca-selfsigned 里面
# 使用 secret bar-ca-selfsigned 签名 ClusterIssuer/bar

# ClusterIssuer/selfsigned-foo-issuer 签名命名空间 cert-manager 中的证书 foo-ca，生成的证书存放在 secret foo-ca-selfsigned 里面
# 使用 secret bar-ca-selfsigned 签名 ClusterIssuer/foo

# ClusterIssuer/selfsigned-istio-issuer 签名命名空间 cert-manager 中的证书 istio-ca，生成的证书存放在 secret istio-ca-selfsigned 里面
# 使用 secret istio-ca-selfsigned 签名 ClusterIssuer/istio-system

cat <<EOF > ./selfsigned-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-bar-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: bar-ca
  namespace: cert-manager
spec:
  isCA: true
  commonName: bar
  secretName: bar-ca-selfsigned
  issuerRef:
    name: selfsigned-bar-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: bar
spec:
  ca:
    secretName: bar-ca-selfsigned
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-foo-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: foo-ca
  namespace: cert-manager
spec:
  isCA: true
  commonName: foo
  secretName: foo-ca-selfsigned
  issuerRef:
    name: selfsigned-foo-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: foo
spec:
  ca:
    secretName: foo-ca-selfsigned
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-istio-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: istio-ca
  namespace: cert-manager
spec:
  isCA: true
  commonName: istio-system
  secretName: istio-ca-selfsigned
  issuerRef:
    name: selfsigned-istio-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: istio-system
spec:
  ca:
    secretName: istio-ca-selfsigned
EOF
kubectl apply -f ./selfsigned-issuer.yaml

################################################################################

export ISTIOCA=$(kubectl get clusterissuers istio-system -o jsonpath='{.spec.ca.secretName}' | xargs kubectl get secret -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d | sed 's/^/        /')

export FOOCA=$(kubectl get clusterissuers foo -o jsonpath='{.spec.ca.secretName}' | xargs kubectl get secret -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d | sed 's/^/        /')

export BARCA=$(kubectl get clusterissuers bar -o jsonpath='{.spec.ca.secretName}' | xargs kubectl get secret -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d | sed 's/^/        /')

$ kubectl get clusterissuers istio-system -o jsonpath='{.spec.ca.secretName}'
istio-ca-selfsigned
$

$ kubectl get clusterissuers foo -o jsonpath='{.spec.ca.secretName}' | xargs kubectl get secret -n cert-manager -o jsonpath='{.data.ca\.crt}'
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM2RENDQWRDZ0F3SUJBZ0lRUjVQUXh0NW81T3hHR3FOZDRaYUwvakFOQmdrcWhraUc5dzBCQVFzRkFEQU8KTVF3d0NnWURWUVFERXdObWIyOHdIaGNOTWpRd056RXlNVE13TkRVM1doY05NalF4TURFd01UTXdORFUzV2pBTwpNUXd3Q2dZRFZRUURFd05tYjI4d2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUUN6CnBremxsUFpsbnRkazBSaUVwRVJNNzNkNm5ZNEJocTd2Wk1KaHVXMEFpT3ZrWFUxYTNqbm42ZFAzTHUwb292WXcKazdlMEpiRWlCdVlnbUZhU0VyQXZDL25sbDN4VHpUMDEvMWRscDhLRkZOQy9YYjhhelRoNWt4akI1SEpWZUpzegphVU9ZcG5YaTl0SEc0UkdzN2lRSkU0Tlh0TjdIc3JlZHNZRUw2QnZ4UGZzeWhrOXB2VFFHZzZTQmJabFloNW5yCldCZVdYSTh1Y3VOcExNSnJwZ1BZSlVSejhCQjkrMGZVeDJBT3JQVys2NG5IWG5MTTViS0lGd3pwM1VEN09OMGoKaFlxQmVhcHdDM0RWaWthMVh0MU50Y2RkTHdOODlPQURXQWJlMWc2TXRSQThzMEcyeEgwOXcxanZ6VEx2M3NzRQoyT2JSNU9tU3FkU3ozcTJXUi9hdEFnTUJBQUdqUWpCQU1BNEdBMVVkRHdFQi93UUVBd0lDcERBUEJnTlZIUk1CCkFmOEVCVEFEQVFIL01CMEdBMVVkRGdRV0JCUU9pNUZ4VjFRM3liRTRvS1Y0K2wwTlVZYVZqakFOQmdrcWhraUcKOXcwQkFRc0ZBQU9DQVFFQUFFQTByYU90WGdxZlcxRFhwdUxCM2lwT2hqTGlSSmxqT2lURXE5QnczQWtySHpDQgo0ODgvdVlDUDIyY0ovNm5pMGVjZ3RHT0drYmcrOGpTL0FTQzFQQnR2bUhqR0QwTDIrMFVTZEdOUkgyL1ZJTUd1CllBcHVSWTQwMGNMQUZQSmpsM2FwK0pNV0ZXaHl4Z1pjVUtodUMwWFA5ajVkREtMeHJIL3FxT2NXWEZDY0VHWWoKY2NJaGdVSG1ISFhxRHl0eGx2a3lKdGNFM3p0VTdPT1daZHFOcE9PVG4zc0dPTHNlb0ZaOHNCMXVqOEY5bkJpQwpnSzIvK1NHZjU2MFdibENBemRXSlJKbFJOM1hvU24xbWNNY3JKT0hnSEI3dkdGUWlXaklQNDBtelZacTNGNnJ1CnBFVWFpNDkrY0djUE5WcEkrTjZhaHdQNUM4OHQrZUhsMkF3K1FBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
$

$ kubectl get clusterissuers istio-system -o jsonpath='{.spec.ca.secretName}' | xargs kubectl get secret -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d | sed 's/^/        /'
        -----BEGIN CERTIFICATE-----
        MIIC+zCCAeOgAwIBAgIRAOsUa2y3oAoHk5lPfH5fRJMwDQYJKoZIhvcNAQELBQAw
        FzEVMBMGA1UEAxMMaXN0aW8tc3lzdGVtMB4XDTI0MDcxMjEzMDQ1N1oXDTI0MTAx
        MDEzMDQ1N1owFzEVMBMGA1UEAxMMaXN0aW8tc3lzdGVtMIIBIjANBgkqhkiG9w0B
        AQEFAAOCAQ8AMIIBCgKCAQEA5uDK2yIV2SR/C9vlXt/jx2pzLn+K5CTcGuXEzrZV
        2vFP/roNtLE1UImaXukKJ1QGCKHwx+Uisx8tmeDyUpCxPNlW8d0JKTUutHWz8u6g
        PfOEoErbO1w/VTueMU1qdsefFqs7wY2oynFmOnVd5uUoLMgC9ShobfTi8+NRnphN
        dCVbhNnggYM2wcR9jIvnKIJDzV9ex6Q88yO5RrpLwpG1j7flpydATkiiv/UN+vCo
        FYsGxh7TiNd6F05+lvNTRbHn7bsmky4puNKT8RZSQIpP6MLuJe9nnfm+ZAUBe1OO
        C2hvkpg44GCAN3J4CyytGGvnjR5Pt6F/gNjyhOZuMb95iwIDAQABo0IwQDAOBgNV
        HQ8BAf8EBAMCAqQwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUqD6ISle3n5R6
        US4+RvQHjkzxGxUwDQYJKoZIhvcNAQELBQADggEBALXrcpZndQ/lxyesZK6F2WD0
        aTz7W7aX2P6NDIB8A9bpfECy+PdPOGlJKxN/cdA8Q1lGqBvGLeCZPqTN2Zz4g4Mp
        JbsYuHw5QQdkL0/oqELhKhl8ExGp/G01MgNLMOL3YBkSujbS9DQQCinc3LetgD9Q
        xjkzIYlNka98I5XoAHUTrQpGTwNbkg06BcLSgG7c11tz0Ps1EJdEE+QLO53/nZ5Q
        jnIGsdO3Dq6Ihm+TbBy7aiwet6rgiZ/wympXyUl4q8hO3eOB33DI2s34KkTjE02v
        VZSrJLjCnUKZ3cHenMIppVgQ0di5nmgC1+WNPD8itRtpORizcTOwvg83pFE0mLg=
        -----END CERTIFICATE-----
$

################################################################################

cat <<EOF > ./istio.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    pilot:
      env:
        EXTERNAL_CA: ISTIOD_RA_KUBERNETES_API
  meshConfig:
    defaultConfig:
      proxyMetadata:
        ISTIO_META_CERT_SIGNER: istio-system
    caCertificates:
    - pem: |
$ISTIOCA
      certSigners:
      - clusterissuers.cert-manager.io/istio-system
    - pem: |
$FOOCA
      certSigners:
      - clusterissuers.cert-manager.io/foo
    - pem: |
$BARCA
      certSigners:
      - clusterissuers.cert-manager.io/bar
  components:
    pilot:
      k8s:
        env:
        - name: CERT_SIGNER_DOMAIN
          value: clusterissuers.cert-manager.io
        - name: PILOT_CERT_PROVIDER
          value: k8s.io/clusterissuers.cert-manager.io/istio-system
        overlays:
          - kind: ClusterRole
            name: istiod-clusterrole-istio-system
            patches:
              - path: rules[-1]
                value: |
                  apiGroups:
                  - certificates.k8s.io
                  resourceNames:
                  - clusterissuers.cert-manager.io/foo
                  - clusterissuers.cert-manager.io/bar
                  - clusterissuers.cert-manager.io/istio-system
                  resources:
                  - signers
                  verbs:
                  - approve
EOF
istioctl install --skip-confirmation -f ./istio.yaml

$ cat ./istio.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    pilot:
      env:
        EXTERNAL_CA: ISTIOD_RA_KUBERNETES_API
  meshConfig:
    defaultConfig:
      proxyMetadata:
        ISTIO_META_CERT_SIGNER: istio-system
    caCertificates:
    - pem: |
        -----BEGIN CERTIFICATE-----
        MIIC+zCCAeOgAwIBAgIRAOsUa2y3oAoHk5lPfH5fRJMwDQYJKoZIhvcNAQELBQAw
        FzEVMBMGA1UEAxMMaXN0aW8tc3lzdGVtMB4XDTI0MDcxMjEzMDQ1N1oXDTI0MTAx
        MDEzMDQ1N1owFzEVMBMGA1UEAxMMaXN0aW8tc3lzdGVtMIIBIjANBgkqhkiG9w0B
        AQEFAAOCAQ8AMIIBCgKCAQEA5uDK2yIV2SR/C9vlXt/jx2pzLn+K5CTcGuXEzrZV
        2vFP/roNtLE1UImaXukKJ1QGCKHwx+Uisx8tmeDyUpCxPNlW8d0JKTUutHWz8u6g
        PfOEoErbO1w/VTueMU1qdsefFqs7wY2oynFmOnVd5uUoLMgC9ShobfTi8+NRnphN
        dCVbhNnggYM2wcR9jIvnKIJDzV9ex6Q88yO5RrpLwpG1j7flpydATkiiv/UN+vCo
        FYsGxh7TiNd6F05+lvNTRbHn7bsmky4puNKT8RZSQIpP6MLuJe9nnfm+ZAUBe1OO
        C2hvkpg44GCAN3J4CyytGGvnjR5Pt6F/gNjyhOZuMb95iwIDAQABo0IwQDAOBgNV
        HQ8BAf8EBAMCAqQwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUqD6ISle3n5R6
        US4+RvQHjkzxGxUwDQYJKoZIhvcNAQELBQADggEBALXrcpZndQ/lxyesZK6F2WD0
        aTz7W7aX2P6NDIB8A9bpfECy+PdPOGlJKxN/cdA8Q1lGqBvGLeCZPqTN2Zz4g4Mp
        JbsYuHw5QQdkL0/oqELhKhl8ExGp/G01MgNLMOL3YBkSujbS9DQQCinc3LetgD9Q
        xjkzIYlNka98I5XoAHUTrQpGTwNbkg06BcLSgG7c11tz0Ps1EJdEE+QLO53/nZ5Q
        jnIGsdO3Dq6Ihm+TbBy7aiwet6rgiZ/wympXyUl4q8hO3eOB33DI2s34KkTjE02v
        VZSrJLjCnUKZ3cHenMIppVgQ0di5nmgC1+WNPD8itRtpORizcTOwvg83pFE0mLg=
        -----END CERTIFICATE-----
      certSigners:
      - clusterissuers.cert-manager.io/istio-system
    - pem: |
        -----BEGIN CERTIFICATE-----
        MIIC6DCCAdCgAwIBAgIQR5PQxt5o5OxGGqNd4ZaL/jANBgkqhkiG9w0BAQsFADAO
        MQwwCgYDVQQDEwNmb28wHhcNMjQwNzEyMTMwNDU3WhcNMjQxMDEwMTMwNDU3WjAO
        MQwwCgYDVQQDEwNmb28wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCz
        pkzllPZlntdk0RiEpERM73d6nY4Bhq7vZMJhuW0AiOvkXU1a3jnn6dP3Lu0oovYw
        k7e0JbEiBuYgmFaSErAvC/nll3xTzT01/1dlp8KFFNC/Xb8azTh5kxjB5HJVeJsz
        aUOYpnXi9tHG4RGs7iQJE4NXtN7HsredsYEL6BvxPfsyhk9pvTQGg6SBbZlYh5nr
        WBeWXI8ucuNpLMJrpgPYJURz8BB9+0fUx2AOrPW+64nHXnLM5bKIFwzp3UD7ON0j
        hYqBeapwC3DVika1Xt1NtcddLwN89OADWAbe1g6MtRA8s0G2xH09w1jvzTLv3ssE
        2ObR5OmSqdSz3q2WR/atAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMB
        Af8EBTADAQH/MB0GA1UdDgQWBBQOi5FxV1Q3ybE4oKV4+l0NUYaVjjANBgkqhkiG
        9w0BAQsFAAOCAQEAAEA0raOtXgqfW1DXpuLB3ipOhjLiRJljOiTEq9Bw3AkrHzCB
        488/uYCP22cJ/6ni0ecgtGOGkbg+8jS/ASC1PBtvmHjGD0L2+0USdGNRH2/VIMGu
        YApuRY400cLAFPJjl3ap+JMWFWhyxgZcUKhuC0XP9j5dDKLxrH/qqOcWXFCcEGYj
        ccIhgUHmHHXqDytxlvkyJtcE3ztU7OOWZdqNpOOTn3sGOLseoFZ8sB1uj8F9nBiC
        gK2/+SGf560WblCAzdWJRJlRN3XoSn1mcMcrJOHgHB7vGFQiWjIP40mzVZq3F6ru
        pEUai49+cGcPNVpI+N6ahwP5C88t+eHl2Aw+QA==
        -----END CERTIFICATE-----
      certSigners:
      - clusterissuers.cert-manager.io/foo
    - pem: |
        -----BEGIN CERTIFICATE-----
        MIIC6DCCAdCgAwIBAgIQaIbxrOIJq5bUYdOjlzuj6TANBgkqhkiG9w0BAQsFADAO
        MQwwCgYDVQQDEwNiYXIwHhcNMjQwNzEyMTMwNDU2WhcNMjQxMDEwMTMwNDU2WjAO
        MQwwCgYDVQQDEwNiYXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCv
        hG3+j7RX93ygEf9JPegTRrJMZdKG0gdDFuSWS/b4d+fNenkvBq/LoKYAMDR2M0Kg
        w/ktkciZCiofwyUzj9SGdjvFU6SSrZe6a4WqfWttLzOw8YOKWv2CBN4n6whu1e5c
        2EdspK6wm1hLK0rJrs5s3HyuqcBkNzShzPFx8Gml5m69D72ooSqBFwVPbLTbAxO7
        +x7ReMqITazZ+DAibDkYzyTeplCqn6FoIZVHnA4V48XMkkt9zIazO+ZfQG8wVl5W
        ODGLPZ+bttujuYKtJJXqJzYVDClyA0ZlaUjHmy8mtxmJghSYB3hbrVVuEE4uvhNt
        lqLMvd1KNsoEUSAPPxdnAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMB
        Af8EBTADAQH/MB0GA1UdDgQWBBShFtb0jMnf9oZdPyz5xIWRrjgV5jANBgkqhkiG
        9w0BAQsFAAOCAQEAlLIdV8nO8KuGBYg1mE9yM8+9st0hzE4MrBclq6xFkzcTquIS
        0kfoWpa/QQz9OqAeNjXcBoSb7/e8Krk7ftXvbTHH/xZhGCe+YswsLdR3kh8h1Pad
        Fs6JTrobZM7GBAGzTM+B/5OVtQPPQE6ie2teiRlcUuMXoxODYxoGhFl/kYwurVLU
        GgP36ItF2CHO/vO1MCeXjbaOiM8i4hlevzWAigZWh9HPgyxuB9AtTXWGC4xHQRfH
        JuwobXxhrbSodxPo/tDyiWCFJC8t4BPTJC/eujHe6zQnfY1n+WmO9LnQO3CpBsD2
        6J8j5rsFPuGssdsDT0Uy+lrZknNmDDM4AHKQzA==
        -----END CERTIFICATE-----
      certSigners:
      - clusterissuers.cert-manager.io/bar
  components:
    pilot:
      k8s:
        env:
        - name: CERT_SIGNER_DOMAIN
          value: clusterissuers.cert-manager.io
        - name: PILOT_CERT_PROVIDER
          value: k8s.io/clusterissuers.cert-manager.io/istio-system
        overlays:
          - kind: ClusterRole
            name: istiod-clusterrole-istio-system
            patches:
              - path: rules[-1]
                value: |
                  apiGroups:
                  - certificates.k8s.io
                  resourceNames:
                  - clusterissuers.cert-manager.io/foo
                  - clusterissuers.cert-manager.io/bar
                  - clusterissuers.cert-manager.io/istio-system
                  resources:
                  - signers
                  verbs:
                  - approve
$

################################################################################

# 在 bar 命名空间中部署 proxyconfig-bar.yaml ，为 bar 命名空间中的工作负载定义证书签名者

cat <<EOF > ./proxyconfig-bar.yaml
apiVersion: networking.istio.io/v1beta1
kind: ProxyConfig
metadata:
  name: barpc
  namespace: bar
spec:
  environmentVariables:
    ISTIO_META_CERT_SIGNER: bar
EOF
kubectl apply  -f ./proxyconfig-bar.yaml

# 在 foo 命名空间中部署 proxyconfig-foo.yaml ，为 foo 命名空间中的工作负载定义证书签名者。

cat <<EOF > ./proxyconfig-foo.yaml
apiVersion: networking.istio.io/v1beta1
kind: ProxyConfig
metadata:
  name: foopc
  namespace: foo
spec:
  environmentVariables:
    ISTIO_META_CERT_SIGNER: foo
EOF
kubectl apply  -f ./proxyconfig-foo.yaml


################################################################################

kubectl label ns foo istio-injection=enabled

kubectl label ns bar istio-injection=enabled

kubectl apply -f samples/httpbin/httpbin.yaml -n foo

kubectl apply -f samples/sleep/sleep.yaml -n foo

kubectl apply -f samples/httpbin/httpbin.yaml -n bar



################################################################################

# 此任务展示如何使用与 Kubernetes CSR API 集成的自定义证书颁发机构来配置工作负载证书。
# 不同的工作负载可以从不同的证书签名者处获取其证书。每个证书签名者实际上都是不同的 CA。
# 预计证书由同一证书签名者颁发的工作负载可以相互进行 mTLS 对话，而由不同签名者签名的工作负载则不能。

$ export SLEEP_POD_FOO=$(kubectl get pod -n foo -l app=sleep -o jsonpath={.items..metadata.name})

$ kubectl exec "$SLEEP_POD_FOO" -n foo -c sleep -- curl http://httpbin.foo:8000/html
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
      <h1>Herman Melville - Moby-Dick</h1>

      <div>
        <p>
          Availing himself of the mild...
        </p>
      </div>
  </body>

$ kubectl exec "$SLEEP_POD_FOO" -n foo -c sleep -- curl http://httpbin.bar:8000/html
upstream connect error or disconnect/reset before headers. reset reason: connection failure, transport failure reason: TLS error: 268435581:SSL routines:OPENSSL_internal:CERTIFICATE_VERIFY_FAILED

```