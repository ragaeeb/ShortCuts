#include <bb/cascades/Application>
#include <bb/cascades/pickers/FilePicker>

#include <QTimer>

#include "Logger.h"
#include "ShortCuts.hpp"
#include "PimContactPickerSheet.h"

using namespace bb::cascades;
using namespace shortcuts;

#ifdef DEBUG
namespace {

void redirectedMessageOutput(QtMsgType type, const char *msg) {
	fprintf(stderr, "%s\n", msg);
}

}
#endif

Q_DECL_EXPORT int main(int argc, char **argv)
{
#ifdef DEBUG
	qInstallMsgHandler(redirectedMessageOutput);
#endif

    qmlRegisterType<QTimer>("CustomComponent", 1, 0, "QTimer");
    qmlRegisterType<PimContactPickerSheet>("bb.cascades.pickers", 1, 0, "PimContactPickerSheet");
	qmlRegisterType<bb::cascades::pickers::FilePicker>("CustomComponent", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("CustomComponent", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("CustomComponent", 1, 0, "FilePickerMode", "Can't instantiate");

    Application app(argc, argv);
    new ShortCuts(&app);

    return Application::exec();
}
