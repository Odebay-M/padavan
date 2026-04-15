#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

# 1. Скачиваем архив zapret2 v0.9.5
URL="https://github.com"
curl -L -f -o zapret2.zip "$URL"

# 2. Распаковываем только nfqws2 для архитектуры mipsel
# В ZIP он лежит по пути: zapret2-v0.9.5/binaries/linux-mipsel/nfqws2
unzip -j zapret2.zip "zapret2-v0.9.5/binaries/linux-mipsel/nfqws2" -d user/nfqws/

# 3. Переименовываем для удобства в nfqws и даем права
mv user/nfqws/nfqws2 user/nfqws/nfqws
chmod +x user/nfqws/nfqws

# 4. Проверка на ELF (чтобы не прошить пустоту)
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "ОШИБКА: Бинарник linux-mipsel/nfqws2 не найден!"
    exit 1
fi

rm -f zapret2.zip
echo "Успех! nfqws2 (mipsel) извлечен и готов."

# 5. Генерируем Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF

