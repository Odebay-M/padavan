
#!/bin/bash

# 1. Заходим в папку nfqws внутри дерева исходников
cd padavan-ng/trunk/user/nfqws || exit 1

# 2. Очищаем всё старое и качаем zapret2
echo "Cleaning and downloading zapret2..."
rm -rf *
git clone --depth=1 https://github.com/bol-van/zapret2.git .

# 3. Создаем "умный" Makefile, который видит библиотеки Padavan
echo "Creating optimized Makefile..."
cat << 'EOF' > Makefile
TGT1 := nfqws2
# Список исходников из папок nfq2 и nfq2/crypto
SRC1 := nfq2/nfqws.c nfq2/helpers.c nfq2/sec.c nfq2/conntrack.c nfq2/protocol.c \
        nfq2/params.c nfq2/desync.c nfq2/hostlist.c nfq2/darkmagic.c nfq2/filter.c \
        nfq2/ipset.c nfq2/packet_queue.c nfq2/pools.c nfq2/random.c nfq2/timer.c \
        nfq2/checksum.c nfq2/gzip.c \
        nfq2/crypto/aes.c nfq2/crypto/aes-ctr.c nfq2/crypto/aes-gcm.c \
        nfq2/crypto/gcm.c nfq2/crypto/hkdf.c nfq2/crypto/hmac.c \
        nfq2/crypto/sha224-256.c nfq2/crypto/usha.c

# Добавляем пути к заголовочным файлам библиотек из Toolchain/Staging
CFLAGS += -I$(STAGEDIR)/include -D_GNU_SOURCE
LDFLAGS += -L$(STAGEDIR)/lib

all: $(TGT1)

$(TGT1): $(SRC1)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lnetfilter_queue -lnfnetlink -lpthread -lz

clean:
	rm -f $(TGT1)

romfs:
	$(ROMFSINST) /usr/bin/$(TGT1)
	$(STRIP) /usr/bin/$(TGT1)
EOF

# 4. Возвращаемся в корень репозитория
cd ../../../

# 5. Принудительно включаем зависимости в build.config
# Это критично, чтобы библиотеки собрались РАНЬШЕ nfqws2
echo "Updating build.config..."
sed -i 's/CONFIG_FIRMWARE_INCLUDE_NFQWS=n/CONFIG_FIRMWARE_INCLUDE_NFQWS=y/' build.config

for opt in CONFIG_FIRMWARE_INCLUDE_NFQWS CONFIG_FIRMWARE_INCLUDE_LIBNETFILTER_QUEUE \
           CONFIG_FIRMWARE_INCLUDE_LIBNFNETLINK CONFIG_FIRMWARE_INCLUDE_ZLIB; do
  if ! grep -q "$opt=y" build.config; then
    echo "$opt=y" >> build.config
  fi
done

# 6. Патчим скрипты прошивки (меняем nfqws на nfqws2)
echo "Patching scripts..."
find padavan-ng/trunk/user/scripts -type f -name "*.sh" -exec sed -i 's/nfqws/nfqws2/g' {} +

echo "Pre-build stage for Mi3 finished."
