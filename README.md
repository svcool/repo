# Самый главный заголовок
## Второй по важности заголовок
### Почти неважный заголовок
Мы учимся в [Нетологии](https://netology.ru)
![Логотип Нетологии](https://netology.ru/dist/public/images/logo-color-text_6748e2.svg)
1. Пункт раз
2. Пункт два
3. Пункт три
- пункт раз
- Пункт два
- Пункт три

## Первоначальная настройка
1. git --version
2. git config --global user.name "Emma Paris"
3. git config --global user.email "eparis@atlassian.com"
4. git config --global --list
## Настройка формата окончания строк
Задайте правильный формат строк.
### Если у вас macOS или Linux, последовательно выполните две команды:
git config --global core.autocrlf input
git config --global core.safecrlf warn
### Если у вас Windows, то выполните последовательно эти команды:
git config --global core.autocrlf true
git config --global core.safecrlf warn
### Дальше общая для всех операционных систем команда, которая позволит
git config --global core.quotepath off
### Задайте общепринятое название основной ветки в репозитории в Git — main
git config --global init.defaultBranch main
## Справка в Git
git help -g
git help команда
wq - выйти из справки
## Связывание папки с git
git init
git status
## Работа с файлами
git add "имя файла"
git add . - добавить все файлы в папке
git aff -А - добавить все файлы в папке