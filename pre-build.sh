#!/bin/bash
cd padavan-ng/trunk

mkdir -p user/nfqws

# Ссылка на зеркало (официальный репозиторий bol-van, но через jsDelivr или прямой raw)
# Попробуем скачать через ://githubusercontent.com - он лояльнее к curl
URL="https://://githubusercontent.com/bol-van/zapret/master/binaries/mips/nfqws-mips32r1-softfloat"

echo "Downloading nfqws from $URL..."

# Качаем с флагами, имитирующими браузер
curl -k -A "Mozilla/5.0" -L -sS -o user/nfqws/nfqws "$URL"

# ПРОВЕРКА №1: Если файл всё еще пустой, пробуем запасную ссылку (релиз v0.9.5)
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "First link failed, trying backup..."
    URL_BACKUP="https://github.com"
    curl -k -A "Mozilla/5.0" -L -sS -o user/nfqws/nfqws "$URL_BACKUP"
fi

# ФИНАЛЬНАЯ ПРОВЕРКА: Если и это не помогло - выводим что скачалось для отладки
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "ОШИБКА: Снова скачался текст! Содержимое начала файла:"
    head -n 5 user/nfqws/nfqws
    exit 1
fi

echo "Success! Binary file (ELF) downloaded."
chmod +x user/nfqws/nfqws

# Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
