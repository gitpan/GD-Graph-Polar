package GD::Graph::Polar;

=head1 NAME

GD::Graph::Polar - Make polar graph using GD package

=head1 SYNOPSIS

  use GD::Graph::Polar;
  my $obj=GD::Graph::Polar->new(size=>480, radius=>100);
  $obj->addPoint        (50=>25);
  $obj->addPoint_rad    (50=>3.1415);
  $obj->addGeoPoint     (75=>25);
  $obj->addGeoPoint_rad (75=>3.1415);
  $obj->addLine($r0=>$t0, $r1=>$t1);
  $obj->addGeoLine($r0=>$t0, $r1=>$t1);
  $obj->addGeoArc($r0=>$t0, $r1=>$t1);
  print $obj->draw;

=head1 DESCRIPTION

=cut

use strict;
use vars qw($VERSION);
use Geo::Constants qw{PI};
use Geo::Functions qw{rad_deg deg_rad};
use GD;

$VERSION = sprintf("%d.%02d", q{Revision: 0.05} =~ /(\d+)\.(\d+)/);

=head1 CONSTRUCTOR

=head2 new

The new() constructor. 

  my $obj = GD::Graph::Polar->new(               #default values
                                  size=>480,     #width and height in pixels
                                  radius=>1,     #scale of the radius
                                  ticks=>10,     #number of major ticks
                                  border=>2,     #pixel border around graph
                                 );

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=cut

sub initialize {
  my $self = shift();
  my $param = {@_};
  $self->{'size'}  =$param->{'size'}   || 480;
  $self->{'radius'}=$param->{'radius'} || 1;
  $self->{'ticks'} =$param->{'ticks'}  || 10;
  $self->{'border'}=$param->{'border'} || 2;
  $self->{'object'}=GD::Image->new($self->{'size'}, $self->{'size'});
  my $color={white=>[255,255,255],
              gray=>[192,192,192],
              black=>[0,0,0],
              red=>[255,0,0],
              blue=>[0,0,255]};
  $self->{'color'}={};
  foreach (keys %$color) {
    $self->{'color'}->{$_}=$self->{'object'}->colorAllocate(@{$color->{$_}}); 
  }
  # make the background transparent and interlaced
  $self->{'object'}->transparent($self->{'color'}->{'white'});
  $self->{'object'}->interlaced('true');
  
  # Put a frame around the picture
  $self->{'object'}->rectangle(0,0,$self->{'size'}-1,$self->{'size'}-1,$self->{'color'}->{'black'});

  foreach (0..$self->{'ticks'}) {
    my $c=$self->{'size'} / 2;
    my $r=$self->_width * $_ / $self->{'ticks'};
    $self->{'object'}->arc($c,$c,$r,$r,0,360,$self->{'color'}->{'gray'});
  }

  $self->{'object'}->line($self->{'size'}/2,
                          $self->{'border'},
                          $self->{'size'}/2,
                          $self->{'size'}-$self->{'border'},
                          $self->{'color'}->{'gray'});
  $self->{'object'}->line($self->{'border'},
                          $self->{'size'}/2,
                          $self->{'size'}-$self->{'border'},
                          $self->{'size'}/2,
                          $self->{'color'}->{'gray'});
}

=head2 addPoint

Method to add a point to the graph.

  $obj->addPoint(50=>25);

=cut

sub addPoint {
  my $self = shift();
  my $r=shift();
  my $t=rad_deg(shift());
  return $self->addPoint_rad($r,$t);
}

=head2 addPoint_rad

Method to add a point to the graph.

  $obj->addPoint_rad(50=>3.1415);

=cut

sub addPoint_rad {
  my $self = shift();
  my $r=shift();
  my $t=shift();
  my ($x, $y)=$self->_imgxy_rt_rad($r,$t);
  my $icon=7;
  $self->{'object'}->arc($x,$y,$icon,$icon,0,360,$self->{'color'}->{'black'});
}

=head2 addGeoPoint

Method to add a point to the graph.

  $obj->addGeoPoint(75=>25);

=cut

sub addGeoPoint {
  my $self = shift();
  my $r=shift();
  my $t=rad_deg(shift());
  return $self->addGeoPoint_rad($r,$t);
}

=head2 addGeoPoint_rad

Method to add a point to the graph.

  $obj->addGeoPoint_rad(75=>3.1415);

=cut

sub addGeoPoint_rad {
  my $self = shift();
  my $r=shift();
  my $t=shift();
  $t=PI()/2-$t;
  return $self->addPoint_rad($r,$t);
}

=head2 addLine

Method to add a line to the graph.

  $obj->addLine(50=>25, 75=>35);

=cut

sub addLine {
  my $self = shift();
  my $r0=shift();
  my $t0=rad_deg(shift());
  my $r1=shift();
  my $t1=rad_deg(shift());
  return $self->addLine_rad($r0=>$t0, $r1=>$t1);
}

=head2 addLine_rad

Method to add a line to the graph.

  $obj->addLine_rad(50=>3.14, 75=>3.45);

=cut

sub addLine_rad {
  my $self = shift();
  my $r0=shift();
  my $t0=shift();
  my $r1=shift();
  my $t1=shift();
  my ($x0=>$y0)=$self->_imgxy_rt_rad($r0=>$t0);
  my ($x1=>$y1)=$self->_imgxy_rt_rad($r1=>$t1);
  $self->{'object'}->line($x0, $y0, $x1, $y1, $self->{'color'}->{'black'});
}

=head2 addGeoLine

Method to add a line to the graph.

  $obj->addGeoLine(50=>25, 75=>35);

=cut

sub addGeoLine {
  my $self = shift();
  my $r0=shift();
  my $t0=rad_deg(shift());
  my $r1=shift();
  my $t1=rad_deg(shift());
  return $self->addGeoLine_rad($r0=>$t0, $r1=>$t1);
}

=head2 addGeoLine_rad

Method to add a line to the graph.

  $obj->addGeoLine_rad(50=>3.14, 75=>3.45);

=cut

sub addGeoLine_rad {
  my $self = shift();
  my $r0=shift();
  my $t0=shift();
  my $r1=shift();
  my $t1=shift();
  $t0=PI()/2-$t0;
  $t1=PI()/2-$t1;
  my ($x0=>$y0)=$self->_imgxy_rt_rad($r0=>$t0);
  my ($x1=>$y1)=$self->_imgxy_rt_rad($r1=>$t1);
  $self->{'object'}->line($x0, $y0, $x1, $y1, $self->{'color'}->{'black'});
}

=head2 addArc

Method to add an arc to the graph.

  $obj->addArc(50=>25, 75=>35);

=cut

sub addArc {
  my $self = shift();
  my $r0=shift();
  my $t0=rad_deg(shift());
  my $r1=shift();
  my $t1=rad_deg(shift());
  return $self->addArc_rad($r0=>$t0, $r1=>$t1);
}

=head2 addArc_rad

Method to add an arc to the graph.

  $obj->addArc_rad(50=>3.14, 75=>3.45);

=cut

sub addArc_rad {
  my $self = shift();
  my $r0=shift();
  my $t0=shift();
  my $r1=shift();
  my $t1=shift();
  my $m=($r1-$r0) / ($t1-$t0);
  my $inc=0.02; #is this good?
  my $steps=int(($t1-$t0) / $inc);
  my @array=();
  foreach (0..$steps) {
    my $t=$_ / $steps * ($t1-$t0) + $t0;
    my $r=$r0 + $m * ($t-$t0);
    push @array, [$r=>$t];
  } 
  foreach (1..$steps) {
    $self->addLine_rad(@{$array[$_-1]}, @{$array[$_]});
  }
}

=head2 draw

Method returns a PNG binary blob.

  my $png_binary=$obj->draw;

=cut

sub draw {
  my $self=shift();
  return $self->{'object'}->png;
}

#=head2 _scale
#
#Method returns the parameter scaled to the image.
#
#=cut

sub _scale {
  my $self=shift();
  my $r=shift()||1;
  return $self->_width / 2 / $self->{'radius'} * $r;
}

#=head2 _width
#
#Method returns the width of the graph.
#
#=cut

sub _width {
  my $self=shift();
  return $self->{'size'} - $self->{'border'} * 2;
}

#=head2 _imgxy_xy
#
#Method to convert xy to imgxy cordinates
#
#  $obj->addPoint_rad(50=>3.1415);
#
#=cut

sub _imgxy_xy {
  my $self = shift();
  my $x=shift();
  my $y=shift();
  my $sz=$self->_width;
  $x=$sz/2 + $x;
  $y=$sz/2 - $y;
  return ($x, $y);
}

#=head2 _xy_rt_rad
#
#Method to convert polar cordinate to Cartesian cordinates.
#
#=cut

sub _xy_rt_rad {
  my $self = shift();
  my $r=shift();
  my $t=shift();
  my $x=$r * cos($t);
  my $y=$r * sin($t);
  return ($x, $y);
}

#=head2 _imgxy_rt_rad
#
#Method to convert polar cordinate to Cartesian cordinates.
#
#=cut

sub _imgxy_rt_rad {
  my $self = shift();
  my $r=shift();
  my $t=shift();
  my ($x,$y)=$self->_xy_rt_rad($self->_scale($r), $t);
  return $self->_imgxy_xy($x, $y);
}

1;

__END__

=head1 TODO

=head1 BUGS

Please send to the geo-perl email list.

=head1 LIMITS

addLine method is linear with respect to the XY space.  It is not linear with respace to radius-theta space.

=head1 AUTHOR

Michael R. Davis qw/perl michaelrdavis com/

=head1 LICENSE

Copyright (c) 2006 Michael R. Davis (mrdvt92)

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

GD
Geo::Constants
Geo::Functions
