#!/bin/bash

# Переходим в директорию, куда скачиваются исходники
cd padavan-ng/trunk

# Удаляем старый бинарник, если он там есть, и качаем zapret2 (nfqws)
# Для Mi Router 3 (MT7620) строго mips32r1-softfloat
mkdir -p user/nfqws
curl -L -o user/nfqws/nfqws https://github.com

# Даем права на выполнение
chmod +x user/nfqws/nfqws

# Отключаем тяжелые пакеты прямо здесь (на случай если забыли в build.config),
# чтобы прошивка точно влезла в 14МБ
sed -i 's/CONFIG_FIRMWARE_INCLUDE_ARIA=y/CONFIG_FIRMWARE_INCLUDE_ARIA=n/' .config
sed -i 's/CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=n/' .config
sed -i 's/CONFIG_FIRMWARE_INCLUDE_TOR=y/CONFIG_FIRMWARE_INCLUDE_TOR=n/' .config
