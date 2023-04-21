#ifndef ICONPROVIDER_H
#define ICONPROVIDER_H

#include <QQuickImageProvider>
#include <QFont>
#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QPainter>
#include <QFontMetrics>
#include <QVariantMap>

class IconProvider : public QQuickImageProvider
{
public:
    IconProvider(const QString &family, const QVariantMap &codes)
        : QQuickImageProvider(QQuickImageProvider::Image)
        , codepoints(codes)
        , font(family)
    {
    }

    IconProvider(const QString &family, const QString &codesPath)
        : QQuickImageProvider(QQuickImageProvider::Image)
        , font(family)
    {
        QFile file(codesPath);
        if (file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QJsonDocument jd = QJsonDocument::fromJson(file.readAll());
            if (jd.isNull())
                qWarning() << "Invalid codepoints JSON file" << codesPath;
            else
                codepoints = jd.object().toVariantMap();
        } else {
            qWarning() << "Cannot open icon codes file" << codesPath;
            qWarning() << file.errorString();
        }
    }

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override
    {
        int width = 48;
        int height = 48;

        if (requestedSize.width() > 0)
            width = requestedSize.width();

        if (requestedSize.height() > 0)
            height = requestedSize.height();

        if (size)
            *size = QSize(width, height);

        QString iconChar("?");
        if (id.isEmpty())
            qWarning() << "Icon name empty";
        else if (codepoints.value(id).isNull())
            qWarning() << "Icon name" << id << "not found in" << font.family();
        else
            iconChar = codepoints[id].toString();

        font.setPixelSize(width < height ? width : height);

        QFontMetrics fm(font);
        double widthRatio = double(width) / fm.boundingRect(iconChar).width();
        if (widthRatio < 1.0)
            font.setPixelSize(font.pixelSize() * widthRatio);

        QImage image(width, height, QImage::Format_RGBA8888);
        image.fill(Qt::transparent);

        QPainter painter(&image);
        painter.setFont(font);
        painter.drawText(QRect(0, 0, width, height), Qt::AlignCenter, iconChar);

        return image;
    }

    QStringList keys() { return codepoints.keys(); }

private:
    QVariantMap codepoints;
    QFont font;
};

#endif // ICONPROVIDER_H
