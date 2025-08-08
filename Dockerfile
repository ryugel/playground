FROM hexpm/elixir:1.17.2-erlang-27.0.1-debian-bullseye-20240612 AS build
RUN apt-get update -y && apt-get install -y build-essential git curl nodejs npm && apt-get clean && rm -f /var/lib/apt/lists/*_*
WORKDIR /app
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN MIX_ENV=prod mix deps.compile
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest
COPY lib lib
COPY priv priv
RUN MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix release

FROM debian:bullseye-slim AS app
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV MIX_ENV=prod
ENV SHELL=/bin/bash
ENV PORT=8080
EXPOSE 8080
WORKDIR /app
COPY --from=build /app/_build/prod/rel/pulseboard ./
CMD ["bin/pulseboard", "start"]
