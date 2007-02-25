#!/usr/bin/perl -w

=head1 NAME

example-text.pl - GD::Graph::Polar example

=head1 SAMPLE OUTPUT

L<http://search.cpan.org/src/MRDVT/GD-Graph-Polar-0.11/bin/example-text.png>

=cut

use strict;
use lib qw{./lib ../lib};
use GD::Graph::Polar;
eval q{Graphics::ColorNames};
#die("Error: This script requires Graphics::ColorNames") if $@;

my $obj=GD::Graph::Polar->new(size=>450, radius=>10);
$obj->addString(88=>$_, $_) foreach (0,90,180,270);

foreach ([  6=>35, "blue"],
         [  2=>90, "red"],
         [ 5=>180, "green"],
         [ 7=>210, "DarkBlue"],
         [10=>300, "black"]) {
  my $r=$_->[0];
  my $t=$_->[1];
  my $c=$_->[2];
  $obj->color($c);
  $obj->addPoint($r=>$t);
  $obj->addGeoPoint($r=>$t);
  $obj->color("black");
  $obj->addString($r=>$t, "$c ($r=>$t)");
  $obj->addGeoString($r=>$t, "Geo:$c ($r=>$t)");
}
open(IMG, ">example-text.png");
print IMG $obj->draw;
close(IMG);
