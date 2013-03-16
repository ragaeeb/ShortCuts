#include "ShortCuts.hpp"
#include "Logger.h"

#include <bb/PpsObject>

#include <bb/system/InvokeManager>
#include <bb/system/SystemToast>

#include <bb/cascades/Pickers/ContactPicker.hpp>

#include <bb/cascades/AbstractDialog>
#include <bb/cascades/Application>
#include <bb/cascades/Control>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/SceneCover>

#include <bb/system/InvokeTargetReply>

using namespace bb::cascades;
using namespace bb::cascades::pickers;
using namespace bb::system;
using namespace bb::pim::contacts;
using namespace bb;

namespace {

const char* DELIMITER = ", ";

}

namespace shortcuts {

ShortCuts::ShortCuts(bb::cascades::Application* app) :
		QObject(app), m_changed(false), m_toast(NULL)
{
	if ( getValueFor("animations").isNull() ) { // first run
		LOGGER("First run!");
		saveValueFor("animations", 0);
		saveValueFor("delay", 1000);
	}

	QmlDocument* qmlCover = QmlDocument::create("asset:///Cover.qml").parent(this);
	Control* sceneRoot = qmlCover->createRootObject<Control>();
	SceneCover* cover = SceneCover::create().content(sceneRoot);
	app->setCover(cover);

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);

    m_root = qml->createRootObject<NavigationPane>();
    app->setScene(m_root);

    qml->setContextProperty("navPane", m_root);

    connect( app, SIGNAL( aboutToQuit() ), this, SLOT( onAboutToQuit() ) );

    if ( !getValueFor("map").isNull() ) {
    	LOGGER("Mappings exist!");
    	m_map = getValueFor("map").value< QHash<QString, QVariant> >();
    	LOGGER( "Map size" << m_map.size() );
    }
}


void ShortCuts::onAboutToQuit()
{
	LOGGER("onAboutToQuit");

	if (m_changed)
	{
		LOGGER("saving changed values" << m_map);

		if ( m_map.isEmpty() ) {
			m_settings.remove("map");
		} else {
			saveValueFor("map", m_map);
		}
	}
}


QVariant ShortCuts::getValueFor(const QString &objectName)
{
    QVariant value( m_settings.value(objectName) );

	LOGGER("getValueFor()" << objectName << value);

    return value;
}


void ShortCuts::saveValueFor(const QString &objectName, const QVariant &inputValue)
{
	LOGGER("saveValueFor()" << objectName << inputValue);
	m_settings.setValue(objectName, inputValue);
}


bool ShortCuts::process(QStringList const& sequence)
{
	QString text( render(sequence) );

	bool exists = m_map.contains(text);

	LOGGER("process()" << exists << sequence << text);

	if (exists)
	{
		QVariantMap qvm = m_map.value(text).value<QVariantMap>();
		LOGGER("Matched map" << qvm);

		InvokeRequest request;
		request.setAction( qvm.value("action").toString() );

		if ( qvm.contains("target") ) {
			request.setTarget( qvm.value("target").toString() );
		}

		if ( qvm.contains("uri") ) {
			request.setUri( QUrl( qvm.value("uri").toString() ) );
		}

		if ( qvm.contains("mime") ) {
			request.setMimeType( qvm.value("mime").toString() );
		}

		if ( qvm.contains("data") ) {
			request.setData( qvm.value("data").toByteArray() );
		}

		LOGGER( "Invoking()" << request.action() << request.target() << request.uri() << request.mimeType() << request.data() );

		InvokeManager invokeManager;
		invokeManager.invoke(request);
	}

	return exists;
}


QVariantList ShortCuts::getAllShortcuts() const {
	return m_map.values();
}


void ShortCuts::registerFile(QString const& sequence, QString const& uri)
{
	LOGGER("registerFile()" << sequence << uri);

	int periodIndex = uri.lastIndexOf(".");

	if (periodIndex != -1)
	{
		QString extension = uri.mid(periodIndex);

		QVariantMap request;
		request.insert("uri", "file://"+uri);
		request.insert("type", "file");
		request.insert("sequence", sequence);

		QString target;
		QString action;

		if (extension == "mp3" || extension == "wav" || extension == "m3u" || extension == "m4a" || extension == "ogg" || extension == "mp3" || extension == "amr" || extension == "aac" || extension == "flac" || extension == "mid" || extension == "wma" || extension == "3gp" || extension == "3g2" || extension == "asf" || extension == "avi" || extension == "f4v" || extension == "mov" || extension == "mp4" || extension == "wmv" || extension == "mkv") {
			target = "sys.mediaplayer.previewer";
			action = "bb.action.OPEN";
		} else if (extension == "ppt" || extension == "pot" || extension == "pps" || extension == "pptx" || extension == "potx" || extension == "ppsx" || extension == "pptm" || extension == "potm" || extension == "ppsm") {
			request.insert("mime", "application/vnd.ms-powerpoint");
			target = "sys.slideshowtogo.previewer";
			action = "bb.action.VIEW";
		} else if (extension == "xls" || extension == "xlt" || extension == "xlsx" || extension == "xltx" || extension == "xlsm" || extension == "xltm") {
			request.insert("mime", "application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.openxmlformats-officedocument.spreadsheetml.template, application/vnd.ms-excel.sheet.macroEnabled.12, application/vnd.ms-excel.template.macroEnabled.12");
			target = "sys.sheettogo.previewer";
			action = "bb.action.VIEW";
		} else if (extension == "doc" || extension == "dot" || extension == "txt" || extension == "docx" || extension == "dotx" || extension == "docm" || extension == "dotm") {
			request.insert("mime", "application/msword");
			target = "sys.wordtogo.previewer";
			action = "bb.action.VIEW";
		}

		request.insert("action", action);
		request.insert("target", target);

		m_map.insert(sequence, request);

		showRecordedGesture(sequence, uri);
	}
}


void ShortCuts::registerUri(QString const& sequence, QString const& uri)
{
	LOGGER("registerUri()" << sequence << uri);

	QVariantMap request;
	request.insert("target", "sys.browser");
	request.insert("action", "bb.action.OPEN");
	request.insert("uri", uri);
	request.insert("type", "uri");
	request.insert("sequence", sequence);

	m_map.insert(sequence, request);

	showRecordedGesture(sequence, uri);
}


void ShortCuts::registerPhone(QString const& sequence, QString const& number)
{
	LOGGER("registerPhone()" << sequence << number);

	QVariantMap map;
	map.insert("number", number);
	QByteArray requestData = PpsObject::encode(map, NULL);

	QVariantMap request;
	request.insert("action", "bb.action.DIAL");
	request.insert("mime", "application/vnd.blackberry.phone.startcall");
	request.insert("data", requestData);
	request.insert("type", "phone");
	request.insert("number", number);
	request.insert("sequence", sequence);

	m_map.insert(sequence, request);

	showRecordedGesture(sequence, number);
}


void ShortCuts::registerApp(QString const& sequence, QString const& target, QString const& uri, QString const& mime)
{
	LOGGER("registerApp()" << sequence << target << uri << mime);

	QVariantMap request;
	request.insert("action", "bb.action.OPEN");
	request.insert("mime", mime);
	request.insert("type", "app");
	request.insert("target", target);
	request.insert("uri", uri);
	request.insert("sequence", sequence);

	m_map.insert(sequence, request);

	showRecordedGesture(sequence, uri);
}


bool ShortCuts::removeShortcut(QString const& sequence)
{
	bool removed = m_map.remove(sequence) > 0;
	LOGGER("removeShortcut()" << sequence << removed);

	if (removed) {
		m_changed = true;
		displayToast( tr("Successfully removed shortcut:\n%1").arg(sequence) );
	}

	return removed;
}


void ShortCuts::showRecordedGesture(QString const& sequence, QString const& message)
{
	m_changed = true;

	displayToast( tr("Successfully registered gesture:\n%1\nto %2").arg(sequence).arg(message) );

	m_root->pop();
	m_root->pop();
}


void ShortCuts::displayToast(QString const& text)
{
	if (m_toast == NULL) {
		LOGGER("Instantiating new system toast");
		m_toast = new SystemToast(this);
	}

	m_toast->setBody(text);
	m_toast->show();
}


void ShortCuts::clearAllShortcuts()
{
	LOGGER("clearAllShortcuts()");

	m_map.clear();
	m_changed = true;

	displayToast("Cleared all records!");
}


QString ShortCuts::render(QStringList const& sequence)
{
	QString text;

    for (int i = 0; i < sequence.size(); i++) {
        text += sequence[i];

        if (i < sequence.size()-1) {
            text += DELIMITER;
        }
    }

    return text;
}


ShortCuts::~ShortCuts()
{
}

}
