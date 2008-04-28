#
# $Id$

package Search::Google::Video;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::VIDEO );

return 1;
