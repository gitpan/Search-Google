#
# $Id$

package Search::Google::Images;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::IMAGES );

return 1;
