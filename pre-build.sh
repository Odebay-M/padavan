#!/bin/bash
cd padavan-ng/trunk

# 1. Подготовка папки
mkdir -p user/nfqws

# 2. Скачивание версии 0.9.5 по прямой ссылке
# Добавляем флаги для надежности: -L (редирект), -f (ошибка при 404), -S (показывать ошибки)
curl -L -f -S -o user/nfqws/nfqws https://github.com

# 3. ПРОВЕРКА: Если файл пустой — сборка упадет с понятной ошибкой
if [ ! -s user/nfqws/nfqws ]; then
    echo "КРИТИЧЕСКАЯ ОШИБКА: Файл nfqws не скачался!"
    exit 1
fi

chmod +x user/nfqws/nfqws

# 4. Makefile для прошивки
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
