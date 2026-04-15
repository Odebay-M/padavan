#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем полный архив релиза v0.9.5..."

# Качаем архив целиком. Он весит около 500КБ-600КБ, это именно то, что скачалось в прошлый раз
curl -L -f -o zapret.tar.gz https://github.com

# Распаковываем только нужный нам бинарник из глубин архива
tar -xzvf zapret.tar.gz --strip-components=3 zapret-v0.9.5/binaries/mips/nfqws-mips32r1-softfloat

# Переносим его в нужную папку
mv nfqws-mips32r1-softfloat user/nfqws/nfqws

# Проверка на ELF (магические байты бинарника)
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "КРИТИЧЕСКАЯ ОШИБКА: Извлеченный файл не является бинарником!"
    exit 1
fi

echo "Успех! Бинарник nfqws v0.9.5 извлечен."
chmod +x user/nfqws/nfqws

# Генерируем Makefile для прошивки
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
