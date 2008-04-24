#
# $Id$

package Search::Google::Local;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use base qw/Search::Google/;

__PACKAGE__->service_uri('http://ajax.googleapis.com/ajax/services/search/local');

package # hide from CPAN
	GlocalSearch;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		title
		titleNoFormatting
		url
		lat
		lng
		streetAddress
		city
		region
		country
		phoneNumbers
		ddUrl
		ddUrlToHere
		ddUrlFromHere
		staticMapUrl
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

return 1;
