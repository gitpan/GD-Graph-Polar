#!/usr/bin/perl -w

=head1 NAME

example-plot.pl - GD::Graph::Polar example

=cut

use strict;
use GD::Graph::Polar;

print "Content-type: image/png\n\n";
        
my $obj = GD::Graph::Polar->new(radius=>100);
$obj->addPoint(75=>30);
$obj->addLine(75=>30, 20=>75);
print $obj->draw;
