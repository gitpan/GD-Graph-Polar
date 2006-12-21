package GD::Graph::Polar;

=head1 NAME

GD::Graph::Polar - Make Polar chart from GD

=head1 SYNOPSIS

  use GD::Graph::Polar;
  my $obj=GD::Graph::Polar->new(size=>480, radius=>100);
  $obj->addPoint        (50=>24);
  $obj->addPoint_rad    (50=>3.1415);
  $obj->addGeoPoint     (75=>25);
  $obj->addGeoPoint_rad (75=>3.1415);
  #$obj->addLine($r0=>$t0, $r1=>$t1, $r2=>$t2, ...); #TODO
  print $obj->image;

=head1 DESCRIPTION

=cut

use strict;
use vars qw($VERSION);
use Geo::Constants qw{PI};
use Geo::Functions qw{rad_deg};
use GD;

$VERSION = sprintf("%d.%02d", q{Revision: 0.01} =~ /(\d+)\.(\d+)/);

=head1 CONSTRUCTOR

=head2 new

The new() constructor.

  my $obj = GD::Graph::Polar->new();

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
  $self->{'border'}=$param->{'border'} || 3;
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

  $self->{'object'}->line($self->{'size'}/2, $self->{'border'}, $self->{'size'}/2, $self->{'size'}-$self->{'border'}, $self->{'color'}->{'gray'});
  $self->{'object'}->line($self->{'border'}, $self->{'size'}/2, $self->{'size'}-$self->{'border'}, $self->{'size'}/2, $self->{'color'}->{'gray'});

}

sub _width {
  my $self=shift();
  return $self->{'size'} - $self->{'border'} * 2;
}

=head2 addPoint

Method to add a point to the graph.

=cut

sub addPoint {
  my $self = shift();
  my $r=shift();
  my $t=rad_deg(shift());
  return $self->addPoint_rad($r,$t);
}

=head2 addPoint_rad

Method to add a point to the graph.

=cut

sub addPoint_rad {
  my $self = shift();
  my $r=shift();
  my $t=shift();
  my $sz=$self->{'size'};
  my $scale=$self->_width/2/$self->{'radius'};
  my $x=$sz/2 + $r * $scale * cos($t);
  my $y=$sz/2 - $r * $scale * sin($t);
  my $icon=7;
  $self->{'object'}->arc($x,$y,$icon,$icon,0,360,$self->{'color'}->{'black'});
}

=head2 addGeoPoint

Method to add a point to the graph.

=cut

sub addGeoPoint {
  my $self = shift();
  my $r=shift();
  my $t=rad_deg(shift());
  return $self->addGeoPoint_rad($r,$t);
}

=head2 addGeoPoint_rad

Method to add a point to the graph.

=cut

sub addGeoPoint_rad {
  my $self = shift();
  my $r=shift();
  my $t=shift();
  $t=PI()/2-$t;
  return $self->addPoint_rad($r,$t);
}

=head2 image


=cut

sub image {
  my $self=shift();
  return $self->{'object'}->png;
}

1;

__END__

=head1 TODO

=head1 BUGS

Please send to the geo-perl email list.

=head1 LIMITS

=head1 AUTHOR

Michael R. Davis qw/perl michaelrdavis com/

=head1 LICENSE

Copyright (c) 2006 Michael R. Davis (mrdvt92)

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO
