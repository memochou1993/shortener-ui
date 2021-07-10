# build stage
FROM node:12 as builder

WORKDIR /app

COPY . .

RUN yarn global add @quasar/cli
RUN yarn install
RUN quasar build -m ssr

# final stage
FROM node:alpine

WORKDIR /app

COPY --from=builder /app/dist/ssr .

RUN yarn install

CMD [ "yarn", "start" ]
