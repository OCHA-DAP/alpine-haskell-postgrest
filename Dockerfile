FROM unocha/alpine-base:latest

MAINTAINER Michael Rans <rans@email.com>

RUN echo "https://s3-us-west-2.amazonaws.com/alpine-ghc/7.10" >> /etc/apk/repositories && \
    curl -so /etc/apk/keys/mitch.tishmack@gmail.com-55881c97.rsa.pub \
        https://raw.githubusercontent.com/mitchty/alpine-ghc/master/mitch.tishmack%40gmail.com-55881c97.rsa.pub && \
    apk update && \
    apk add build-base git xz postgresql-dev ghc stack && \
    git clone https://github.com/begriffs/postgrest.git --single-branch && \
    cd postgrest && \
    git checkout 726b2b9d18a3b8217d83c514122560fd5f71af95 && \
    stack build --copy-bins --local-bin-path /usr/local/bin && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

CMD [ "postgrest", "$DB_URL", "-a", "freshness" ]
