package WebService::MinFraud::Error::Generic;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;

extends 'Throwable::Error';

1;

# ABSTRACT: A generic exception

__END__

=head1 SYNOPSIS

  use 5.008;

  use WebService::MinFraud::Client;
  use Scalar::Util qw( blessed );
  use Try::Tiny;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      $client->insights( ip => '24.24.24.24' );
  }
  catch {
      die $_ unless blessed $_;
      die $_ if $_->isa('WebService::MinFraud::Error::Generic');

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents a generic error. It extends L<Throwable::Error> and does
not add any additional attributes.

=head1 METHODS

This class has two methods, C<< $error->message() >>, and C<<
$error->stack_trace() >>. Both methods are inherited from L<Throwable::Error>.

