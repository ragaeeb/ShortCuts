#ifndef ShortCuts_HPP_
#define ShortCuts_HPP_

#include "customsqldatasource.h"
#include "LazySceneCover.h"
#include "Persistance.h"

#include <bb/system/InvokeManager>

namespace bb {
	namespace cascades {
		class Application;
	}
}

namespace shortcuts {

using namespace bb::cascades;
using namespace canadainc;

class ShortCuts : public QObject
{
    Q_OBJECT

    CustomSqlDataSource m_sql;
    LazySceneCover m_cover;
    Persistance m_persistance;
    bb::system::InvokeManager m_invokeManager;

    ShortCuts(Application* app);
    void showRecordedGesture(QString const& sequence, QString const& message);
    void openUrl(QString const& uri);
    void openFile(QString const& uri);
    void executeWrite(QString const& query, QVariantList const& args=QVariantList());

private slots:
	void init();
	void dataLoaded(int id, QVariant const& data);
	void processQueryReply();

Q_SIGNALS:
	void initialize();

public:
	static void create(Application* app);
    virtual ~ShortCuts();

    Q_INVOKABLE void focus();

    Q_INVOKABLE void removeShortcut(QString const& sequence);
    Q_INVOKABLE void registerShortcut(QString const& sequence, QString const& type, QString const& uri);
    Q_INVOKABLE void clearAllShortcuts();
    Q_INVOKABLE void requestAllShortcuts();
};

}

#endif /* ShortCuts_HPP_ */
