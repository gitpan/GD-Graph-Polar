#!/usr/bin/perl -w

=head1 NAME

example-locate.pl - GD::Graph::Polar example

=head1 SAMPLE OUTPUT

L<http://search.cpan.org/src/MRDVT/GD-Graph-Polar-0.14/bin/example-locate.png>

=cut

use strict;
use lib qw{./lib ../lib};
use GD::Graph::Polar;

my $obj=GD::Graph::Polar->new(size=>450, radius=>10, border=>10);
$obj->addString(88=>$_, $_) foreach (0,90,180,270);

foreach my $r (0,3,5,7,9) {
  foreach (0..7) {
    my $t=$_*45;
    $obj->addPoint($r=>$t);
    $obj->addString($r=>$t, "$r=>$t");
  } 
}
open(IMG, ">example-locate.png");
print IMG $obj->draw;
close(IMG);
