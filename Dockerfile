FROM alpine:3.19

# Инсталираме необходимите утилити: MySQL/Postgres клиенти, zip/tar за архивиране, curl/openssh за трансфер и нотификации
RUN apk add --no-cache \
    bash \
    mysql-client \
    tar \
    zip \
    curl \
    openssh-client \
    tzdata

# Създаваме работна директория в контейнера
WORKDIR /app

# Копираме цялата папка със скриптове вътре в имиджа
COPY scripts/ /app/scripts/

# Даваме права за изпълнение на всички bash скриптове
RUN chmod +x /app/scripts/*.sh

# По подразбиране можем да зададем entrypoint или да оставим контейнера гъвкав
# (В зависимост от това кой скрипт ще викаш през Makefile-а)
ENTRYPOINT ["/bin/bash"]