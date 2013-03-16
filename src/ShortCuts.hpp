#ifndef ShortCuts_HPP_
#define ShortCuts_HPP_

#include <QSettings>

#include <bb/system/SystemUiResult>

namespace bb {
	namespace cascades {
		class AbstractDialog;
		class Application;
		class NavigationPane;
	}

	namespace system {
		class SystemToast;
	}
}

namespace shortcuts {

using namespace bb::cascades;
using namespace bb::system;

class ShortCuts : public QObject
{
    Q_OBJECT

    NavigationPane* m_root;
    QSettings m_settings;
    bool m_changed;
    SystemToast* m_toast;
	QHash<QString, QVariant> m_map;

    bool registerGestures(QString const& sequence, QString uri);
    void showRecordedGesture(QString const& sequence, QString const& message);
    void displayToast(QString const& text);

private slots:
	void onAboutToQuit();

public:
    ShortCuts(Application *app);
    virtual ~ShortCuts();
    Q_INVOKABLE void saveValueFor(const QString &objectName, const QVariant &inputValue);
    Q_INVOKABLE QVariant getValueFor(const QString &objectName);

    Q_INVOKABLE static QString render(QStringList const& sequence);
    Q_INVOKABLE bool process(QStringList const& sequence);
    Q_INVOKABLE void registerUri(QString const& sequence, QString const& uri);
    Q_INVOKABLE void registerPhone(QString const& sequence, QString const& number);
    Q_INVOKABLE void registerFile(QString const& sequence, QString const& uri);
    Q_INVOKABLE void registerApp(QString const& sequence, QString const& target, QString const& uri, QString const& mime);
    Q_INVOKABLE bool removeShortcut(QString const& sequence);
    Q_INVOKABLE void clearAllShortcuts();
    Q_INVOKABLE QVariantList getAllShortcuts() const;
};

}

#endif /* ShortCuts_HPP_ */
