#include "precompiled.h"

#include "ShortCuts.hpp"
#include "Logger.h"
#include "InvocationUtils.h"
#include "PimContactPickerSheet.h"
#include "PimUtil.h"

namespace shortcuts {

using namespace canadainc;
using namespace bb::cascades;
using namespace bb::system;

ShortCuts::ShortCuts(Application* app) : QObject(app), m_cover("Cover.qml")
{
	INIT_SETTING("tutorialCount", 0);

	QString database = QString("%1/database.db").arg( QDir::homePath() );
	m_sql.setSource(database);

	if ( !QFile(database).exists() ) {
		QStringList qsl;
		qsl << "CREATE TABLE gestures (sequence TEXT PRIMARY KEY, type TEXT, uri TEXT, metadata TEXT)";
		m_sql.initSetup(qsl, 99);
	}

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("persist", &m_persistance);
    qml->setContextProperty("sql", &m_sql);

    AbstractPane* root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

	connect( this, SIGNAL( initialize() ), this, SLOT( init() ), Qt::QueuedConnection ); // async startup

	emit initialize();
}


void ShortCuts::init()
{
	INIT_SETTING("delay", 1000);

	m_cover.setContext("sql", &m_sql);

    qmlRegisterType<PimContactPickerSheet>("com.canadainc.data", 1, 0, "PimContactPickerSheet");
	qmlRegisterType<bb::cascades::pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("bb.cascades.pickers", 1, 0, "FilePickerMode", "Can't instantiate");
	qmlRegisterType<canadainc::InvocationUtils>("com.canadainc.data", 1, 0, "InvocationUtils");

	connect( &m_sql, SIGNAL( dataLoaded(int, QVariant const&) ), this, SLOT( dataLoaded(int, QVariant const&) ) );

	portDeprecatedMapping();
}


void ShortCuts::dataLoaded(int id, QVariant const& data)
{
	if (id == 85)
	{
		QVariantList qvl = data.toList();

		if ( !qvl.isEmpty() )
		{
			QVariantMap map = qvl.first().toMap();
			QString type = map.value("type").toString();
			QString uri = map.value("uri").toString();

			if (type == "phone") {
				PimUtil::launchPhoneCall(uri);
			} else if (type == "sms") {
				InvocationUtils::launchSMSComposer(uri, m_invokeManager);
			} else if (type == "email") {
				InvocationUtils::launchEmailComposer(uri, m_invokeManager);
			} else if (type == "url") {
				openUrl(uri);
			} else if (type == "file") {
				openFile(uri);
			} else if (type == "setting") {
				InvocationUtils::launchSettingsApp(uri);
			} else if (type == "bbm_video") {
				InvocationUtils::launchBBMCall(uri);
			} else if (type == "bbm_voice") {
				InvocationUtils::launchBBMCall(uri, false);
			} else if (type == "bbm_chat") {
				InvocationUtils::launchBBMChat(uri, m_invokeManager);
			}
		}
	} else if (id == 5) {
		m_sql.setQuery("SELECT sequence,uri FROM gestures");
		m_sql.load(2);
	}
}


void ShortCuts::openFile(QString const& uri)
{
	LOGGER("OPEN FILE" << uri);

	InvokeQueryTargetsRequest iqtr;
	iqtr.setTargetTypes(InvokeTarget::Card /* | InvokeTarget::Application*/);
	iqtr.setUri( QUrl::fromLocalFile(uri) );

	InvokeQueryTargetsReply* reply = m_invokeManager.queryTargets(iqtr);
	reply->setProperty( "uri", iqtr.uri() );
	connect( reply, SIGNAL( finished() ), this, SLOT( processQueryReply() ) );
}


void ShortCuts::processQueryReply()
{
    InvokeQueryTargetsReply* reply = static_cast<InvokeQueryTargetsReply*>( sender() );

    if ( reply->error() == InvokeReplyError::None )
    {
    	QList<InvokeAction> actions = reply->actions();

    	for (int i = actions.size()-1; i >= 0; i--)
    	{
    		InvokeAction ia = actions[i];

    		if ( ia.name() == "bb.action.VIEW" || ia.name() == "bb.action.OPEN" ) {
    			InvokeRequest ir;
    			ir.setAction( ia.name() );
    			ir.setTarget( ia.defaultTarget() );
    			ir.setUri( reply->property("uri").toUrl() );
    			m_invokeManager.invoke(ir);
    			break;
    		}
    	}
    }
}


void ShortCuts::openUrl(QString const& uri)
{
	bb::system::InvokeManager invoker;

	bb::system::InvokeRequest request;
	request.setTarget("sys.browser");
	request.setAction("bb.action.OPEN");
	request.setUri(uri);

	invoker.invoke(request);
}


void ShortCuts::portDeprecatedMapping()
{
	if ( m_persistance.contains("map") )
	{
	    QVariant saved = m_persistance.getValueFor("map");

	    QHash<QString, QVariant> map = saved.value< QHash<QString, QVariant> >();
	    QStringList keys = map.keys();

	    for (int i = keys.size()-1; i >= 0; i--)
	    {

	    }

	    m_persistance.remove("map");
    	LOGGER( "Map size" << map.size() );
	}
}


void ShortCuts::create(bb::cascades::Application* app) {
	new ShortCuts(app);
}


void ShortCuts::focus() {
	navigator_invoke("shortcuts://", 0);
}

ShortCuts::~ShortCuts()
{
}

}
