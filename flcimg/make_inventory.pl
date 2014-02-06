#!/usr/bin/perl
use strict;

my %mappings = (
    1 => [21,36],
    2 => [37,45],
    3 => [45,55],
    4 => [55,78],
    5 => [79,126],
    6 => [126,138],
    7 => [139,229],
    8 => [229,232],
    9 => [232,242],
    10 => [242,248],
    11 => [248,251],
    12 => [251,253],
    13 => [254,257],
    14 => [257,260],
    15 => [260,263],
    16 => [263,271],
    17 => [272,274],
    18 => [274,275],
    19 => [275,278],
    20 => [276,279],
    21 => [292,308],
    22 => [308,316],
    23 => [316,322],
    24 => [322,325],
    25 => [325,328],
    26 => [328,340]
);

    print join "\t", qw(urn image_name rights caption description creator date folio_page contains_urn edited_by);
    print "\n";
for (my $i=1; $i < 346; $i++) {
    my $urn = "urn:cite:perseus:flcimg.$i.1";
    my @cts = ();
    foreach my $k (sort {$a <=> $b } keys %mappings) {
        if ($i >= $mappings{$k}[0] && $i <= $mappings{$k}[1]) {
            push @cts, "urn:cts:pdlmc:cdf.flc.perseus-lat1:$k";
        }
    }
    my $cts = join '-', @cts;
    my $file = "LAW." . sprintf("%03d", $i) . ".tif";
    print join "\t", map {qq!"$_"!} 
        ($urn,$file,'Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.','','','Tisch Library, Tufts University','2013-10-01',$i,$cts,'Bridget Almas <balmas@gmail.com>');
    print "\n";
}
