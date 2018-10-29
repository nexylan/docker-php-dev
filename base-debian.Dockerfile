# Needed libraries
RUN apt-get update && apt-get install --yes \
gnupg \
libssl-dev \
libicu-dev \
zlib1g-dev \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev \
libgif-dev \
libxpm-dev \
libvpx-dev \
libsqlite3-dev \
libmcrypt-dev \
libc-client-dev \
libkrb5-dev \
libxml2-dev \
libicu-dev \

&& rm --recursive --force /var/lib/apt/lists/*

# Special NodeJS apt setup (Use LTS version)
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
&& apt-get install nodejs --yes \
&& rm --recursive --force /var/lib/apt/lists/*

# Special Yarn apt setup
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update \
&& apt-get install yarn \
&& rm --recursive --force /var/lib/apt/lists/*

# Shellcheck setup
ADD https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz /opt/shellcheck.tar.xz
RUN cd /opt \
	&& mkdir shellcheck \
	&& tar --xz --extract --file shellcheck.tar.xz --directory shellcheck \
	&& cp shellcheck/shellcheck-stable/shellcheck /usr/bin/ \
	&& shellcheck --version \
	&& rm -rf shellcheck shellcheck.tar.xz

# Extra languages needed for tools
RUN apt-get update && apt-get install --yes \
ruby \
ruby-dev \
python-pip \
&& rm --recursive --force /var/lib/apt/lists/*

# Tools
RUN apt-get update && apt-get install --yes ${TOOLS_PACKAGES} && rm --recursive --force /var/lib/apt/lists/*

# PECL extensions
RUN pecl install ${PECL_PACKAGES}

RUN configure

# Extensions
# https://github.com/docker-library/docs/blob/master/php/content.md#how-to-install-more-php-extensions
RUN docker-php-ext-install -j`nproc` ${PHP_EXTENSIONS} ${PHP_ADDITIONAL_EXTENSIONS}
