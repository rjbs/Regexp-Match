use strict;
use warnings;
package Regexp::Match;

sub matches {
  my ($class, undef, $qr, $p) = @_;
  my $str = "$_[1]"; # stringify only once

  return unless $str =~ $qr;
  my $result = { p => !! $p };
  $result->{str} = $str if $p;
  $result->{match_range} = [ $-[0], $+[0] ];
  $result->{g_starts} = [ @-[ 1 .. $#- ] ];
  $result->{g_ends}   = [ @+[ 1 .. $#+ ] ];
  for (1 .. $#-) {
    no strict 'refs';
    push @{ $result->{captures} }, ${ $_ };
  }

  $result->{capture_hash} = { %- };

  bless $result, $class;
}

sub capture {
  my ($self, $n) = @_;
  return $_[0]{captures}[$n - 1] if $n =~ /\A[0-9]+\z/;
  return( ($_[0]{capture_hash}{$n} // [])->[0] );
}

sub capture_list {
  my ($self, $n) = @_;
  # this is a mess in scalar context
  return $_[0]{captures}[$n - 1] if $n =~ /\A[0-9]+\z/;
  return @{ $_[0]{capture_hash}{$n} || [] };
}

sub captures {
  return @{ $_[0]{captures} },
}

sub pre_match {
  return unless $_[0]{p};
  return substr $_[0]{str}, 0, $_[0]{match_range}[0];
}

sub match {
  return unless $_[0]{p};
  return substr $_[0]{str}, $_[0]{match_range}[0],
    $_[0]{match_range}[1] - $_[0]{match_range}[0];
}

sub post_match {
  return unless $_[0]{p};
  return substr $_[0]{str}, $_[0]{match_range}[1];
}

1;
