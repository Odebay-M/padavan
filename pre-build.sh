#!/bin/bash
cd padavan-ng/trunk

# 1. Создаем папку
mkdir -p user/nfqws

# 2. Скачиваем бинарник (версия 0.9.5 для Mi Router 3)
# Добавляем флаг -sS (молчать, но показывать ошибки) и -f (ошибка при 404)
curl -L -f -sS -o user/nfqws/nfqws https://github.com

# 3. КРИТИЧЕСКАЯ ПРОВЕРКА
# Если файл не существует или его размер 0 - сборка КРАШИТСЯ здесь
if [ ! -s user/nfqws/nfqws ]; then
    echo "-------------------------------------------------------"
    echo "ОШИБКА: zapret не скачался или пустой! Сборка остановлена."
    echo "-------------------------------------------------------"
    exit 1
fi

# 4. Проверяем, что это реальный бинарник (должен содержать строку ELF)
if ! head -c 4 user/nfqws/nfqws | grep -q "ELF"; then
    echo "ОШИБКА: Скачался текст вместо программы! Сборка остановлена."
    exit 1
fi

chmod +x user/nfqws/nfqws

# 5. Создаем "заглушку" Makefile, чтобы прошивка просто скопировала наш файл
cat <<EOF > user/nfqws/Makefile
all:
clean:
romfs:
	\$(ROMFSINST) -p +x \$(ROOTDIR)/user/nfqws/nfqws /usr/bin/nfqws
EOF
