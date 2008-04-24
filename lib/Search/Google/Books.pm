#
# $Id$

package Search::Google::Books;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/books');

package # hide from CPAN
	GbookSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		title
		titleNoFormatting
		unescapedUrl
		url
		authors
		bookId
		publishedYear
		pageCount
		thumbnailHtml
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
