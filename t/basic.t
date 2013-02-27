use strict;
use warnings;
use Regexp::Match;
use Test::More;

{
  my $m = Regexp::Match->matches(
    "our input: alpha beta gamma deltoid",
    qr/a(.)ph(.+)g(.+)a/,
    1,
  );

  ok($m, "matches");

  is($m->pre_match,  'our input: ',      'pre_match');
  is($m->match,      'alpha beta gamma', 'match');
  is($m->post_match, ' deltoid',         'post_match');

  is($m->captures, 3, "three captures");
  is_deeply(
    [ $m->captures ],
    [ 'l', 'a beta ', 'amm' ],
    "captures are what we expected",
  );
}

{
  my $m = Regexp::Match->matches(
    "foobarbaz",
    qr/(?<foo>foo)(?<bar>bar)(?<foo>baz)/,
    1,
  );

  ok($m, "matches");

  is($m->capture(1), 'foo', 'capture 1');
  is($m->capture(2), 'bar', 'capture 2');
  is($m->capture(3), 'baz', 'capture 3');

  is($m->capture('foo'), 'foo', 'capture foo');
  is($m->capture('bar'), 'bar', 'capture bar');

  is_deeply( [ $m->capture_list(1) ], [ 'foo' ], '1 in list');
  is_deeply( [ $m->capture_list('foo') ], [ qw(foo baz) ], 'foo in list');
  is_deeply( [ $m->capture_list('bar') ], [ qw(bar)],      'bar in list');
  is_deeply( [ $m->capture_list('xyz') ], [ ],             'xyz in list');
}
