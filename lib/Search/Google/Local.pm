#
# $Id$

package Search::Google::Local;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::LOCAL );

return 1;
