#!/bin/bash
cd padavan-ng/trunk
mkdir -p user/nfqws

echo "Скачиваем полный архив zapret, чтобы достать nfqws..."

# Качаем официальный релиз (архив mips32), так GitHub отдает файлы лучше
curl -L -f -o zapret.tar.gz https://github.com

# Распаковываем только один нужный нам файл
tar -xzvf zapret.tar.gz zapret-v0.9.5/binaries/mips/nfqws-mips32r1-softfloat --strip-components=3
mv nfqws-mips32r1-softfloat user/nfqws/nfqws

# Финальная проверка на работоспособность бинарника
if [ ! -s user/nfqws/nfqws ] || ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "ОШИБКА: Бинарник не извлечен!"
    exit 1
fi

echo "Успех! Бинарник nfqws v0.9.5 готов."
chmod +x user/nfqws/nfqws

# Создаем Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
