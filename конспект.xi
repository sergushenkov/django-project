. ссылка на курс - https://stepik.org/course/125859

Подготовка к работе .
. ВНУТРИ верхнеуровневой директории проекта создать и активировать виртуальное окружение (имя лучше задать отличное от стандартного .venv, чтобы не путаться):
  | python3 -m venv .store-venv
  | source .store-venv/bin/activate
. выйти из виртуального окружения - deactivate

. Django надо устанавливать версии LTS (long-term support) - https://www.djangoproject.com/download/#supported-versions
  . установить версию со всеми апдейтами
    | pip install 'Django>4.2,<4.3'

. Из верхней директории проекта иницилизируем новый джанго-проект store
  | django-admin startproject store
  . создаются файл store/manage.py и store/store/ - главный каталог с четырьмя файлами
    . settings.py - задаются настройки и глобальные переменные
    . urls.py - как джанго интерпретирует путь
    . asgi.py - для деплоя на прод
    . wsgi.py - 

manage.py .
. django-admin запускает те же процессы что и ./manage.py
. запуск сервера 
  | ./manage.py runserver 8000 
  . доступен по http://127.0.0.1:8000/, порт 8000 - дефолтный, можно не указывать
. создать приложение
  | ./manage.py startapp products
. запустить питон в окружении проекта
  | ./manage.py shell
. создать админа
  | ./manage.py createsuperuser

Dev vs Prod .
  Local Dev .
  . db.sqlite3
  . 127.0.0.1:8000
  . Developers
  . Debug: TRUE
  Production .
  . PostgreSQL
  . mysite.com
  . All users
  . Debug: FALSE

Модель БД .
  ProductCategory .
  id: PK
  Product .
  id: PK
  category: FK ProductCategory.id
  Basket .
  id: PK
  product: FK Product.id
  user: FK User.id
  User .
  id: PK

Приложения .
. В Джанго многие функции реализованы заранее (см. settings.py) и надо просто мигрировать приложения в проект, чтобы получить доступ к их функционалу
  | INSTALLED_APPS = [
  |     'django.contrib.admin',  # мощная админ-панель
  |     'django.contrib.auth',  # работа с пользователями
  |     'django.contrib.contenttypes',
  |     'django.contrib.sessions',
  |     'django.contrib.messages',
  |     'django.contrib.staticfiles',
  | ]
. весь джанго проект также реализуется через приложения
  . работа с пользователями - users_app
  . работа с продуктами - products_app
. архитектура проекта (какие нужны приложения) - обычно понятнее через архитектуру БД
. создать приложение
  | ./manage.py startapp products
  . после создания приложение необходимо зарегистрировать - добавить в settings.py в INSTALLED_APPS
  файлы в приложении .
  . admin.py - отвечает за регистрацию таблиц в админке
  . apps.py - информация о конфигурации, что за приложение
  . models.py - создается таблица для БД
  . tests.py - тесты
  . views.py - функции для отображения шаблонов на сайте

как работает джанго .
. HTTP Request обрабатывается urls.py
. запрос перенаправляется на соответствующее представление/контроллер во views.py
  . используется нужный шаблон <filename>.html
  . при необходимости - чтение / запись данных models.py
  . вернуть HTTP Responce

Создание контроллеров .
. В директории проекта (там где manage.py) создаем папку приложения через 
  | ./manage.py startapp products
. Для подключения шаблонов создаём в ней директорию /templates/products в которой будут размещаться html-файлы
  . дублирование названия ./products/templates/products/ требуется чтобы при обращении к одноименным html-файлам в разных директориях templates не возникало путаницы
. Функции в файле ./products/views.py в джанго среде принято называть контроллеры (очень редко - вьюхи)
  Чтобы добавить стили: .
  . создаём папку store-server/store/static
  . копируем в неё директорию vendor из шаблона сайта
  . исправляем ссылки внутри store-server/store/products/templates/products/index.html на |static|/vendor/.../filename.css
  . перезагружаем сервер
! путь до картинок в html-файлах определяется неправильно
  . должно быть store-server/store/static/vendor/img/slides/slide-1.jpg
  . на сайте http://127.0.0.1:8000/products/static/vendor/img/slides/slide-1.jpg

HttpRequest .
. переменная request - экземпляр класса HttpRequest
  . все мета-данные о запросе, который был выполнен (например, когда открылась страница)

ORM (ObjectRelational Mapping) .
. связывает базы данных с концепциями OOП
. классы в файле ./products/models.py в джанго среде принято называть модели - это описания таблиц в БД
  Миграция .
  . Миграция - перенос структуры модели на структуру БД
    Команды .
    . makemigrations - создание новых миграций
    . migrate - применение миграций
  Заполнение таблиц .
    через консоль .
    | ./manage.py shell
    | from products.models import ProductCategory
    | category = ProductCategory(name='Одежда', description='Описание для одежды')
    | category.save()
      . чтобы в качестве объекта category отображалось его имя (<ProductCategory: Одежда>), стоит переопределить метод __str__() в его классе
        | def __str__(self):
        |     return self.name
      . более сложный вариант
        | def __str__(self):
        |   return f'Продукт: {self.name} | Категория: {self.category.name}
      . получить значение объекта из класса
        | category = ProductCategory.objects.get(id=1)
      . создать объект из БД
        | >>> ProductCategory.objects.create(name='Обувь')
      . список объектов в категории
        | >>> ProductCategory.objects.all()
        | <QuerySet [<ProductCategory: Одежда>, <ProductCategory: Обувь>]>
      . отбор объектов по фильтру
        | >>> ProductCategory.objects.filter(description=None)
        | <QuerySet [<ProductCategory: Обувь>]>
  БД PostgreSQL .
  . SQLite - по дефолту, в основном для локальной разработки или для маленьких проектов
    настройки
    | create database db_name;
    | create role name with password 'password';
    | alter role "name" with login;  -- возможность входа
    | grant all privileges on database "db_name" to name;
    | alter user name createdb;  -- возможность создания БД
