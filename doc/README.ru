#123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789

mkimage - это набор утилит для создания образов дисков.

################################################################################
### Идея.
################################################################################

Основная идея - это то, что создание образа диска схоже с компиляцией программы.
Это задача, которая не предназначена для обычного пользователя. Собственно, как
и процесс создания профиля.

Раз уж мы хотим получить инструмент пригодный для разработчика, то лучше
пользоваться привычными ему подходами и инструментами (например, make и
configure).

mkimage основан на GNU make, т.к. это привычный и удобный (что немаловажно)
инструмент. Для построения чрутов используется hasher. Вспомогательные скрипты
написаны на POSIX shell.

################################################################################
### Сборка образа
################################################################################

Создание любого образа можно разбить на несколько стадий. Например: создание
образа инсталлятора, создание образа с пакетами для базовой системы, создание
iso-образа диска ... всё это разные, возможно(!), связанные между собой стадии.

Создание iso-образа диска можно представить ввиде дерева:

 iso-image          <-- Подкаталоги: installer RPMS.base RPMS.extra
  \- installer      <-- Подкаталоги: stage1 stage2 stage3 stage4
     \- stage1
     \- stage2
     \- stage3      <-- Подкаталоги: stage3-1 stage3-2
        \- stage3-1
        \- stage3-2
     \- stage4
  \- RPMS.base
  \- RPMS.extra

Таким образом, у нас появляется иерархия стадий создания образа. Каждый
вышестоящий образ получает в распоряжение результаты нижестоящих.
Каждая из стадий обрабатывается одинаково, начиная с самого глубокого
уровня вложенности.
Уровень вложенности может быть сколь угодно большим. Главное хватило бы места
на жёстком диске.

################################################################################
### Стадия сборки образа
################################################################################

Каждая стадия в mkimage состоит из следующих компонент:

1. Конфигурационный файл (Makefile) - сожержит инструкции по сборке, определяет
в каком порядке выполнять разные стадии и как оформить результат;

2. Входные данные. Данные могут какие угодно... даже другие образы. Входные
данные описаны в конфигурационном файле и используются на стадии сборки.

3. Выходные данные. В результате работы по сборке образа получается один или
несколько файлов. Если результат пустой, то, блин, что мы тогда делали?!

На файловой системе это выглядит так:

\- Image directory
   \- Makefile      <--  Это конфигурационный файл
   \- .work
      \- aptbox         |
      \- chroot         | Это инструментальнй чрут
         \- .work
            \- aptbox       |
            \- chroot       | Это рабочий чрут
                            |
      \- .out        <--  Это директория для хранения результата (по умолчанию)
      \- .cache      <--  Это кэш mkimage

Инструментальный чрут предназначен для установки программ, необходимых для
сборки образа (например mkisofs или mkmar)... ведь для каждого образа могут
понадобиться совершенно разные программы. Нельзя требовать их наличия в системе,
где происходит сборка. См. переменные CHROOT_PACKAGES и CHROOT_PACKAGES_REGEXP.

Рабочий чрут - это директория, которая будет запакована в образ. Слово "чрут" в
данном случае применяется весьма условно, потому что в этой директории может
быть всё что угодно (как чрут, так и просто набор файлов).

В директорию `.out' копируется результат обработки стадии. Именно результат
обработки, потому что им может быть как один файл, так и несколько файлов или
каталогов. Так как результат заранее не известен, эта директория очищается
перед каждой операцией записи. Это нужно учитывать и не оставлять в ней ничего
ценного между сборками. Это поведение можно изменить переменной CLEANUP_OUTDIR,
но это потенциально опасно, т.к. результаты будут накладываться друг на друга.

Кэш. Кэш, он полезный. В кэш, по возможности, заносятся данные о каждой
выполенной цели и её результатах. Цель не выполняется, если входные данные и
результаты работы не изменились с прошлого запуска mkimage.
Не все цели можно кэшировать, например, копирование файлов в чрут кэшировать не
удастся, т.к. неизвестно, что произошло с файлами в чруте потом.
Кэширование можно отключать через переменную NO_CACHE.

################################################################################
### Конфигурационный файл
################################################################################

Как уже говорилось, конфигурационный файл - это Makefile. Для него определена 
некоторая конфигурация (config.mk) и набор целей по умолчанию (targets.mk).
Эти файлы следует включать в каждый Makefile.

Разделение на config.mk и targets.mk было сделано в версии 0.0.7. Для
обратной совместимости со старыми версиями файл rules.mk включает в себя
config.mk и targets.mk.

ВАЖНО: rules.mk помжет приводить к ошибкам в работе и не рекомендуется к
использованию.

Общий вид Makefile'а таков:
# <<< *** file Makefile ***

include config.mk

<собственные параметры, изменяющие значения по умолчанию>

include targets.mk

<собственные сборочные цели или последовательность стандартных целей>

# *** (end of Makefile) *** >>>

Для полее полного понимания можно посмотреть примеры (examples/*).

################################################################################
### Конфигурационный файл (Сборочные цели)
################################################################################

Создание любого образа описывается набором целей. Каждая цель - это атомарное
действие с точки зрения mkimage. Ими могут являться как создание загрузочного
образа, так и копирование в рабочий чрут каких-либо файлов. Вы можете
как пользоваться предопределёнными целями, так и писать свои.

Вот список определённых целей (в скобках указаны переменные, которые влияют на
выполнение конкретной цели, их описание приведено ниже):

run-scripts        - Выполняет скрипты внутри инструментального чрута
                     (MKI_SCRIPTDIR).
run-image-scripts  - То же самое, что и `run-scripts', но выполняет скрипты
                     внутри рабочего чрута (MKI_IMAGE_SCRIPTDIR).
build-propagator   - Создаёт стадию propagator для инсталляционного образа.
                     Эта стадия используется для загрузки инсталлятора
                     (PROPAGATOR_MAR_MODULES, PROPAGATOR_INITFS,
                     PROPAGATOR_VERSION).
copy-isolinux      - Копирует в рабочий чрут файлы, необходимые для isolinux.
copy-pxelinux      - Копирует в рабочий чрут файлы, необходимые для pxelinux.
copy-syslinux      - Копирует в рабочий чрут файлы, необходимые для syslinux.
copy-tree          - Копирует в рабочий чрут произвольное дерево каталогов
                     (COPY_TREE).
copy-subdirs       - Копирует в рабочий чрут результаты работы нижестоящих
                     образов.
copy-packages      - Вычисляет и копирует в рабочий чрут замкнутое множество
                     пакетов (MKI_DESTDIR, IMAGE_PACKAGES, IMAGE_PACKAGES_REGEXP).
split              - Разделяет содержимое директории в рабочем чруте на
                     поддиректории по определённому критерию (MKI_DESTDIR,
                     MKI_SPLIT, MKI_SPLITTYPE).
build-image        - Устанавливает в рабочий чрут множество пакетов
                     (IMAGE_PACKAGES, IMAGE_PACKAGES_REGEXP).
pack-image         - Пакует рабочий чрут (MKI_PACK_RESULTS, BOOT_*, PACK_*).

Существуют цели для интерактивной работы:

clean-current      - Удаляет рабочий чрут в текущем образе, но не удаляет
                     результаты работы. Нижестоящие образы затронуты не будут.
distclean-current  - Полностью очищает образ от служебных файлов mkimage и
                     удаляет результаты его работы.
clean              - Эта цель эквивалентна `clean-current', но действует
                     рекурсивно.
distclean          - Эта цель эквивалентна `distclean-current', но действует
                     рекурсивно.

Например, последовательность целей:

all: build-image run-scripts pack-image

устанавливает в чрут пакеты, обрабатывает этот чрут скриптами и пакует его.

Почти все цели - "обёртка" над вызовом скриптов. Это сделано специально,
чтобы пользователь имел возможность переопределять эти скрипты, не изменяя
сами цели.

################################################################################
### Конфигурационный файл (Переменные)
################################################################################

Переменные в Makefile разделяются на три группы:

1. Переменные, локальные для данного Makefile'а. Эти переменные имеют влияние
только на сборку данного образа.

2. Глобальные переменные. Они передаются всем нижестоящим образам. Такие
переменные имеют префикс 'GLOBAL_' . Не все локальные переменные имеют
глобальный эквивалент.

3. Переменные, передаваемые скриптам, выполняемым внутри чрутов (первого или
второго). Как правило, это информационные переменные. Поэтому они имеют
префикс 'INFO_' .

Список переменных:

VERBOSE,
GLOBAL_VERBOSE         - Включает отладочную информацию локально и глобально
                         (для всех нижестоящих образов), соответственно.
TARGET,
GLOBAL_TARGET          - Переменная определяет архитектуру под которую нужно
                         собирать образ.
                         По умолчанию выставлена в `uname -m`.

HSH_APT_CONFIG,
GLOBAL_HSH_APT_CONFIG  - Позволяет переопределять конфигурационный файл apt.
                         По умолчанию берётся системный (/etc/apt/apt.conf).

HSH_APT_PREFIX,
GLOBAL_HSH_APT_PREFIX  - apt prefix.

GLOBAL_HSH_NUMBER      -

HSH_USE_QEMU,
GLOBAL_HSH_USE_QEMU    -

HSH_LANGS,
GLOBAL_HSH_LANGS       - Список языков, которые будут установлены в рабочий и
                         инструментальный чрут.

GLOBAL_WORKROOT        - Этот параметр позволяет перенести содержимое директории
                         .work из каталога с профилем.

SUBDIRS                - Переменная перечисляет имена директорий, в которых
                         содержатся нижестоящие образы.

OUTDIR                 - Переопределяет директорию, в которую сохраняется
                         результат сборки образа.
                         По умолчанию это ".work/.out" .

CLEANUP_OUTDIR         - Очищать или нет OUTDIR перед помещением туда результата.
                         По умолчанию эта переменная выставлена.

NO_CACHE               - Позволяет отключить кэширование результатов.
                         По умолчанию эта переменная не выставлена.

NO_REMOTES             - Отключает дополнительную обработку SUBDIRS для сборки
                         на удалённых серверах.
                         По умолчанию эта переменная не выставлена.

MKI_SCRIPTDIR          - Определяет название директории, содержащей скрипты для
                         исполнения в инструментальном чруте.
                         По умолчанию: $(CURDIR)/scripts.d

MKI_IMAGE_SCRIPTDIR    - Определяет название директории, содержащей скрипты для
                         исполнения в рабочем чруте.
                         По умолчанию: $(CURDIR)/image-scripts.d

CHROOT_PACKAGES        - Перечисляет имена пакетов, которые необходимо установить
                         в инструментальный чрут. Вы можете использовать не 
                         только имена пакетов, а и указать путь к файлу(ам),
                         в которых перечислены пакеты.

CHROOT_PACKAGES_REGEXP - Переменная имеет тот же смысл, что и CHROOT_PACKAGES,
                         но в её значении перечисляются не только имена пакетов,
                         а и регулярные выражения для фильтрации их списка.
                         Если выражение начинается с `!', то значение этого
                         шаблона инвертируется. Таким образом можно исключать
                         нежелательные пакеты или группы пакетов по шаблону.

IMAGE_PACKAGES         - Перечисляет имена пакетов, которые необходимо установить
                         или скопировать (в зависимости от цели) в рабочий чрут.

IMAGE_PACKAGES_REGEXP  - Переменная имеет тот же смысл, что IMAGE_PACKAGES.
                         Содержимое аналогично CHROOT_PACKAGES_REGEXP.

IMAGE_INIT_LIST        - Переменная устанавливает список пакетов в первоначальном
                         чруте. Если список начинается с '+', то перечисленные
                         пакеты будут добавлены к списку пакетов, иначе список
                         заменит список по умолчанию.
                         Значение этой переменной передаётся hasher через ключ
                         --pkg-init-list=<IMAGE_INIT_LIST> как есть.

MKI_DESTDIR            - Директория, в которую нужно скопировать пакеты,
                         перечисленные в IMAGE_PACKAGES в случае, когда их нужно
                         копировать.
                         Эта переменная используется только целью `copy-packages'.

COPY_TREE              - Определяет директории, которые нужно скопировать в
                         рабочий чрут.
                         Эта переменная используется только целью `copy-tree'.

MKI_PACKTYPE           - Определяет метод запаковки рабочего чрута.
                         Эта переменная используется только целью `pack-image'.
                         Параметр устарел. Используйте MKI_PACK_RESULTS.

MKI_OUTNAME            - Если рабочий чрут пакуется в некий образ, то эта переменная
                         определяет имя этого образа.
                         Эта переменная используется только целью `pack-image'.
                         Параметр устарел. Используйте MKI_PACK_RESULTS.

MKI_PACK_RESULTS       - Этот параметр комбинирует MKI_PACKTYPE и MKI_OUTNAME, делая
                         их устаревшими. Формат этой переменной следующий:

                         <PACKTYPE>:<OUTNAME>[:<SUBDIR>] [<PACKTYPE1>:<OUTNAME1>[:<SUBDIR1>] ...]

                         таким образом, один и тот же рабочий чрут можно запаковать
                         несколькими разными способами с разными именами.

                         Тип паковки(PACKTYPE) может быть одним из:

                         boot    - создаёт загрузочный ISO образ.
                         isoboot - аналогично `boot', но не пытается создать образ для
                                   propagator.
                         yaboot  - аналогичен `isoboot', но используется загрузчик
                                   для PowerPC.
                         isodata - создаёт ISO образ с данными.
                         squash  - создаёт образ с файловой системой squashfs.
                         data    - копирует директорию "как есть", не применяя никаких
                                   методов сжатия и упаковки.
                         tarbz2  - создаёт тарболл, сжатый bzip2. Этот метод устарел.
                                   Используйте метод `tar' + параметр MKI_TAR_COMPRESS.
                         tar     - создаёт tar-архив и в зависимости от значения
                                   переменной MKI_TAR_COMPRESS сжимает его.
                         cpio    - создаёт cpio-архив и в зависимости от значения
                                   переменной MKI_CPIO_COMPRESS сжимает его.

                         SUBDIR - поддиректория в рабочем чруте, которую нужно запаковать.

MKI_TAR_COMPRESS       - Переменная указывает метод сжатия tar-архива.
                         Доступные значения: `bzip2' и `gzip'. Если переменная пуста,
                         сжатие не производится.

MKI_CPIO_COMPRESS      - Переменная указывает метод сжатия cpio-архива.
                         Доступные значения: `bzip2' и `gzip'.

PACK_SQUASHFS_PROCESSORS - Определяет количество процессоров, задействуемых при
                           запаковке squashfs образа.  По умолчанию этот параметр
                           выставлен равным количеству доступных системе
                           процессоров (ядер).

PACK_SQUASHFS_OPTS     - С помощью этого параметра можно передавать дополнительные
                         опции программе mksquashfs при запаковке образа.

MKI_SPLIT              - Параметер позволяет разбить MKI_DESTDIR на поддиректории c
                         определённым размером. Формат переменной следующий:

                         <SIZE1>:<DESTDIR1> [<SIZE2>:<DESTDIR2> ...]

                         DESTDIR1 указывается относительно рабочего чрута.
                         SIZE1 может быть как в байтах, так и в сокращённом формате
                         (Kb, Mb, Gb или Tb). Специальное значение `*' укзывет на остаток.

MKI_SPLITTYPE          - Если вам не нравится критерий поиска или сортировки файлов
                         при выполении цели `split', можете создать свои функции
                         для выполнения этих действий. В MKI_SPLITTYPE указывается
                         имя скрипта, в котором следует переопределить функции поиска
                         и сортировки: gen_filelist(), sortfiles(outfile).
                         (Подробнее см. реализацию утилиты mki-split)

PROPAGATOR_MAR_MODULES - Список модулей, которые будут помещены в образ.
PROPAGATOR_INITFS      - Файл с описанием, какие каталоги нужно помещать в образ.
                         См. gencpio.
PROPAGATOR_VERSION     - Указывает версию продукта.

GLOBAL_BOOT_LANG,
BOOT_LANG              - Устанавливает язык, используемый по умолчанию в gfxboot.

BOOT_TYPE              - Описывает, каким образом будет загружаться образ. Доступные
                         значения: 'isolinux', 'pxelinux' и 'syslinux'. Возможно указать
                         несколько значений сразу, в этом случае на образ попадут
                         конфигурации для всех перечисленных методов.

BOOT_APPI, BOOT_COPY, BOOT_ABST, BOOT_BIBL, BOOT_PREP, BOOT_PUBL, BOOT_SYSI,
BOOT_VOLI, BOOT_VOLS
                       - Эти переменные используются при запаковке ISO-образа
                         утилитой mkisofs и соответствуют переменным, которые
                         указываются в .mkisofsrc: APPI, COPY, ABST, BIBL, PREP,
                         PUBL, SYSI, VOLI, VOLS.
                         См. mkisofs(8).

################################################################################
### Распределённая сборка
################################################################################

Вы можете собирать стадии не только на локальной, но и на удалённой машине.
Доступ до удалённой машине осуществляется по ssh. Чтобы передать сборку стадии
на другую машину, нужно указать файл конфигурации, в котором будет указаны
имя сервера и рабочий каталог на удалённой стороне. Например:

SUBDIRS = installer \
          RPMS.basesystem=$(CURDIR)/remote.conf \
          RPMS.extra

# <<< *** File remote.conf ***
### Server name
server=some.buildserver.com

### Remote workdir
workdir=/tmp/.private/user
# *** (end of remote.conf) *** >>>

В этом случае всё содержимое стадии будет скопировано на сборочный сервер. После
того как сборка на удалённом сервере завершится, результат будет скопирован
обратно на локальную машину и сборка продолжится.

Это поведение можно отключить выставив переменную NO_REMOTES. В этом случае все
SUBDIRS будут расцениваться как локальные директории.

legion 2008
