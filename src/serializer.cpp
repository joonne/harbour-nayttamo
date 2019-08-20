#include "serializer.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

Serializer::Serializer(QObject *parent) : QObject(parent)
{
    this->ensureDir();
    this->readState();
}

Serializer::~Serializer()
{
    this->writeState();
}

QJsonObject Serializer::getInitialState() const
{
    return QJsonObject
    {
        {"startedPrograms", QJsonObject()}
    };
}

bool Serializer::readState()
{
    QFile file(this->getPath());

    if (!file.open(QIODevice::ReadWrite))
    {
        return false;
    }

    auto json = (QJsonDocument::fromJson(file.readAll())).object();

    this->m_state = json.empty() ? this->getInitialState() : json;

    return true;
}

bool Serializer::writeState() const
{
    QFile file(this->getPath());

    if (!file.open(QIODevice::ReadWrite))
    {
        return false;
    }

    QJsonDocument saveDoc(m_state);
    file.write(saveDoc.toJson());

    return true;
}

void Serializer::setState(QJsonObject state)
{
    m_state = state;
}

QJsonObject Serializer::getState()
{
    return m_state;
}

void Serializer::ensureDir() const
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if (!dir.exists())
    {
        dir.mkpath(".");
    }
}

QString Serializer::getPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + "state.json";
}
