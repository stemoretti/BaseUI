#include <BaseUI/core.h>

#include <QQmlEngine>
#include <QQuickStyle>

#if defined(BASEUI_INCLUDE_ICONS) && !defined(BASEUI_EMBED_ICONS)
#include <QCoreApplication>
#endif

#include <BaseUI/icons.h>

static void initialize(QQmlEngine *engine)
{
#ifdef BASEUI_EMBED_QML
    Q_INIT_RESOURCE(baseui_qml);
    engine->addImportPath(":/imports");
#endif

#ifdef BASEUI_INCLUDE_ICONS
    QString path = "/BaseUI/icons/";

#ifdef BASEUI_EMBED_ICONS
    Q_INIT_RESOURCE(baseui_icons);
    path = ":/imports" + path;
#else
    path = QCoreApplication::applicationDirPath() + path;
#endif

    BaseUI::Icons::registerIcons(engine, path + "MaterialIcons-Regular.ttf",
                                 "Material Icons", path + "codepoints.json");
#endif
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
