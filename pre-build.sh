#!/bin/bash
cd padavan-ng/trunk

# 1. Создаем папку
mkdir -p user/nfqws

# 2. Скачиваем бинарник v0.9.5 (архитектура mips32r1-softfloat)
# Ссылка проверена, файл по ней существует
curl -A "Mozilla/5.0" -L -f -o user/nfqws/nfqws https://github.com

# 3. Проверка на пустоту (чтобы не прошивать пустой файл снова)
if [ ! -s user/nfqws/nfqws ]; then
    echo "ERROR: nfqws is empty or download failed!"
    exit 1
fi

chmod +x user/nfqws/nfqws

# 4. Makefile для интеграции в образ
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
