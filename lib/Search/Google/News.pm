#
# $Id$

package Search::Google::News;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::NEWS );

return 1;
