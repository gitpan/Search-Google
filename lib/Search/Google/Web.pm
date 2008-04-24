#
# $Id$

package Search::Google::Web;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/web');

package # hide from CPAN 
	GwebSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		GsearchResultClass
		unescapedUrl
		url
		visibleUrl
		cacheUrl
		title
		titleNoFormatting
		content
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
