#ifndef ICONS_H
#define ICONS_H

#include <QQmlPropertyMap>

class QQmlEngine;
class QJSEngine;

class Icons : public QQmlPropertyMap
{
    Q_OBJECT

public:
    Icons(QObject *parent = nullptr);

    static Icons *instance();
    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    static void registerIcons(QQmlEngine *engine, const QString &path);

protected:
    template <typename DerivedType>
    explicit Icons(DerivedType *derived, QObject *parent = nullptr)
        : QQmlPropertyMap(derived, parent)
    {}
};

#endif
