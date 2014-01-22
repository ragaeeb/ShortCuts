#include "precompiled.h"

#include "VkbManager.h"
#include "Logger.h"

namespace shortcuts {

using namespace bb;

VkbManager::VkbManager()
{
	bps_initialize();
	subscribe( virtualkeyboard_get_domain() );
	virtualkeyboard_request_events(0);
}

VkbManager::~VkbManager()
{
	LOGGER("VkbManager::~VkbManager()");
	virtualkeyboard_stop_events(0);
	unsubscribe( virtualkeyboard_get_domain() );
	bps_shutdown();
}

void VkbManager::event(bps_event_t *event)
{
	if ( bps_event_get_domain(event) == virtualkeyboard_get_domain() )
	{
		 uint16_t code = bps_event_get_code(event);

		 if(code == VIRTUALKEYBOARD_EVENT_VISIBLE)
		 {
			 LOGGER("VKB shown");
		 } else if(code == VIRTUALKEYBOARD_EVENT_HIDDEN){
			 LOGGER("VKB hidden");
		 }
	 }
}

void VkbManager::show() {
	virtualkeyboard_show();
}

void VkbManager::hide() {
	virtualkeyboard_hide();
}

} /* namespace bbmui */
