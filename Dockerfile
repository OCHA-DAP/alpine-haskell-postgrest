FROM unocha/alpine-base:latest

MAINTAINER Michael Rans <rans@email.com>

RUN echo "https://s3-us-west-2.amazonaws.com/alpine-ghc/8.0" >> /etc/apk/repositories && \ 
    curl -so /root/runpostgrest.sh \
        https://raw.githubusercontent.com/OCHA-DAP/alpine-haskell-postgrest/master/runpostgrest.sh && \
    curl -so /etc/apk/keys/mitch.tishmack@gmail.com-55881c97.rsa.pub \
        https://raw.githubusercontent.com/mitchty/alpine-ghc/master/mitch.tishmack%40gmail.com-55881c97.rsa.pub && \
    apk add --no-cache --update build-base xz postgresql-dev zlib-dev ghc stack && \
    mkdir /root/postgrest && \
    cd /root/postgrest && \
    curl -L https://github.com/begriffs/postgrest/tarball/v0.5.0.0 \
        | tar xz -C . --strip-components=1 && \
    stack config set system-ghc --global true && \
    stack build --copy-bins --local-bin-path /usr/local/bin && \
    stack clean --full && \
    rm -rf /root/postgrest && \
    apk del build-base xz postgresql-dev zlib-dev ghc stack && \
    apk add --no-cache libpq libffi gmp && \
    rm -r /root/.stack && \
    rm -rf /var/lib/apk/*

CMD ["postgrest", "$DB_URL", "-a", "freshness"]
