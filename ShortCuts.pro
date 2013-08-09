APP_NAME = ShortCuts

INCLUDEPATH += ../../canadainc/src/
CONFIG += qt warn_on cascades10
LIBS += -lbbsystem -lbb -lbbcascadespickers -lbbpim

CONFIG(release, debug|release) {
    DESTDIR = o.le-v7
    LIBS += -L../../canadainc/arm/o.le-v7 -lcanadainc -Bdynamic
}

CONFIG(debug, debug|release) {
    DESTDIR = o.le-v7-g
    LIBS += -L../../canadainc/arm/o.le-v7-g -lcanadainc -Bdynamic
}

include(config.pri)
