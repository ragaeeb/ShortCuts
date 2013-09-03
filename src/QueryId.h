#ifndef QUERYID_H_
#define QUERYID_H_

#include <qobjectdefs.h>

namespace shortcuts {

class QueryId
{
    Q_GADGET
    Q_ENUMS(Type)

public:
    enum Type {
        GetAll,
        LookupSequence,
        WriteShortcut
    };
};

} /* namespace ilmtest */

#endif /* LIFELINE_H_ */
