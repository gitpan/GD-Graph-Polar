#!/usr/bin/perl -w

=head1 NAME

example-plot.pl - GD::Graph::Polar example

=cut

use strict;
use lib qw{./lib ../lib};
use GD::Graph::Polar;

my $obj=GD::Graph::Polar->new(size=>450, radius=>10);
foreach (1..10) {
  my $r0=$_;
  my $t0=-($_*3+5);
  my $r1=$r0 * 0.8;
  my $t1=-$t0;
  $obj->addPoint($r0=>$t0);
  $obj->addPoint($r1=>$t1);
  $obj->addLine($r0=>$t0, $r1=>$t1);
}
open(IMG, ">example-plot.png");
print IMG $obj->draw;
close(IMG);
