#
# $Id$

package Search::Google::News;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.5');

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::NEWS );

return 1;
