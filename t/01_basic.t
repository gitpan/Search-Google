#
# $Id$

use strict;

use Test::More tests => 5;

BEGIN { use_ok( "Search::Google" ); }

# referer test
Search::Google->http_referer('http://www.cpan.org');

my $search = Search::Google->new(
	v => '1.0',
	q => 'Jimi Hendrix',
);

isa_ok( $search, 'Search::Google', "search object" );

ok(defined $search->status, "search status");

my $data = $search->data; 

isa_ok( $data, 'Search::Google::Data', "data object" );

my $cursor = $data->cursor; 

isa_ok( $cursor, 'Search::Google::Cursor', "cursor object" );

