#ifndef SERIALIZER_H
#define SERIALIZER_H

#include <QObject>
#include <QJsonObject>

class Serializer : public QObject
{
    Q_OBJECT
public:
    explicit Serializer(QObject *parent = 0);
    ~Serializer();

    Q_INVOKABLE void setState(QJsonObject state);
    Q_INVOKABLE QJsonObject getState();

signals:
public slots:
private:
    bool readState();
    bool writeState() const;
    QString getPath() const;
    void ensureDir() const;

    QJsonObject m_state;
};

#endif // SERIALIZER_H
