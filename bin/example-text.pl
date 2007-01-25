#!/usr/bin/perl -w

=head1 NAME

example-text.pl - GD::Graph::Polar example

=head1 SAMPLE OUTPUT

L<http://search.cpan.org/src/MRDVT/GD-Graph-Polar-0.07/bin/example-text.png>

=cut

use strict;
use lib qw{./lib ../lib};
use GD::Graph::Polar;

my $obj=GD::Graph::Polar->new(size=>450, radius=>10);
foreach ([1=>45, "blue"],[2=>90, "red"],[5=>180, "green"],[10=>300,"black"]) {
  my $r=$_->[0];
  my $t=$_->[1];
  $obj->color($_->[2]);
  $obj->addPoint($r=>$t);
  $obj->color("black");
  $obj->addString($r=>$t, "Hello");
}
open(IMG, ">example-text.png");
print IMG $obj->draw;
close(IMG);
