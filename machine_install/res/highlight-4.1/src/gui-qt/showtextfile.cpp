
/***************************************************************************
                               showtestfile.cpp
                             -------------------
    begin                : Mo 16.03.2009
    copyright            : (C) 2009-2021 by Andre Simon
    email                : a.simon@mailbox.org
 ***************************************************************************/

/*
This file is part of Highlight.

Highlight is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Highlight is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Highlight.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "showtextfile.h"
#include "ui_showtextfile.h"
#include <QTextStream>
#include <QFile>
#include <QDir>

ShowTextFile::ShowTextFile(QWidget *parent) :
    QDialog(parent),
    m_ui(new Ui::ShowTextFile)
{
    m_ui->setupUi(this);
}

ShowTextFile::~ShowTextFile()
{
    delete m_ui;
}

void ShowTextFile::changeEvent(QEvent *e)
{
    switch (e->type()) {
    case QEvent::LanguageChange:
        m_ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

bool ShowTextFile::setFileName(const QString& fileName)
{
#ifdef Q_OS_OSX
    QFile file( QString("%1/../Resources/%2").arg(QCoreApplication::applicationDirPath()).arg( fileName ));
#else
    #ifndef DOC_DIR
    QFile file( QString("%1/%2").arg(QDir::currentPath()).arg( fileName ));
    #else
    QFile file( QString("%1/%2").arg(DOC_DIR).arg(fileName ));
    #endif
#endif
    if ( file.open( QIODevice::ReadOnly) ) {
        QTextStream stream( &file );
        //m_ui->textBrowser->setText( stream.readAll() );

        QString line;
        do {
            line = stream.readLine();
            if (! (line.startsWith(":") || line.startsWith("//")) )
                m_ui->textBrowser->append( line );
        } while (!line.isNull());

        m_ui->lbTitle->setText(fileName);
        m_ui->textBrowser->moveCursor(QTextCursor::Start);
    }
    return file.exists();
}

void ShowTextFile::setText(const QString& content, const QString& title)
{
   m_ui->textBrowser->setText( content );
   m_ui->lbTitle->setText(title);
}


void ShowTextFile::on_pushButton_clicked()
{
    this->close();
}
