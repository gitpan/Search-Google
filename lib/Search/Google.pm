#
# $Id$

package Search::Google;

use strict;
use warnings;

use version; our $VERSION = qv('1.0.0');

use Carp qw/carp croak/;

use Data::Dumper;

use JSON::Any;

use HTTP::Request;
use LWP::UserAgent;

use URI;

use base qw/Class::Data::Inheritable/;

__PACKAGE__->mk_classdata("http_referer");
__PACKAGE__->mk_classdata("service_uri" => 'http://ajax.googleapis.com/ajax/services/search/web');

my $result_objects = {};

# private method: used in constructor to get it's arguments
sub _get_args {
	my $proto = shift;

	my $args;
	if ( scalar(@_) > 1 ) {
		if ( @_ % 2 ) {
			croak "odd number of parameters";
		}
		$args = { @_ };
	} elsif ( ref $_[0] ) {
		unless ( eval { local $SIG{'__DIE__'}; %{ $_[0] } || 1 } ) {
			croak "not a hashref in args";
		}
		$args = $_[0];
	} else {
		$args = { q => shift };
	}

	return $args;
}

sub new {
	my $class = shift;
	croak "you need to specify a valid http referer according to Google AJAX Search API terms of use"
		unless $class->http_referer; 

	my $args = $class->_get_args(@_);

	my $uri = URI->new( $class->service_uri );
	$uri->query_form( $args );

	my $request = HTTP::Request->new( GET => $uri, [ 'Referer', $class->http_referer ] );

	my $lwp = LWP::UserAgent->new();
	$lwp->timeout(10);
	$lwp->env_proxy;

	my $response = $lwp->request( $request );

	die $response->status_line unless $response->is_success;

	my $content = $response->content;
	my $json = JSON::Any->new();
	
	my $self = $json->decode($content);

	return bless $self, $class;
}

sub data {
	my $self = shift;
	return bless $self->{responseData}, 'Search::Google::Data';
}

sub details {
	my $self = shift;
	return $self->{responseDetails};
}

sub status {
	my $self = shift;
	return $self->{responseStatus};
}

package Search::Google::Data;

sub results {
	my $self = shift;
	return map { bless $_, $_->{GsearchResultClass} } @{ $self->{results} };
}

sub cursor {
	my $self = shift;
	return bless $self->{cursor}, 'Search::Google::Cursor';
} 

package Search::Google::Cursor;

use base qw/Class::Accessor/;

{
	my @fields = qw(
		estimatedResultCount
		currentPageIndex
		moreResultsUrl
	);

	__PACKAGE__->mk_ro_accessors( @fields );
}

# XXX original 'pages' entry contain array of hashes.
sub pages {
	my $self = shift;
	my $pages = $self->{pages};
	return scalar @{ $pages };
}

return 1;

__END__

=head1 NAME

Search::Google - Perl OO interface to the Google REST API for searching

=head1 VERSION

This documentation refers to Search::Google version 1.0.0

=head1 SYNOPSIS

	use Search::Google::Web;

	# you should provide a valid http referer address according
	# to Google AJAX Search API terms of use!
	Search::Google::Web->http_referer('http://example.com');

	my $search = Search::Google::Web->new(
		v => '1.0',
		q => 'Larry Wall',
	);

	die "response status failure" if $search->status != 200;

	my $data = $search->data;

	my $cursor = $data->cursor;

	printf "pages: %s\n", $cursor->pages;
	printf "current page index: %s\n", $cursor->currentPageIndex;
	printf "estimated result count: %s\n", $cursor->estimatedResultCount;

	my @results = $data->results;

	foreach my $r (@results) {
		printf "\n";
		printf "title: %s\n", $r->title;
		printf "url: %s\n", $r->url;
	}

=head1 DESCRIPTION

C<Search::Google> contains set of modules that provides OO interface to the Google
REST (aka AJAX) API for searching.

	TODO

=head1 METHODS

	TODO

=head1 CLASSES

=over

=item I<Search::Google::Web>

=item I<Search::Google::Blogs>

=item I<Search::Google::Books>

=item I<Search::Google::Images>

=item I<Search::Google::Local>

=item I<Search::Google::Video>

=item I<Search::Google::News>

=back

=head1 WARNING

This is alpha software. If you like this module, please provide us with failing tests
and API suggestions.

=head1 DEPENDENCIES

	TODO

=head1 SEE ALSO

L<http://code.google.com/p/search-google/> Search::Google project on Google code

L<http://code.google.com/apis/ajaxsearch/documentation/#fonje> to learn how to use Google AJAX API in non-Javascript environments.

L<http://code.google.com/apis/ajaxsearch/documentation/reference.html#_intro_fonje> for object specification.

=head1 LICENSE AND COPYRIGHT

Copyright 2008, Eugen Sobchenko <ejs@cpan.org> and Sergey Sinkovskiy <glorybox@cpan.org>

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
