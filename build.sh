#!/bin/bash -ex

# Create user for php-fpm
adduser -u 82 -D -S -s /sbin/nologin -h /var/www -G www-data www-data
chown -Rf www-data:www-data /var/log/php7

# Set up sudo for passwordless access to edge and wheel users
chmod g=u /etc/passwd
echo 'Set disable_coredump false' > /etc/sudo.conf
echo "edge ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/edge
chmod 0440 /etc/sudoers.d/edge
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# Create default user
addgroup -g 1000 -S edge
adduser -u 1000 -D -S -s /bin/bash -g edge -G edge edge
addgroup edge wheel
addgroup nginx edge
addgroup www-data edge
chown -Rf edge:edge /var/www

# Replace sendmail with msmtp
ln -sf /usr/bin/msmtp /usr/sbin/sendmail

# Use host as SERVER_NAME
sed -i "s/server_name/host/" /etc/nginx/fastcgi_params
sed -i "s/server_name/host/" /etc/nginx/fastcgi.conf

# Set HTTPS according to forwarded protocol
sed -i "s/https/fe_https/" /etc/nginx/fastcgi_params
sed -i "s/https/fe_https/" /etc/nginx/fastcgi.conf

# Upgrade pip and install shinto-cli
pip3 install --no-cache-dir --upgrade pip
pip3 install j2cli
pip3 install j2cli[yaml]

# Cleanup
rm -rf /tmp/*
