#
# $Id$

package Search::Google::News;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/news');

package # hide from CPAN
	GnewsSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		title
		titleNoFormatting
		unescapedUrl
		url
		clusterUrl
		content
		publisher
		location
		publishedDate
		relatedStories
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
