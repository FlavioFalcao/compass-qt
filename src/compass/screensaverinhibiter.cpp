/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QtCore>
#include "screensaverinhibiter.h"

ScreenSaverInhibiter::ScreenSaverInhibiter(QObject *parent) :
    QObject(parent),
    m_ScreenSaver(NULL)
{
}

void ScreenSaverInhibiter::screenSaverInhibit(const QVariant &inhibit)
{
    if (inhibit.toBool()) {
        if (m_ScreenSaver == NULL) {
            m_ScreenSaver = new QSystemScreenSaver;
        }

        m_ScreenSaver->setScreenSaverInhibit();
    }
    else {
        if (m_ScreenSaver != NULL) {
            delete m_ScreenSaver;
            m_ScreenSaver = NULL;
        }
    }
}
