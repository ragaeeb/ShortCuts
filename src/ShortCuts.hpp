#ifndef ShortCuts_HPP_
#define ShortCuts_HPP_

#include "LazySceneCover.h"
#include "Persistance.h"

namespace bb {
	namespace cascades {
		class AbstractDialog;
		class Application;
		class NavigationPane;
	}
}

namespace shortcuts {

using namespace bb::cascades;
using namespace canadainc;

class ShortCuts : public QObject
{
    Q_OBJECT

	Q_PROPERTY(int numShortcuts READ numShortcuts NOTIFY numShortcutsChanged)

    LazySceneCover m_cover;
    Persistance m_persistance;
    NavigationPane* m_root;
    bool m_changed;
	QHash<QString, QVariant> m_map;

    ShortCuts(Application* app);
    bool registerGestures(QString const& sequence, QString uri);
    void showRecordedGesture(QString const& sequence, QString const& message);

private slots:
	void onAboutToQuit();

Q_SIGNALS:
	void numShortcutsChanged();

public:
	static void create(Application* app);
    virtual ~ShortCuts();

    Q_INVOKABLE static QString render(QStringList const& sequence);
    Q_INVOKABLE bool process(QStringList const& sequence);
    Q_INVOKABLE void registerUri(QString const& sequence, QString const& uri);
    Q_INVOKABLE void registerPhone(QString const& sequence, QString const& number);
    Q_INVOKABLE void registerFile(QString const& sequence, QString const& uri);
    Q_INVOKABLE void registerApp(QString const& sequence, QString const& target, QString const& uri, QString const& mime);
    Q_INVOKABLE bool removeShortcut(QString const& sequence);
    Q_INVOKABLE void clearAllShortcuts();
    Q_INVOKABLE QVariantList getAllShortcuts() const;
    int numShortcuts() const;
};

}

#endif /* ShortCuts_HPP_ */
