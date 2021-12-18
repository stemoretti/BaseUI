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

class IconProvider : public QQuickImageProvider
{
public:
    explicit IconProvider(const QString &family, const QString &codesPath)
        : QQuickImageProvider(QQuickImageProvider::Image)
        , font(family)
    {
        QFile file(codesPath);
        if (file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            auto jd = QJsonDocument::fromJson(file.readAll());
            if (!jd.isNull())
                codepoints = jd.object();
            else
                qWarning() << "Invalid codepoints JSON file" << codesPath;
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

#if (QT_VERSION < QT_VERSION_CHECK(5, 14, 0))
        QStringList args = id.split(",", QString::SkipEmptyParts);
#else
        QStringList args = id.split(",", Qt::SkipEmptyParts);
#endif

        QString iconChar("?");
        if (!args.isEmpty()) {
            QString name = args.takeFirst();
            if (codepoints.value(name).isUndefined())
                qWarning() << "Icon name" << name << "not found in" << font.family();
            else
                iconChar = codepoints[name].toString();
        } else {
            qWarning() << "Icon name empty";
        }

        font.setPixelSize(width < height ? width : height);

        QFontMetrics fm(font);
        double widthRatio = double(width) / fm.boundingRect(iconChar).width();
        if (widthRatio < 1.0)
            font.setPixelSize(font.pixelSize() * widthRatio);

        QImage image(width, height, QImage::Format_RGBA8888);
        image.fill(Qt::transparent);

        QPainter painter(&image);

        for (const QString &arg : args) {
#if (QT_VERSION < QT_VERSION_CHECK(5, 14, 0))
            QStringList attr = arg.split("=", QString::SkipEmptyParts);
#else
            QStringList attr = arg.split("=", Qt::SkipEmptyParts);
#endif
            if (attr.isEmpty() || attr.size() > 2) {
                qWarning() << "Argument" << arg << "not valid.";
            } else if (attr[0] == "color") {
                if (attr.size() == 2)
                    painter.setPen(attr[1]);
                else
                    qWarning() << "Attribute color needs a value";
            } else if (attr[0] == "hflip") {
                painter.setTransform(QTransform(-1, 0, 0, 0, 1, 0, width, 0, 1));
            } else if (attr[0] == "vflip") {
                painter.setTransform(QTransform(1, 0, 0, 0, -1, 0, 0, height, 1));
            } else {
                qWarning() << "Unknown attribute" << attr;
            }
        }

        painter.setFont(font);
        painter.drawText(QRect(0, 0, width, height), Qt::AlignCenter, iconChar);

        return image;
    }

    QStringList keys() { return codepoints.keys(); }

private:
    QJsonObject codepoints;
    QFont font;
};

#endif // ICONPROVIDER_H
