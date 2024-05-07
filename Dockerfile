# build stage
FROM node:16 as builder

WORKDIR /app

COPY . .

RUN yarn global add @quasar/cli
RUN yarn install
RUN quasar build -m ssr

# final stage
FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app/dist/ssr .

RUN yarn install

CMD [ "yarn", "start" ]
