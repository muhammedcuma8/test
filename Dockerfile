FROM node:20-alpine as build
WORKDIR /{DOCKER_WORKDIR}
COPY package.json .
RUN npm config set proxy http://proxy.koton.com.tr:8080
RUN npm config set registry http://registry.npmjs.org/
RUN npm install react-router-dom@6 --legacy-peer-deps
COPY . .
EXPOSE 80
EXPOSE 3000
RUN npm run build:prod

FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /{DOCKER_WORKDIR}/dist .
COPY nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]
