FROM alpine:latest

MAINTAINER Derek Vance

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV PDA_DB_HOST db
ENV PDA_DB_USER powerdns
ENV PDA_DB_PASSWORD powerdns
ENV PDA_DB_NAME powerdns

RUN apk --no-cache -q --no-progress add \
    git \
    python3 \
    python3-dev \
    py-pip \
    libffi-dev \
    libxml2-dev \
    xmlsec-dev \
    libxslt-dev \
    zlib-dev \
    openldap-dev \
    build-base \
    mariadb-dev \
    yarn

RUN pip --quiet install -U pip \
    && pip install virtualenv

RUN git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git /app
WORKDIR /app

RUN virtualenv -p python3 flask \
    && source ./flask/bin/activate \
    && pip install mysqlclient \
    && pip install -r requirements.txt

RUN cp configs/development.py config.py \
    && sed -i "s|LOG_LEVEL = 'DEBUG'|LOG_LEVEL = 'INFO'|g" /app/config.py; \
    sed -i "s|LOG_FILE = 'logfile.log'|LOG_FILE = ''|g" /app/config.py;

COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh
RUN mkdir logs \
    && rm -rf docker


EXPOSE 9191/tcp

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/app/flask/bin/gunicorn", "-t", "120", "--workers", "4", "--bind", "0.0.0.0:9191", "--log-level", "info", "app:app"]
