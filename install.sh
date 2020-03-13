apt update && apt install -y git curl tzdata openssl openssh-server net-tools zsh

mkdir "home"

if command -v docker >/dev/null 2>&1; then 
  echo 'exists docker, break;'
else 
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh && rm -f get-docker.sh
fi

if command -v docker-compose >/dev/null 2>&1; then 
  echo 'exists docker-compose, break;'
else 
    curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

apt-get install -y nodejs npm \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y --no-install-recommends yarn \
    && apt-get clean

apt-get install -y default-jdk maven \
    && apt-get clean

apt-get install -y php php-bcmath php-bz2 php-calendar php-ctype php-curl php-dom php-enchant php-exif php-fileinfo php-ftp php-gd php-gettext php-gmp php-iconv php-intl php-json php-ldap php-mbstring php-mysqli php-mysqlnd php-opcache php-pdo php-phar php-posix php-pspell php-readline php-shmop php-simplexml php-snmp php-soap php-sockets php-sqlite3 php-sysvmsg php-sysvsem php-sysvshm php-wddx php-xml php-xsl \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php "composer-setup.php" \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \
    && apt-get clean

fallocate -l 1551m /swap
chmod 600 /swap
mkswap /swap
swapon /swap
sh -c 'echo "/swap none  swap    sw   0    0" >> /etc/fstab'

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd /usr/local && git clone https://github.com/akirarika/project-launcher.git && cd project-launcher && chmod +x ./pls && ./pls install
