FROM elixir:1.17.2-slim AS builder

RUN apt-get update -y && \
    apt-get install -y build-essential git curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force
ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod && mix deps.compile

COPY assets ./assets
RUN cd assets && \
    npm install && \
    npm install --save-dev esbuild tailwindcss @tailwindcss/forms && \
    npm install --save phoenix phoenix_html phoenix_live_view && \
    npm run deploy && \
    npm cache clean --force && \
    rm -rf /tmp/*

COPY lib lib
COPY priv priv
RUN mix compile && mix phx.digest && mix release

FROM debian:bullseye-slim
RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

WORKDIR /app
ENV LANG=en_US.UTF-8 MIX_ENV=prod PORT=4000
COPY --from=builder /app/_build/prod/rel/franmalth_portfolio ./
CMD ["bin/franmalth_portfolio", "start"]
