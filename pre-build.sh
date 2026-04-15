#!/bin/bash

# 1. Переходим в папку с компонентом zapret (в padavan-ng он в user/nfqws)
cd padavan-ng/trunk/user/nfqws

# 2. Удаляем старые исходники
rm -rf *

# 3. Клонируем zapret2 напрямую в эту папку
git clone --depth=1 https://github.com/bol-van/zapret2

# 4. Создаем новый Makefile специально для Padavan, чтобы он собрал nfqws2
cat << 'EOF' > Makefile
# Простой Makefile для сборки nfqws2 в окружении Padavan
TGT := nfqws2
SRCDIR := nfqws
SRC := $(SRCDIR)/nfqws.c $(SRCDIR)/helpers.c $(SRCDIR)/sec.c $(SRCDIR)/conntrack.c $(SRCDIR)/protocol.c $(SRCDIR)/params.c $(SRCDIR)/packets.c $(SRCDIR)/desync.c $(SRCDIR)/hostlist.c $(SRCDIR)/proxy.c

all: $(TGT)

$(TGT): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lnetfilter_queue -lnfnetlink -lpthread

clean:
	rm -f $(TGT)

romfs:
	$(ROMFSINST) /usr/bin/$(TGT)
EOF

# 5. (Опционально) Исправляем скрипты запуска прошивки, чтобы они искали nfqws2 вместо nfqws
cd ../../../
find trunk/user/scripts -type f -name "*.sh" -exec sed -i 's/nfqws/nfqws2/g' {} +
