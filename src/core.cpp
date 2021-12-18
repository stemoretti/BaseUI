#include <BaseUI/core.h>

#include <QCoreApplication>
#include <QQmlEngine>
#include <QQuickStyle>
#include <QDebug>

#include "icons.h"

static void initialize(QQmlEngine *engine)
{
#ifdef BASEUI_EMBED_QML
    Q_INIT_RESOURCE(baseui_qml);
    engine->addImportPath(":/imports");
#endif

    QString path = "/BaseUI/icons/";

#ifdef BASEUI_EMBED_ICONS
    Q_INIT_RESOURCE(baseui_icons);
    path = ":/imports" + path;
#else
    path = QCoreApplication::applicationDirPath() + path;
#endif

    Icons::registerIcons(engine, path);
}

namespace BaseUI
{

void init(QQmlEngine *engine)
{
    QQuickStyle::setStyle("Material");

    initialize(engine);

    qmlRegisterSingletonType<Icons>("BaseUI", 1, 0, "Icons", Icons::singletonProvider);
}

}
