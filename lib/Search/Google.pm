#
# $Id$

package Search::Google;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.2');

use Carp qw/carp croak/;

use Data::Dumper;

use JSON::Any;

use HTTP::Request;
use LWP::UserAgent;

use URI;

use base qw/Class::Data::Inheritable Class::Accessor/;

__PACKAGE__->mk_classdata("http_referer" => 'http://example.com');
__PACKAGE__->mk_classdata("service_uri" => 'http://ajax.googleapis.com/ajax/services/search/web');

__PACKAGE__->mk_accessors(qw/responseDetails responseStatus/);

use constant DEFAULT_ARGS => (
	'v' => '1.0',
);

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

	my $uri = URI->new( $class->service_uri );
	$uri->query_form( $args );

	my $request = HTTP::Request->new( GET => $uri, [ 'Referer', $class->http_referer ] );

	my $ua = LWP::UserAgent->new();
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

return 1;
