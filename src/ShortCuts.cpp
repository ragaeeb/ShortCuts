#include "precompiled.h"

#include "ShortCuts.hpp"
#include "Logger.h"
#include "PimContactPickerSheet.h"

#include <bps/navigator.h>

namespace {
	const char* DELIMITER = ", ";
}

namespace shortcuts {

using namespace canadainc;
using namespace bb::cascades;
using namespace bb::system;

ShortCuts::ShortCuts(bb::cascades::Application* app) : QObject(app), m_cover("Cover.qml"), m_changed(false)
{
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("persist", &m_persistance);

    m_root = qml->createRootObject<NavigationPane>();
    app->setScene(m_root);

    qml->setContextProperty("navPane", m_root);

	connect( this, SIGNAL( initialize() ), this, SLOT( init() ), Qt::QueuedConnection ); // async startup

	emit initialize();
}


void ShortCuts::init()
{
	INIT_SETTING("delay", 1000);

	m_cover.setContext("app", this);

    qmlRegisterType<PimContactPickerSheet>("com.canadainc.data", 1, 0, "PimContactPickerSheet");
	qmlRegisterType<bb::cascades::pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("bb.cascades.pickers", 1, 0, "FilePickerMode", "Can't instantiate");

    QVariant saved = m_persistance.getValueFor("map");

    if ( !saved.isNull() ) {
    	LOGGER("Mappings exist!");
    	m_map = saved.value< QHash<QString, QVariant> >();
    	LOGGER( "Map size" << m_map.size() );
    	emit numShortcutsChanged();
    }
}


void ShortCuts::create(bb::cascades::Application* app) {
	new ShortCuts(app);
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


void ShortCuts::focus() {
	navigator_invoke("shortcuts://", 0);
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

		m_changed = true;
		emit numShortcutsChanged();
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

	m_changed = true;
	emit numShortcutsChanged();
}


void ShortCuts::registerPhone(QString const& sequence, QString const& number)
{
	LOGGER("registerPhone()" << sequence << number);

	QVariantMap map;
	map.insert("number", number);
	QByteArray requestData = bb::PpsObject::encode(map, NULL);

	QVariantMap request;
	request.insert("action", "bb.action.DIAL");
	request.insert("mime", "application/vnd.blackberry.phone.startcall");
	request.insert("data", requestData);
	request.insert("type", "phone");
	request.insert("number", number);
	request.insert("sequence", sequence);

	m_map.insert(sequence, request);

	showRecordedGesture(sequence, number);

	m_changed = true;
	emit numShortcutsChanged();
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

	m_changed = true;
	emit numShortcutsChanged();
}


bool ShortCuts::removeShortcut(QString const& sequence)
{
	bool removed = m_map.remove(sequence) > 0;
	LOGGER("removeShortcut()" << sequence << removed);

	if (removed) {
		m_changed = true;
		m_persistance.showToast( tr("Successfully removed shortcut:\n%1").arg(sequence) );
		emit numShortcutsChanged();
	}

	return removed;
}


void ShortCuts::showRecordedGesture(QString const& sequence, QString const& message)
{
	m_changed = true;

	m_persistance.showToast( tr("Successfully registered gesture:\n%1\nto %2").arg(sequence).arg(message) );

	m_root->pop();
	m_root->pop();
}


void ShortCuts::clearAllShortcuts()
{
	LOGGER("clearAllShortcuts()");

	m_map.clear();
	m_changed = true;

	emit numShortcutsChanged();

	m_persistance.showToast("Cleared all records!");
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


int ShortCuts::numShortcuts() const {
	return m_map.size();
}


ShortCuts::~ShortCuts()
{
	if (m_changed)
	{
		LOGGER("saving changed values" << m_map);

		if ( m_map.isEmpty() ) {
			m_persistance.remove("map");
		} else {
			m_persistance.saveValueFor("map", m_map);
		}
	}
}

}
