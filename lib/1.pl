
use Search::Google::Web;

Search::Google::Web->http_referer('http://example.org');
my $res = Search::Google::Web->new('sobchenko');

my @results = $res->responseData->results;

foreach my $r (@results) {
	printf "title: %s\n", $r->title;
	printf "url: %s\n", $r->url;
}
