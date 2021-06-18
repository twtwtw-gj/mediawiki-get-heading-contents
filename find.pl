use MediaWiki::API;
use JSON;
use Encode;
use utf8;
use strict;

my $config = do 'config.pl' or die "$!$@";

my $mw = MediaWiki::API->new();
$mw->{config}->{api_url} = ($config->{"site"}->{"api_url"});

# login
if (defined($config->{"user"})) {
  $mw->login({
    lgname=>($config->{"user"}->{"name"}),
    lgpassword=>($config->{"user"}->{"password"})
  });
}

# get a list of articles of search
my $articles = $mw->list({
    "action"=>"query",
    "list"=>"search",
    "srsearch" => $config->{"find_word"},
    "srlimit" => 1,
}, {"max" => 1}) || die $mw->{error}->{code} . ': '. $mw->{error}->{details};

print Encode::encode("UTF-8",to_json($articles, {pretty=>1}));

# logout
if (defined($config->{"user"})) {
  $mw->logout();
}

__END__
