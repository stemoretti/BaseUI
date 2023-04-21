#include "icons.h"

#include <QDebug>
#include <QFontDatabase>
#include <QVariantHash>

#include "iconprovider.h"

namespace BaseUI
{

Icons::Icons(QObject *parent)
    : QQmlPropertyMap(this, parent)
{
    QJSEngine::setObjectOwnership(this, QJSEngine::CppOwnership);
}

void Icons::registerIcons(QQmlEngine *engine, const QString &fontPath,
                          const QString &fontName, const QVariantMap &codes)
{
    QString iconProviderName = "baseui_icons";

    if (QFontDatabase::addApplicationFont(fontPath) == -1)
        qWarning() << "Failed to load font:" << fontPath;

    auto iconProvider = new IconProvider(fontName, codes);
    engine->addImageProvider(iconProviderName, iconProvider);

    QVariantHash hash;
    for (const QString &key : iconProvider->keys())
        hash.insert(key, QVariant("image://" + iconProviderName + "/" + key));
    instance->insert(hash);
}

void Icons::registerIcons(QQmlEngine *engine, const QString &fontPath,
                          const QString &fontName, const QString &codesPath)
{
    QString iconProviderName = "baseui_icons";

    if (QFontDatabase::addApplicationFont(fontPath) == -1)
        qWarning() << "Failed to load font:" << fontPath;

    auto iconProvider = new IconProvider(fontName, codesPath);
    engine->addImageProvider(iconProviderName, iconProvider);

    QVariantHash hash;
    for (const QString &key : iconProvider->keys())
        hash.insert(key, QVariant("image://" + iconProviderName + "/" + key));
    instance->insert(hash);
}

}
