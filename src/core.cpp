#include <BaseUI/core.h>

#include <QQmlEngine>
#include <QQuickStyle>

#include "icons.h"

namespace BaseUI
{

void init(QQmlEngine *engine)
{
    QQuickStyle::setStyle("Material");
    Icons::instance = new Icons(static_cast<QObject *>(engine));
#ifdef BASEUI_INCLUDE_ICONS
    QString path = ":/baseui/imports/BaseUI/icons/";
    BaseUI::Icons::registerIcons(engine, path + "MaterialIcons-Regular.ttf",
                                 "Material Icons", path + "codepoints.json");
#endif
    engine->addImportPath(":/baseui/imports");
}

}
