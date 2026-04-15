#!/bin/bash
cd padavan-ng/trunk

# 1. Создаем папку
mkdir -p user/nfqws

# 2. Получаем версию последнего релиза через API GitHub
LATEST_TAG=$(curl -s https://github.com | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

echo "Found latest version: $LATEST_TAG"

# 3. Скачиваем бинарник именно этой версии
# Архитектура mips32r1-softfloat для Xiaomi Mi 3
curl -A "Mozilla/5.0" -L -f -o user/nfqws/nfqws "https://github.com{LATEST_TAG}/nfqws-mips32r1-softfloat"

# 4. Проверка на пустоту
if [ ! -s user/nfqws/nfqws ]; then
    echo "CRITICAL ERROR: Download failed!"
    exit 1
fi

chmod +x user/nfqws/nfqws

# 5. Makefile для сборки
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
