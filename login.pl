use MediaWiki::API;
use JSON;
use utf8;
use strict;

my $config = do 'config.pl' or die "$!$@";

my $mw = MediaWiki::API->new();

# login
$mw->{config}->{api_url} = ($config->{"site"}->{"api_url"});
$mw->login({
  lgname=>($config->{"user"}->{"name"}),
  lgpassword=>($config->{"user"}->{"password"})
});

my $userinfo = $mw->api({
  action=>"query",
  meta=>"userinfo",
  uiprop=>"rights",
  format=>"json"
});

print to_json($userinfo, {pretty=>1});

$mw->logout();

__END__
