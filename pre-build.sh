#!/bin/bash
cd padavan-ng/trunk

# 1. Принудительно создаем папку для nfqws
mkdir -p user/nfqws

# 2. Скачиваем бинарник nfqws (Zapret 2) для MT7620
# Мы берем его из основной ветки, где лежит актуальная 2-я версия
curl -L -o user/nfqws/nfqws https://github.com
chmod +x user/nfqws/nfqws

# 3. ВАЖНО: Модифицируем Makefile nfqws, чтобы он НЕ скачивал старье
# и НЕ пытался ничего компилировать, а просто взял наш готовый файл
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
