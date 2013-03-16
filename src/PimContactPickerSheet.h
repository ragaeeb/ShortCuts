#ifndef PIMCONTACTPICKERSHEET_H_
#define PIMCONTACTPICKERSHEET_H_

#include <QObject>
#include <QVariantList>

namespace bb {
	namespace cascades {
		namespace pickers {
			class ContactPicker;
		}
	}
}

namespace shortcuts {

using namespace bb::cascades;
using namespace bb::cascades::pickers;

class PimContactPickerSheet : public QObject
{
    Q_OBJECT

private:
    ContactPicker* m_picker;
    QVariantList m_numbers;

public:
    PimContactPickerSheet(QObject* parent=NULL);
    virtual ~PimContactPickerSheet();

    Q_INVOKABLE void open();
    Q_INVOKABLE QVariantList getPhoneNumbers();

signals:
	void contactSelected(QString const& name, QString const& avatarPath);

private slots:
	void cancel();
	void onContactSelected(int);
};

} /* namespace shortcuts */

#endif /* PIMCONTACTPICKERSHEET_H_ */
