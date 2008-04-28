#
# $Id$

package Search::Google::Web;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::WEB );

return 1;
