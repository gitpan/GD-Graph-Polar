#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: base.t,v 0.1 2006/02/21 eserte Exp $
# Author: Michael R. Davis
#

=head1 NAME

base.t - Good examples concerning how to use this module

=cut

use strict;
use lib q{lib};
use lib q{../lib};
use constant NEAR_DEFAULT => 7;

sub near {
  my $x=shift();
  my $y=shift();
  my $p=shift()||NEAR_DEFAULT;
  if (($x-$y)/$y < 10**-$p) {
    return 1;
  } else {
    return 0;
  }
}


BEGIN {
    if (!eval q{
	use Test;
	1;
    }) {
	print "1..0 # tests only works with installed Test module\n";
	exit;
    }
}

BEGIN { plan tests => 8 }

# just check that all modules can be compiled
ok(eval {require GD::Graph::Polar; 1}, 1, $@);

my $obj = GD::Graph::Polar->new(radius=>30,
                                size=>40,
                                border=>5);
ok(ref $obj, "GD::Graph::Polar");

ok($obj->_width, 30);
ok($obj->_scale(15), 7.5);
my($x,$y)=$obj->_imgxy_xy(5,7);
ok($x,20);
ok($y,8);
($x,$y)=$obj->_xy_rt_rad(sqrt(5), atan2(1,2));
ok($x=>2);
ok($y=>1);
