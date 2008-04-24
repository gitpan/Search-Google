#
# $Id$

package Search::Google::Video;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/video');

package # hide from CPAN
	GvideoSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		title
		titleNoFormatting
		content
		url
		published
		publisher
		duration
		tbWidth
		tbHeight
		tbUrl
		playUrl
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
