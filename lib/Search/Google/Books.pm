#
# $Id$

package Search::Google::Books;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::BOOKS );

return 1;
