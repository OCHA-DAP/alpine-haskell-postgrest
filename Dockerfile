FROM unocha/alpine-base:latest

MAINTAINER Michael Rans <rans@email.com>

RUN echo "https://s3-us-west-2.amazonaws.com/alpine-ghc/7.10" >> /etc/apk/repositories && \
    curl -so /root/runpostgrest.sh \
        https://raw.githubusercontent.com/OCHA-DAP/alpine-haskell-postgrest/master/runpostgrest.sh && \
    curl -so /etc/apk/keys/mitch.tishmack@gmail.com-55881c97.rsa.pub \
        https://raw.githubusercontent.com/mitchty/alpine-ghc/master/mitch.tishmack%40gmail.com-55881c97.rsa.pub && \
    apk add --no-cache --update build-base git xz postgresql-dev ghc stack && \
    git clone https://github.com/begriffs/postgrest.git --single-branch && \
    cd postgrest && \
    git checkout 726b2b9d18a3b8217d83c514122560fd5f71af95 && \
    stack build --copy-bins --local-bin-path /usr/local/bin && \
    stack clean --full && \
    cd .. && \
    rm -rf postgrest && \
    apk del build-base git xz postgresql-dev ghc stack && \
    apk add --no-cache libpq gmp && \
    rm -r /root/.stack && \
    rm -rf /var/lib/apk/*

CMD ["postgrest", "$DB_URL", "-a", "freshness"]
