FROM alpine:3.5

MAINTAINER Derek Vance


RUN apk --no-cache -q --no-progress add \
    git \
    python \
    python-dev \
    py-pip \
    libffi-dev \
    libxml2-dev \
    xmlsec-dev \
    libxslt-dev \
    zlib-dev \
    openldap-dev \
    build-base \
    mariadb-dev \
    && pip install -U pip \
    && rm -rf /var/cache/apk/*

# Install Virtualenv
RUN pip install virtualenv

# Create a new directory where the virtual environment will be created and add the requirements file.
RUN git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git /app

WORKDIR /app

RUN virtualenv flask \
    && source ./flask/bin/activate \
    && pip install MySQL-python \
	&& pip install -r requirements.txt \
    && cp config_template.py config.py


COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /




EXPOSE 9393

ENTRYPOINT ["docker-entrypoint.sh"]
