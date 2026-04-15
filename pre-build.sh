#!/bin/bash
cd padavan-ng/trunk

mkdir -p user/nfqws

# Правильная ссылка на raw-файл
URL="https://githubusercontent.com"

echo "Attempting to download nfqws..."

# Пробуем скачать через curl с правильными заголовками
curl -k -L -A "Mozilla/5.0" -o user/nfqws/nfqws "$URL" || wget --no-check-certificate -U "Mozilla/5.0" -O user/nfqws/nfqws "$URL"

# Проверка: если файл не ELF бинарник, пробуем прямую ссылку на релиз
if ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "Primary link failed or not a binary. Trying Release link..."
    URL_REL="https://github.com"
    curl -k -L -A "Mozilla/5.0" -o user/nfqws/nfqws "$URL_REL"
fi

# Финальная проверка
if [ ! -f user/nfqws/nfqws ] || ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "ОШИБКА: Бинарный файл не скачан. Содержимое того, что пришло:"
    cat user/nfqws/nfqws | head -n 5
    exit 1
fi

echo "Success! ELF binary detected."
chmod +x user/nfqws/nfqws

# Создаем Makefile, который просто копирует файл
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
