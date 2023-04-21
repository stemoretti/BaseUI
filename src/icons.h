#ifndef BASEUI_ICONS_H
#define BASEUI_ICONS_H

#include <QQmlEngine>
#include <QQmlPropertyMap>

#include <memory>

namespace BaseUI
{

class Icons : public QQmlPropertyMap
{
    Q_OBJECT

public:
    Icons(QObject *parent = nullptr);

    inline static std::unique_ptr<Icons> instance;

    static void registerIcons(QQmlEngine *engine, const QString &fontPath,
                              const QString &fontName, const QVariantMap &codes);

    static void registerIcons(QQmlEngine *engine, const QString &fontPath,
                              const QString &fontName, const QString &codesPath);
protected:
    template <typename DerivedType>
    explicit Icons(DerivedType *derived, QObject *parent = nullptr)
        : QQmlPropertyMap(derived, parent)
    {}
};

struct IconsForeign
{
    Q_GADGET
    QML_FOREIGN(Icons)
    QML_SINGLETON
    QML_NAMED_ELEMENT(Icons)

public:
    static Icons *create(QQmlEngine *, QJSEngine *engine)
    {
        // The instance has to exist before it is used. We cannot replace it.
        Q_ASSERT(Icons::instance);

        // The engine has to have the same thread affinity as the singleton.
        Q_ASSERT(engine->thread() == Icons::instance->thread());

        // There can only be one engine accessing the singleton.
        if (s_engine)
            Q_ASSERT(engine == s_engine);
        else
            s_engine = engine;

        return Icons::instance.get();
    }

private:
    inline static QJSEngine *s_engine = nullptr;
};

}

#endif
