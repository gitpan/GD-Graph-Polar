#!/usr/bin/perl -w
use strict;
use GD::Graph::Polar;

print "Content-type: image/png\n\n";
        
my $obj = GD::Graph::Polar->new(radius=>100);
$obj->addPoint(75, 30);
print $obj->draw;
