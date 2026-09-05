# Базовый образ Debian
FROM debian:bookworm

# Установка необходимых утилит и локалей
RUN apt-get update && apt-get install -y \
    locales \
    wget \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Установка переменной окружения для локалей
ENV LANG ru_RU.UTF-8

# Добавление репозитория PostgresPro и установка PostgresPro-1C
RUN wget https://repo.postgrespro.ru/1c/1c-17/keys/pgpro-repo-add.sh \
    && chmod +x pgpro-repo-add.sh \
    && ./pgpro-repo-add.sh \
    && apt-get update \
    && apt-get install -y postgrespro-1c-17 \
    && rm -rf /var/lib/apt/lists/*

# Создание директории для данных и настройка прав
RUN mkdir /pgdata && chown postgres:postgres /pgdata
# RUN mkdir /pgdata && chown postgres:postgres /pgdata && chmod 0700 /pgdata

# Копирование и настройка скрипта (выполняется от root)
COPY start.sh /
RUN chmod +x /start.sh

# Указание тома для хранения данных
VOLUME /pgdata

# Переключение на пользователя postgres
USER postgres

# Команда запуска через скрипт
CMD ["/bin/bash", "-c", "/start.sh"]