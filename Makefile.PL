use ExtUtils::MakeMaker;
WriteMakefile(
  NAME      => q{GD::Graph::Polar},
  VERSION_FROM => q{lib/GD/Graph/Polar.pm},
  PREREQ_PM => {
                 strict            => 0,
                 vars              => 0,
                 GD                => 0,
                 Geo::Constants    => 0.04,
                 Geo::Functions    => 0.03,
                #Graphics::ColorNames => 0, #no longer required but nice to have
               },
               ($] >= 5.005 ? 
                 (
                   ABSTRACT_FROM => 'lib/GD/Graph/Polar.pm',
                 ) : ()
               )
             );
