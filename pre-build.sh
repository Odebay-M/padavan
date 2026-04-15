#!/bin/bash
# Переходим в корень сборки
cd padavan-ng/trunk
mkdir -p user/nfqws

# Копируем файл, который ты только что загрузил вручную (он уже на сервере)
cp ../../nfqws2 user/nfqws/nfqws
chmod +x user/nfqws/nfqws

# Генерируем Makefile
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF

echo "Успех! Бинарник взят из твоих файлов репозитория."
