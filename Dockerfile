FROM jeanblanchard/alpine-glibc

RUN addgroup -S qtum && adduser -S -g qtum qtum

RUN set -ex \
	&& apk add --no-cache wget su-exec \
	&& rm -rf /var/lib/apt/lists/*

ENV QTUM_VERSION 1.0.2
ENV QTUM_URL https://github.com/qtumproject/qtum/releases/download/mainnet-ignition-v1.0.2/qtum-0.14.3-x86_64-linux-gnu.tar.gz

# install qtum binaries
RUN set -ex \
	&& cd /tmp \
	&& wget --no-check-certificate -qO qtum.tar.gz "$QTUM_URL" \
	&& tar -xzvf qtum.tar.gz -C /usr/local --strip-components=1 --exclude=qtum-qt --exclude=test_qtum \
	&& rm -rf /tmp/*

# create data directory
ENV QTUM_DATA /data
RUN mkdir "$QTUM_DATA" \
	&& chown -R qtum:qtum "$QTUM_DATA" \
	&& ln -sfn "$QTUM_DATA" /home/qtum/.qtum \
	&& chown -h qtum:qtum /home/qtum/.qtum
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3888 3889 13888 13889 23888
