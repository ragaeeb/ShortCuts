#include "Logger.h"
#include "PimContactPickerSheet.h"

#include <bb/pim/contacts/ContactService.hpp>

#include <bb/cascades/pickers/ContactPicker.hpp>

namespace shortcuts {

using namespace bb::pim::contacts;
using namespace bb::cascades;

PimContactPickerSheet::PimContactPickerSheet(QObject* parent) : QObject(parent), m_picker(NULL)
{
}


PimContactPickerSheet::~PimContactPickerSheet() {
	m_picker->close();
}


void PimContactPickerSheet::open()
{
	if (m_picker == NULL)
	{
		m_picker = new ContactPicker(this);

		QSet<AttributeKind::Type> filters;
		filters << AttributeKind::Phone;
		filters << AttributeKind::VideoChat;
		KindSubKindSpecifier mobileFilter(AttributeKind::Phone, AttributeSubKind::PhoneMobile);
		QSet<KindSubKindSpecifier> subkindFilters;
		subkindFilters << mobileFilter;
		m_picker->setSubKindFilters(subkindFilters);
		m_picker->setKindFilters(filters);

	    connect( m_picker, SIGNAL( canceled() ), this, SLOT( cancel() ) );
	    connect( m_picker, SIGNAL( contactSelected(int) ), this, SLOT( onContactSelected(int) ) );
	}

	m_picker->open();
}

void PimContactPickerSheet::cancel()
{
	//m_picker->close();
}

void PimContactPickerSheet::onContactSelected(int contactid)
{
	LOGGER("onContactSelected()" << contactid);

	m_picker->close();

    Contact contact = ContactService().contactDetails(contactid);

    QList<ContactAttribute> numbers = contact.phoneNumbers();

    for (int i = 0; i < numbers.size(); i++) {
    	LOGGER("phone number: " << numbers[i].attributeDisplayLabel() << numbers[i].value());
    	QVariantMap map;
    	map.insert( "name", numbers[i].attributeDisplayLabel() );
    	map.insert( "number", numbers[i].value() );
    	m_numbers << map;
    }

    emit contactSelected( contact.displayName(), contact.smallPhotoFilepath() );
 }


QVariantList PimContactPickerSheet::getPhoneNumbers() {
	return m_numbers;
}

}
