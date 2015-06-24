package WebService::MinFraud;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.001001';

1;

# ABSTRACT: Perl API for MaxMind's minFraud Score and Insights web services

__END__

=pod

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  # The Client object can be re-used across several requests.
  # Your MaxMind user_id and license_key are available at
  # https://www.maxmind.com/en/my_license_key
  my $client = WebService::MinFraud::Client->new(
      user_id     => '42',
      license_key => 'abcdef123456',
  );

  # Request hashref must contain a 'device' key, with a value that is a
  # hashref containing an 'ip_address' key with a valid IPv4 or IPv6 address.
  # All other keys/values are optional; see other modules in minFraud perl API
  # distribution for details.

  my $request = { device => { ip_address => '24.24.24.24' } }:

  # Use the 'score' or 'insights' client methods, depending on the minFraud
  # web service you are using.

  my $score = $client->score( $request );
  say $score->risk_score;

  my $insights = $client->insights( $request );
  say $insights->shipping_address->is_high_risk;

=head1 DESCRIPTION

This distribution provides an API for the
L<MaxMind minFraud Score and Insights web services|http://dev.maxmind.com/minfraud/minfraud-score-and-insights-api-documentation/>.

See L<WebService::MinFraud::Client> for details on using the web service client
API.

=head1 INSTALLATION

The minFraud perl API and its dependencies can be installed with
L<cpanm|https://metacpan.org/pod/App::cpanminus>.  C<< cpanm >> itself has no
dependencies.

  cpanm WebService::MinFraud

=head1 VERSIONING POLICY

The minFraud perl API uses L<Semantic Versioning|http://semver.org/>.

=head1 PERL VERSION SUPPORT

The minimum required perl version for the minFraud perl API is 5.10.0.

The data returned from the minFraud web services includes Unicode characters
in several locales. This may expose bugs in earlier versions of perl.  If
Unicode is important to your work, we recommend that you use the most recent
version of perl available.

=head1 SUPPORT

Please report all issues with this distribution using the GitHub issue tracker
at L<https://github.com/maxmind/minfraud-api-perl/issues>.

If you are having an issue with a MaxMind service that is not specific to the
client API please visit L<http://www.maxmind.com/en/support> for details.

=cut
