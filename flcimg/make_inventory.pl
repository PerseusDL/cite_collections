#!/usr/bin/perl

use strict;

    print join "\t", qw(urn image_name rights caption description creator date folio_page contains_urn edited_by);
    print "\n";
for (my $i=1; $i < 346; $i++) {
    my $urn = "urn:cite:perseus:flcimg.$i.1";
    my $file = "LAW." . sprintf("%03d", $i) . ".tif";
    print join "\t", map {qq!"$_"!} 
        ($urn,$file,'Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.','','','Tisch Library, Tufts University','2013-10-01',$i,'','Bridget Almas <balmas@gmail.com>');
    print "\n";
}
