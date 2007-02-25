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

BEGIN {
    if (!eval q{
	use Test;
	1;
    }) {
	print "1..0 # tests only works with installed Test module\n";
	exit;
    }
}

BEGIN { plan tests => 9 }

use lib qw{./blib/lib};
use GD::Graph::Polar;

my $obj = GD::Graph::Polar->new(radius=>30,
                                size=>40,
                                border=>5,
                                rgbfile=>"./rgb.txt");  #no standard location
ok(ref $obj, "GD::Graph::Polar");

ok($obj->_width, 30);
ok($obj->_scale(15), 7.5);
my($x,$y)=$obj->_imgxy_xy(5,7);
ok($x,25);
ok($y,13);
($x,$y)=$obj->_xy_rt_rad(sqrt(5), atan2(1,2));
ok($x=>2);
ok($y=>1);
ok($obj->color([1,2,3]));
my $skip = 0;
eval q{use Graphics::ColorNames};
$skip = 1 if $@;
skip($skip, sub{$obj->color("blue")});
