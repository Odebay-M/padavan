#!/bin/bash
# Переходим в корень сборки
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Пытаемся скачать nfqws автоматически через GitHub CLI..."

# 1. Используем встроенную утилиту gh для получения ссылки на последний релиз
# Это работает надежнее, чем обычный curl
LATEST_TAG=$(gh release view --repo bol-van/zapret --json tagName --template '{{.tagName}}')
echo "Detected version: $LATEST_TAG"

# 2. Скачиваем файл. Если curl упадет, пробуем скачать через gh release download
gh release download "$LATEST_TAG" --repo bol-van/zapret --pattern 'nfqws-mips32r1-softfloat' --output user/nfqws/nfqws

# 3. Если gh не справился (бывает в контейнерах), используем аварийный CDN
if [ ! -s user/nfqws/nfqws ]; then
    echo "GH CLI failed, trying direct CDN link..."
    curl -k -L -A "Mozilla/5.0" -o user/nfqws/nfqws "https://github.com{LATEST_TAG}/nfqws-mips32r1-softfloat"
fi

# 4. Проверка на ELF (бинарность)
if ! head -c 4 user/nfqws/nfqws 2>/dev/null | grep -q "ELF"; then
    echo "КРИТИЧЕСКАЯ ОШИБКА: Бинарный файл не получен."
    exit 1
fi

chmod +x user/nfqws/nfqws
echo "Success! nfqws $LATEST_TAG ready."

# 5. Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
