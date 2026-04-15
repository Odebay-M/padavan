#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем бинарник с альтернативного зеркала..."

# Используем raw-ссылку напрямую (она стабильнее)
URL="https://githubusercontent.com"

# Качаем с флагами, которые заставляют сервер отдать файл
curl -k -L -A "Mozilla/5.0" -o user/nfqws/nfqws "$URL"

# ПРОВЕРКА: Если файл всё еще не бинарник, пробуем скачать через wget
if ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "Curl failed, trying wget..."
    wget --no-check-certificate -O user/nfqws/nfqws "$URL"
fi

# ФИНАЛЬНАЯ ПРОВЕРКА
if ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "ОШИБКА: Опять скачался текст. Содержимое:"
    cat user/nfqws/nfqws | head -n 5
    exit 1
fi

echo "Успех! Бинарник nfqws на месте."
chmod +x user/nfqws/nfqws

# Создаем Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
