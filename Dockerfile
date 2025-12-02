FROM dunglas/frankenphp:1-php8.3-bookworm

# ------------------------------------------------------------------
# system deps & PHP extensions
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev libjpeg-dev libfreetype6-dev \
    zlib1g-dev pkg-config \
    libonig-dev libxml2-dev libzip-dev libicu-dev \
    supervisor default-mysql-client git curl nano unzip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) \
        pdo_mysql mbstring exif pcntl bcmath gd intl zip opcache \
 && pecl install redis \
 && docker-php-ext-enable redis \
 && apt-get purge -y --auto-remove \
 && rm -rf /var/lib/apt/lists/* /tmp/pear ~/.pearrc

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
