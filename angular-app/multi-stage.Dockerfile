# Stage 1
FROM node:10-alpine as builder

WORKDIR /ng-app
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run ng build -- --prod --output-path=dist


# Stage 2
FROM nginx:1.14.1-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /ng-app/dist /usr/share/nginx/html
