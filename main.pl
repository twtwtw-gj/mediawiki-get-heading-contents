use MediaWiki::API;
use HTML::TreeBuilder;
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

# get the article
my $page = $mw->api ( {
  action=>"parse",
  page=>$config->{"site"}->{"page_title"},
  format=>"json"
}) || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};

# make Tree to analysis
my $tree = HTML::TreeBuilder->new;
$tree->parse($page->{"parse"}->{"text"}->{"*"});
$tree->eof();

my @heading_elements = ();

for (1..6) {
  push @heading_elements, $tree->find("h$_");
}

# specific the heading HTML element
my $heading = "";
foreach my $element (@heading_elements) {
  my $heading_title = $config->{"site"}->{"heading_title"};
  if ($element->as_text =~ /${heading_title}/) {
    $heading = $element;
    last;
  }
}

# extract content
my @contents = ($heading);

# If another heading, stop to extract 
foreach my $element ($heading->right()) {
  if ($element->tag =~ /^(h)(\d)$/) {
    my $tag_number = $2;
    $heading->tag =~ /^(h)(\d)$/;
    my $heading_tag_number = $2;

    if ($tag_number <= $heading_tag_number) {
      last;
    }
  }
  push @contents, $element;
}

# to make result string
my @html_list = map {$_->as_HTML("", " ")} @contents;
my $result = join("\n", @html_list);

print Encode::encode("UTF-8", $result."\n");

# logout
if (defined($config->{"user"})) {
  $mw->logout();
}

__END__
