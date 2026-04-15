#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Определяем последнюю версию Zapret 2..."

# 1. Получаем тег последнего релиза (например, v0.9.5) через API GitHub
LATEST_TAG=$(curl -s https://github.com/bol-van/zapret2 | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "ОШИБКА: Не удалось получить версию. Проверьте сеть."
    exit 1
fi

echo "Найдена версия: $LATEST_TAG"

# 2. Формируем ПРАВИЛЬНУЮ ссылку на скачивание архива
URL="https://github.com/bol-van/zapret2{LATEST_TAG}/zapret2-${LATEST_TAG}.zip"

echo "Загружаем архив: $URL"

# 3. Скачиваем архив
curl -L -f -o zapret2.zip "$URL"

# 4. Распаковываем только nfqws2 для архитектуры mipsel (Little Endian для MT7620)
# Флаг -j позволяет игнорировать структуру папок внутри ZIP
unzip -j zapret2.zip "zapret2-${LATEST_TAG}/binaries/linux-mipsel/nfqws2" -d user/nfqws/

# 5. Переименовываем в nfqws и даем права на исполнение
mv user/nfqws/nfqws2 user/nfqws/nfqws
chmod +x user/nfqws/nfqws

# 6. Проверка: если файл не ELF бинарник - прерываем
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "ОШИБКА: Бинарник не извлечен или поврежден!"
    exit 1
fi

echo "Успех! Zapret 2 ($LATEST_TAG) готов к сборке."
rm -f zapret2.zip

# 7. Создаем Makefile для интеграции в прошивку
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
