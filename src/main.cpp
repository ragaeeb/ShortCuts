#include "precompiled.h"

#include "Logger.h"
#include "ShortCuts.hpp"

using namespace shortcuts;

#ifdef DEBUG
namespace {

void redirectedMessageOutput(QtMsgType type, const char *msg) {
	Q_UNUSED(type);
	fprintf(stderr, "%s\n", msg);
}

}
#endif

Q_DECL_EXPORT int main(int argc, char **argv)
{
#ifdef DEBUG
	qInstallMsgHandler(redirectedMessageOutput);
#endif

    Application app(argc, argv);
    ShortCuts::create(&app);

    return Application::exec();
}
