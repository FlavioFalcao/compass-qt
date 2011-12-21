#ifndef PERSISTENTSTORAGE_H
#define PERSISTENTSTORAGE_H

#include <QObject>
#include <qdeclarative.h>
#include <QDomElement>
#include <QGeoCoordinate>

QTM_USE_NAMESPACE

class QDomDocument;
class QSettings;

class PersistentStorage : public QObject
{
    Q_OBJECT
public:
    explicit PersistentStorage(QObject *parent = 0);
    virtual ~PersistentStorage();

    Q_INVOKABLE void saveSetting(const QVariant &key, const QVariant &value);
    Q_INVOKABLE QVariant loadSetting(const QVariant &key,
                                     const QVariant &defaultValue);

    Q_INVOKABLE void addRouteCoordinate(const QVariant &varLongitude,
                                        const QVariant &varLatitude,
                                        const QVariant &varAltitude);
    Q_INVOKABLE void clearRoute();
    Q_INVOKABLE void loadRoute(const QVariant &varMapPolyLine);
    Q_INVOKABLE void createWaypoint(const QVariant &name,
                                    const QVariant &timestamp);
    
protected:
    QSettings *m_Settings;

    QDomDocument *m_DomDocument;
    QDomElement m_Document;
    QDomElement m_Coordinates;

    static const QString m_KmlFilePath;

    void createDocument();
    bool loadDocument();
};

QML_DECLARE_TYPE(PersistentStorage)

#endif // PERSISTENTSTORAGE_H
