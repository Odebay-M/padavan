#!/bin/bash

# 1. Заходим в папку nfqws внутри дерева исходников
# В вашем воркфлоу папка называется padavan-ng
cd padavan-ng/trunk/user/nfqws

# 2. Очищаем всё старое
rm -rf *

# 3. Клонируем zapret2 правильно (с точкой в конце)
git clone --depth=1 https://github.com/bol-van/zapret2 .

# 4. Создаем Makefile (исправлены пути к объектным файлам)
cat << 'EOF' > Makefile
TGT1 := nfqws2
SRC1 := nfqws/nfqws.c nfqws/helpers.c nfqws/sec.c nfqws/conntrack.c nfqws/protocol.c nfqws/params.c nfqws/packets.c nfqws/desync.c nfqws/hostlist.c nfqws/proxy.c

TGT2 := tpws
SRC2 := tpws/tpws.c tpws/helpers.c tpws/params.c tpws/protocol.c tpws/sec.c tpws/hostlist.c

all: $(TGT1) $(TGT2)

$(TGT1): $(SRC1)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lnetfilter_queue -lnfnetlink -lpthread -lz

$(TGT2): $(SRC2)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lpthread -lz

clean:
	rm -f $(TGT1) $(TGT2)

romfs:
	$(ROMFSINST) /usr/bin/$(TGT1)
	$(ROMFSINST) /usr/bin/$(TGT2)
EOF

# 5. Возвращаемся в корень репозитория padavan-ng
cd ../../../

# 6. Включаем необходимые опции в .config
# Используем седы для поиска и замены, если опция уже есть
sed -i 's/^# CONFIG_FIRMWARE_INCLUDE_NFQWS is not set/CONFIG_FIRMWARE_INCLUDE_NFQWS=y/' trunk/.config
grep -q "CONFIG_FIRMWARE_INCLUDE_LIBNETFILTER_QUEUE=y" trunk/.config || echo "CONFIG_FIRMWARE_INCLUDE_LIBNETFILTER_QUEUE=y" >> trunk/.config
grep -q "CONFIG_FIRMWARE_INCLUDE_ZLIB=y" trunk/.config || echo "CONFIG_FIRMWARE_INCLUDE_ZLIB=y" >> trunk/.config

# 7. Глобальная замена вызова бинарника в скриптах прошивки
find trunk/user/scripts -type f -name "*.sh" -exec sed -i 's/nfqws/nfqws2/g' {} +

echo "Pre-build stage for zapret2 finished successfully."
