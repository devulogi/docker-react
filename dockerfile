FROM node:16-alpine as builder

USER node

RUN mkdir -p /home/node/app
WORKDIR /home/node/app
COPY --chown=node:node ./package.json ./
RUN npm install --only=production --omit=dev
COPY --chown=node:node ./ ./
RUN npm run build

FROM nginx:1.23-alpine

COPY --from=builder /home/node/app/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
