#include <BaseUI/icons.h>

#include <QDebug>
#include <QVariantHash>
#include <QQmlEngine>
#include <QFontDatabase>

#include "iconprovider.h"

namespace BaseUI
{

Icons::Icons(QObject *parent)
    : QQmlPropertyMap(this, parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
}

Icons *Icons::instance()
{
    static Icons instance_;

    return &instance_;
}

QObject *Icons::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)

    return instance();
}

void Icons::registerIcons(QQmlEngine *engine, const QString &fontPath,
                          const QString &fontName, const QString &codesPath)
{
    static int index = 0;
    QString iconProviderName = "baseui_icons" + QString::number(index++);

    if (QFontDatabase::addApplicationFont(fontPath) == -1)
        qWarning() << "Failed to load font:" << fontPath;

    auto iconProvider = new IconProvider(fontName, codesPath);

    engine->addImageProvider(iconProviderName, iconProvider);

#if (QT_VERSION < QT_VERSION_CHECK(6, 1, 0))
    for (const QString &key : iconProvider->keys())
        instance()->insert(key, QVariant("image://" + iconProviderName + "/" + key + ","));
#else
    QVariantHash hash;
    for (const QString &key : iconProvider->keys())
        hash.insert(key, QVariant("image://" + iconProviderName + "/" + key + ","));
    instance()->insert(hash);
#endif
}

}
