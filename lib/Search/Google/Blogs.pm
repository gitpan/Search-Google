#
# $Id$

package Search::Google::Blogs;

use strict;
use warnings;

use base qw/Search::Google/;

__PACKAGE__->service( &Search::Google::BLOGS );

return 1;
