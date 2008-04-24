#
# $Id$

package Search::Google::Blogs;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/blogs');

package # hide from CPAN
	GblogSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		title
		titleNoFormatting
		postUrl
		content
		author
		blogUrl
		publishedDate
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
