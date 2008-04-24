#
# $Id$

package Search::Google::Images;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/images');

package # hide from CPAN
	GimageSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		title
		titleNoFormatting
		unescapedUrl
		url
		visibleUrl
		originalContextUrl
		width
		height
		tbWidth
		tbHeight
		tbUrl
		content
		contentNoFormatting
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
