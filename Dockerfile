FROM hexpm/elixir:1.17.2-erlang-27.0.1-debian-bullseye-latest AS build

RUN apt-get update -y && apt-get install -y build-essential git curl nodejs npm

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod
RUN mix deps.compile

COPY assets assets
RUN cd assets && npm install && npm install esbuild tailwindcss && npm run deploy

COPY lib lib
COPY priv priv
RUN mix compile
RUN mix phx.digest
RUN mix release

FROM debian:bullseye-slim

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR /app
COPY --from=build /app/_build/prod/rel/pulseboard ./

ENV LANG=en_US.UTF-8
ENV SHELL=/bin/bash
ENV MIX_ENV=prod
CMD ["bin/pulseboard", "start"]
