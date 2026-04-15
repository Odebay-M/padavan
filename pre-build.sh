#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем полный архив релиза v0.9.5..."

# ПРАВИЛЬНАЯ ССЫЛКА НА АРХИВ
URL="https://github.com"

curl -L -f -o zapret.tar.gz "$URL"

# Проверка: скачался ли файл вообще
if [ ! -f zapret.tar.gz ]; then
    echo "ОШИБКА: Файл zapret.tar.gz не найден!"
    exit 1
fi

# Распаковываем бинарник
tar -xzvf zapret.tar.gz --strip-components=3 zapret-v0.9.5/binaries/mips/nfqws-mips32r1-softfloat

# Проверяем, появилось ли извлеченное приложение
if [ ! -f nfqws-mips32r1-softfloat ]; then
    echo "ОШИБКА: Не удалось извлечь бинарник из архива!"
    exit 1
fi

mv nfqws-mips32r1-softfloat user/nfqws/nfqws
chmod +x user/nfqws/nfqws

echo "Успех! Бинарник nfqws v0.9.5 готов."

# Создаем Makefile для интеграции в прошивку
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
