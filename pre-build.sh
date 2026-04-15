#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем бинарник через зеркало jsDelivr (CDN)..."

# Зеркало jsDelivr для того же самого файла nfqws
URL="https://jsdelivr.net"

# Пытаемся скачать
curl -k -L -A "Mozilla/5.0" -o user/nfqws/nfqws "$URL" || wget --no-check-certificate -O user/nfqws/nfqws "$URL"

# ПРОВЕРКА: Если файл всё еще не бинарник
if ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "ОШИБКА: CDN тоже не отдал файл. Содержимое того, что пришло:"
    cat user/nfqws/nfqws | head -n 5
    exit 1
fi

echo "Успех! Бинарник nfqws на месте (скачан через CDN)."
chmod +x user/nfqws/nfqws

# Создаем Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
