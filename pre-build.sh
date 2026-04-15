#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем архив zapret2 v0.9.5..."

# Твоя ссылка на архив
URL="https://github.com/bol-van/zapret2/releases/download/v0.9.5/zapret2-v0.9.5.zip"

# Качаем архив (флаг -L обязателен для редиректов GitHub)
curl -L -f -o zapret2.zip "$URL"

# Распаковываем только nfqws для твоей архитектуры (mips32r1-softfloat)
# В архиве zapret2 структура папок может быть другой, поэтому достаем файл напрямую
unzip -j zapret2.zip "*/nfqws-mips32r1-softfloat" -d user/nfqws/

# Переименовываем в короткое название для системы
mv user/nfqws/nfqws-mips32r1-softfloat user/nfqws/nfqws
chmod +x user/nfqws/nfqws

# Проверка: если файл пустой или не бинарник - стопаем сборку
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "ОШИБКА: Бинарник не извлечен или поврежден!"
    exit 1
fi

echo "Успех! Zapret2 (nfqws) готов к вшиванию."

# Создаем Makefile, чтобы прошивка подхватила файл
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
