# Build Stage
FROM node:20-alpine AS builder

WORKDIR /usr/app

COPY ./package.json .
RUN npm i

COPY . .

RUN npm run build

RUN npm prune --production

# Production Stage
FROM node:20-alpine

WORKDIR /usr/app

COPY --from=builder /usr/app/build ./build
COPY --from=builder /usr/app/node_modules ./node_modules
COPY --from=builder /usr/app/package.json ./package.json

EXPOSE 3000

ENV NODE_ENV=production

CMD ["node", "build"]
