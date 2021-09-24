# realworld-deploy

- [前端專案](https://github.com/lujakob/nestjs-realworld-example-app)
- [後端專案](https://github.com/mutoe/vue3-realworld-example-app)

使用容器技術部署前、後端專案，計畫實作下面列舉項目
1. 容器化後端專案 [commit](https://github.com/newjett0617/nestjs-realworld-example-app/commit/6f4d0f224160695596d201bad2681a93e386d492)
1. 容器化前端專案 [commit](https://github.com/newjett0617/vue3-realworld-example-app/commit/52e3675d5a3bfc7e992a0204fec30774819b9c1e)
1. 使用 docker-compose 部署前、後端專案
1. 使用 kubernetes 部署前、後端專案

## 容器化後端專案
readme 中提到需要準備兩個檔案，一個是 JWT Token 的設定檔，另一個是資料庫的設定檔，這邊使用 TypeORM 的方式，資料庫的設定檔案如下

```json
{
  "type": "mysql",
  "host": "mysql",
  "port": 3306,
  "username": "realworld",
  "password": "realworld",
  "database": "realworld",
  "entities": [
    "src/**/**.entity{.ts,.js}"
  ],
  "synchronize": true
}
```

有了兩個檔案後，就可以撰寫 Dockerfile 及 .dockerignore

### 建置 image
```shell
docker build --tag docker.io/newjett0617/realworld:backend .
```

## 容器化前端專案
目錄中有一個 .env 檔案，定義後端 API Host，因此在 build 階段需要當作環境變數將後端的 API Host 填入

撰寫 Dockerfile 及 .dockerignore，使用 multi-stage build 方式建置。第一個階段產生靜態檔案；第二階段使用前一個階段的靜態檔案，加入到網頁伺服器的根目錄中

### 建置 image
這邊會建立兩個標籤，一個是關於使用 docker-compose 的部署標籤，另外一個是使用 kubernetes 的部署標籤，因為兩個部署方式的 API Host 不一樣
```shell
docker build \
  --build-arg API_HOST=http://localhost:3000 \
  --tag docker.io/newjett0617/realworld:frontend-compose \
  .
```
```shell
docker build \
  --build-arg API_HOST=http://localhost \
  --tag docker.io/newjett0617/realworld:frontend \
  .
```

## 使用 docker-compose 部署前、後端專案
撰寫前、後端 docker-compose.yml 檔案

### 執行結果如下
前端有成功發 API，後端有成功查詢資料庫
![image](https://user-images.githubusercontent.com/40535423/127782881-cb67f1aa-5ef3-4b13-821d-bc3f991fe0de.png)

## 使用 kubernetes 部署前、後端專案
### 建置 kubernetes 環境
使用 [kind](https://kind.sigs.k8s.io/) 工具來建立 kubernetes 運行環境，這個 [專案](https://github.com/newjett0617/kind) 用來建置 kubernetes，並安裝 nginx-ingress-control，詳情看專案 readme

### 規劃
目前的規劃是打算使用 localhost 當作 domain，並且使用不同的路徑轉導到不同的服務中；當路徑是 `/` 時，將流量轉導到前端服務，當路徑是 `/api` 時，將流量轉導到後端服務

### 執行結果如下
前端有成功發 API，後端有成功查詢資料庫
![image](https://user-images.githubusercontent.com/40535423/127783500-2b90ac14-de63-4d4d-aa56-b99b6ce19b51.png)
