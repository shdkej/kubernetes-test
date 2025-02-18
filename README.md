# Kubernetes test
#### local test
- `vagrant up`

#### cloud test (aws free tier or else)
- `terraform apply`

## 1. Stress Test
- convert docker-compose to yaml using kompose
- run
- input stress `while true; do curl localhost; done`

#### scaling
kubectl scale deployment/test --replicas=10
kubectl autoscale deployment/test --min=10 --max=15 --cpu-percent=80
hpa

## 2. Rolling Update Test
```
kind: Deployment
...
spec:
  strategy:
  type: RollingUpdate   # or Recreate
  rollingUpdate:
    maxSurge: 1         # to
    maxUnavailable: 0   # limit count of unavailable pod
  affinity:
    podAffinity: ...
...
```
surge
- 의도한 파드의 수를 넘어서는 양을 제한한다.
- 넘치는 양을 제한하는 것
- 이 값이 0이 아니라면 파드를 기존의 개수보다 많이 생성하여 업데이트를 실행한다

unavailable
- 사용 불가한 파드 개수의 상한을 정해서 설정된 값(30%)의 나머지(70%)는 돌아가는
  상태로 유지시키도록 한다

unavailable이 0인데 surge도 0이라면 10개의 파드가 있을 때 1개도 정지시킬 수
없지만 10개를 넘어서 생성할 수도 없으므로 동작하지 않는다

## 3. Rollback Test
`set`
- `kubectl set image deployment/test nginx=nginx:new-tag` 처럼 사용 가능
- env, image, resources, selector, serviceaccount, subject 설정 가능
- `--record`를 안하면 <none>으로 기록되므로 가급적 record를 해줘야겠다
    - change-cause 어노테이션을 임의로 수정할 수 있긴 있다
- [ ] set을 해줬는데 원래 디플로이먼트는 그대로 있고 새로 생겼다

`--record`
- 어떤 것을 레코드해놓아야 할까
  - 이미지 변경
  - apply
  - rollout

`kubectl rollout <command> <deployment>/<name>`
- status
- history
- undo (--to-revision=2)

## 4. TLS
- openssl
    - `openssl req -x509 -newkey rsa:4096 -keyout key.key -out cert.crt`
- secret
    - `kubectl create secret tls test-tls --key key.key --cert cert.crt`
- edit ingress yml
    ```
    spec:
      tls:
      - secretName: test-tls
        hosts:
        - host.com
    ```

## 5. Monitoring

## More info
https://shdkej.com/container
