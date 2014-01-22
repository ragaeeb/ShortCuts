#ifndef VKBMANAGER_H_
#define VKBMANAGER_H_

#include <QObject>

#include <bb/AbstractBpsEventHandler>

namespace shortcuts {

class VkbManager : public QObject, public bb::AbstractBpsEventHandler
{
	Q_OBJECT

public:
	VkbManager();
	virtual ~VkbManager();

	void event(bps_event_t *event);

	Q_INVOKABLE void show();
	Q_INVOKABLE void hide();
};

} /* namespace shortcuts */
#endif /* VKBMANAGER_H_ */
