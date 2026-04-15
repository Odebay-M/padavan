#!/bin/bash

# Переходим в папку с исходниками
cd padavan-ng/trunk

# 1. Включаем критически важные модули (IPSET и HTTPS)
sed -i 's/CONFIG_FIRMWARE_INCLUDE_IPSET=n/CONFIG_FIRMWARE_INCLUDE_IPSET=y/' .config
sed -i 's/CONFIG_FIRMWARE_INCLUDE_HTTPS=n/CONFIG_FIRMWARE_INCLUDE_HTTPS=y/' .config

# 2. Создаем временную папку для скачивания бинарников zapret2
mkdir -p user/zapret2

# 3. Скачиваем актуальный бинарник nfqws из репозитория zapret
# Для Mi Router 3 (MT7620) берем mips32r1-softfloat
curl -L -o user/zapret2/nfqws https://github.com

# Делаем его исполняемым
chmod +x user/zapret2/nfqws

# 4. Прописываем копирование бинарника в систему (/usr/bin/nfqws)
# Используем Makefile, чтобы файл попал в итоговый образ прошивки
sed -i '/romfs:/a \	$(ROMFSINST) -p +x $(ROOTDIR)/user/zapret2/nfqws /usr/bin/nfqws' user/Makefile

# 5. Опционально: Добавляем скрипт-помощник (tpws, если нужен, качается аналогично)
# Для работы zapret2 обычно достаточно одного nfqws
