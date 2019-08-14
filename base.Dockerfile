ARG version
ARG base
ARG variant=''

FROM php:${version}${variant}${base}

ADD configure.sh /usr/local/bin/configure
ADD setup.sh /usr/local/bin/setup
RUN chmod u+x /usr/local/bin/*

ENV PECL_PACKAGES \
    xdebug

ENV PHP_EXTENSIONS \
    zip \
    pdo \
    pdo_mysql \
    intl \
    gd \
    pcntl \
    bcmath \
    shmop \
    mbstring \
    exif \
    imap \
    soap

ENV TOOLS_PACKAGES \
    bash \
    make \
    wget \
    curl \
    git \
    openssh-client

# Shellcheck setup
ADD https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz /opt/shellcheck.tar.xz
RUN cd /opt \
	&& mkdir shellcheck \
	&& tar --xz --extract --file shellcheck.tar.xz --directory shellcheck \
	&& cp shellcheck/shellcheck-stable/shellcheck /usr/bin/ \
	&& shellcheck --version \
	&& rm -rf shellcheck shellcheck.tar.xz
