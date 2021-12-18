#include "icons.h"

#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QVariant>
#include <QQmlEngine>
#include <QFontDatabase>
#include <QColor>

#include "iconprovider.h"

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

void Icons::registerIcons(QQmlEngine *engine, const QString &path)
{
    QString iconProviderName = "baseui_icons";

    if (QFontDatabase::addApplicationFont(path + "MaterialIcons-Regular.ttf") == -1)
        qWarning() << "Failed to load font Material";

    auto iconProvider = new IconProvider("Material Icons", path + "codepoints.json");

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
