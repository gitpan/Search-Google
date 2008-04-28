#
# $Id$

package Search::Google;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.4');

use Carp qw/carp croak/;

use JSON::Any;

use HTTP::Request;
use LWP::UserAgent;

use URI;

use constant {
	WEB => 'http://ajax.googleapis.com/ajax/services/search/web',
	VIDEO => 'http://ajax.googleapis.com/ajax/services/search/video',
	NEWS => 'http://ajax.googleapis.com/ajax/services/search/news',
	LOCAL => 'http://ajax.googleapis.com/ajax/services/search/local',
	IMAGES => 'http://ajax.googleapis.com/ajax/services/search/images',
	BOOKS => 'http://ajax.googleapis.com/ajax/services/search/books',
	BLOGS => 'http://ajax.googleapis.com/ajax/services/search/blogs',
};

use base qw/Exporter Class::Data::Inheritable Class::Accessor/;

our @EXPORT = qw/WEB VIDEO NEWS LOCAL IMAGES BOOKS BLOGS/;

__PACKAGE__->mk_classdata("http_referer");
__PACKAGE__->mk_classdata("service" => WEB);

__PACKAGE__->mk_accessors(qw/responseDetails responseStatus/);

use constant DEFAULT_ARGS => (
	'v' => '1.0',
);

use constant DEFAULT_REFERER => 'http://example.com';

# private method: used in constructor to get it's arguments
sub _get_args {
	my $proto = shift;

	my %args;
	if ( scalar(@_) > 1 ) {
		if ( @_ % 2 ) {
			croak "odd number of parameters";
		}
		%args = @_;
	} elsif ( ref $_[0] ) {
		unless ( eval { local $SIG{'__DIE__'}; %{ $_[0] } || 1 } ) {
			croak "not a hashref in args";
		}
		%args = %{ $_[0] };
	} else {
		%args = ( 'q' => shift );
	}

	return { DEFAULT_ARGS, %args };
}

sub new {
	my $class = shift;

	my $args = $class->_get_args(@_);

	my $uri = URI->new( $class->service );
	$uri->query_form( $args );

	unless ( defined $class->http_referer ) {
		carp "attempting to search without setting a valid http referer header";
		$class->http_referer( DEFAULT_REFERER );
	}

	my $request = HTTP::Request->new( GET => $uri, [ 'Referer', $class->http_referer ] );

	my $ua = LWP::UserAgent->new();
	$ua->env_proxy;

	my $response = $ua->request( $request );

	croak sprintf qq/HTTP request failed: %s/, $response->status_line
		unless $response->is_success;

	my $content = $response->content;

	my $json = JSON::Any->new();
	my $self = $json->decode($content);

	return bless $self, $class;
}

sub responseData {
	my $self = shift;
	return bless $self->{responseData}, 'Search::Google::Data';
}

package # hide from CPAN
	Search::Google::Data;

sub results {
	my $self = shift;
	return map { bless $_, $_->{GsearchResultClass} } @{ $self->{results} };
}

sub cursor {
	my $self = shift;
	return bless $self->{cursor}, 'Search::Google::Cursor';
} 

package # hide from CPAN
	Search::Google::Cursor;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		estimatedResultCount
		currentPageIndex
		moreResultsUrl
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

# XXX original 'pages' entry contains array of hashes.
sub pages {
	my $self = shift;
	my $pages = $self->{pages};
	return scalar @{ $pages };
}

#
# Search Result Classes
#

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
