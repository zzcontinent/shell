/***************************************************************************
                               mainwindow.h
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

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtGlobal>

#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
#include <QtGui/QMainWindow>
#include <QtGui/QMessageBox>
#include <QtGui/QFileDialog>
#include <QtGui/QListWidget>
#include <QLineEdit>
#include <QScrollBar>
#include <QDropEvent>
#else
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMessageBox>
#include <QtWidgets/QFileDialog>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QScrollBar>
#include <QDropEvent>
#endif
#include <QSettings>
#include <QDir>
#include <QClipboard>
#include <QMimeData>
#include <QElapsedTimer>
#include <QShortcut>
#include <QString>
#include <QList>
#include <QTextStream>
#include <QFileSystemWatcher>
#include <QDesktopServices>
#include <QStyleFactory>

#include "version.h"
#include "codegenerator.h"
#include "htmlgenerator.h"
#include "lspprofile.h"
#include "lspclient.h"

#include <map>
#include <vector>
#include "enums.h"

typedef multimap<string, string> MMap;
typedef map<string, string> SMap;

namespace Ui
{
    class MainWindowClass;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void addToView(const QStringList& list, QListWidget* listWidget, const QString &iconName=":/file.png", bool checkable=false, bool baseName = false);
private:
    Ui::MainWindowClass *ui;
    MMap assocByExtension, assocByFilename;
    SMap assocByShebang, rememberedAssoc, encodingHints;
    std::map<std::string, highlight::LSPProfile> lspProfiles;


    QString fileOpenFilter;
    QString savedClipboardContent;
    QString twoPassOutFile;

    std::string lsProfile;
    std::string lsExecutable;               ///< server executable path
    std::string lsSyntax;                   ///< language definition which can be enhanced using the LS
    int lsDelay;
    std::vector<std::string> lsOptions; ///< server executable start options

    QShortcut *copyShortcut;
    QShortcut *pasteShortcut;
    QFileSystemWatcher scriptWatcher;
    QStringList themesClassic;
    QStringList themesBase16;
    QList< QList<QString> > themesList;

    int oldThemeIndex;

    bool getDataFromCP, runFirstTime;

    void readSettings();
    void writeSettings();
    highlight::OutputType getOutputType();
    highlight::WrapMode getWrappingStyle();
    QString getOutFileSuffix();
    QString getUserScriptPath(QString type);

    QString getDistThemePath();
    QString getDistLangPath(const string & suffix);
    QString getDistPluginPath();
    QString getDistFileConfigPath(QString name);
    QString getDistFileFilterPath();

    QString getWindowsShortPath(const QString & path);

    void applyCtrlValues(highlight::CodeGenerator* generator, bool previewMode);
    void applyEncoding(highlight::CodeGenerator* generator, QString &langDefPath);

    void selectSingleFile(QLineEdit*, const QString&, const QString&);
    bool loadFileTypeConfig();
    bool loadLSProfiles();

    bool initializeLS(highlight::CodeGenerator * generator, bool tellMe);

    bool shortNamesDisabled();

    void highlight2Clipboard(bool getDataFromCP);

    string analyzeFile(const string& file);
    string getFileType(const string& suffix, const string &inputFile);
    string getFileSuffix(const string& fileName);
    string getFileBaseName(const string& fileName);
    void readLuaList(const string& paramName, const string& langName, Diluculum::LuaValue &luaVal, MMap* extMap);
    void fillThemeCombo(int);
    void showHelpFile(const QString& file);

    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dragLeaveEvent(QDragLeaveEvent *event);
    void dropEvent(QDropEvent *event);

public slots:
    //This is a slot like the ones we used in our last tutorial
    // The difference here that it gets automatically connect
    // If you use on_objectname_signalname it's like connect(pushButton,SIGNAL(clicked()),this,SLOT(on_pushButton_clicked()))

    void on_pbClearSelection_clicked();
    void on_pbOutputDest_clicked();
    void on_pbStartConversion_clicked();
    void on_pbCopyFile2CP_clicked();

private slots:

    void on_actionVisit_website_triggered();
    void on_pbClearAllPlugins_clicked();
    void on_pbClearAll_clicked();
    void on_pbClearSelPlugin_clicked();
    void on_pbSelectPlugin_clicked();
    void on_pbSelectScript_clicked();
    void on_pbClearAllScripts_clicked();
    void on_pbClearSelScript_clicked();

    void on_pbCopyToCP_clicked();
    void on_pbPasteFromCB_clicked();
    void on_actionAbout_translations_triggered();
    void on_pbTEXChooseStyleIncFile_clicked();
    void on_pbLATEXChooseStyleIncFile_clicked();
    void on_pbHTMLChooseStyleIncFile_clicked();
    void on_pbSVGChooseStyleIncFile_clicked();
    void on_pbCopyAndPaste_clicked();

    void on_pbLSInitialize_clicked();
    void on_leLSExec_textChanged();
    void on_pbSelWorkspace_clicked();
    void on_pbSelExecutable_clicked();

    void on_action_License_triggered();
    void on_action_Changelog_triggered();
    void on_action_Plug_Ins_triggered();

    void on_action_Manual_triggered();
    void on_action_About_Highlight_triggered();
    void on_action_Exit_triggered();

    void plausibility();
    void updatePreview();
    void openFiles();
    void loadLSProfile();

    void on_actionDock_floating_panels_toggled(bool arg1);
    void on_pbPluginReadFilePath_clicked();

    void on_pbBrowseOutDir_clicked();
    void on_lvUserScripts_itemClicked(QListWidgetItem *item);
    void on_lvPluginScripts_itemClicked(QListWidgetItem *item);

    void on_browserPreview_selectionChanged();
    void on_comboThemeFilter_currentIndexChanged(int index);
};

#endif // MAINWINDOW_H
