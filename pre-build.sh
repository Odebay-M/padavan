#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем бинарник nfqws2 через зеркало..."

# Прямая ссылка на бинарник внутри релиза через CDN jsDelivr
URL="https://jsdelivr.net"

# Качаем с проверкой
curl -L -k -f -A "Mozilla/5.0" -o user/nfqws/nfqws "$URL"

# Проверка на ELF (бинарный формат)
if ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "ОШИБКА: Файл не скачался или он не бинарный. Пробуем резервную raw-ссылку..."
    URL_RAW="https://githubusercontent.com"
    curl -L -k -f -A "Mozilla/5.0" -o user/nfqws/nfqws "$URL_RAW"
fi

# Финальный контроль
if [ ! -s user/nfqws/nfqws ] || ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "КРИТИЧЕСКАЯ ОШИБКА: Бинарник nfqws2 не получен!"
    exit 1
fi

chmod +x user/nfqws/nfqws
echo "Успех! Бинарник nfqws2 (mipsel) готов."

# Создаем Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
