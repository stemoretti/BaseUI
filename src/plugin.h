#ifndef BASEUI_PLUGIN_H
#define BASEUI_PLUGIN_H

#include <QtQml/QQmlEngineExtensionPlugin>

class BaseUIPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
};

#endif
