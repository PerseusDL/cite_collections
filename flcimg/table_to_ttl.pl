#!/usr/bin/perl

use strict;
use Text::CSV;
use Text::CSV::Encoded;
use Encode;
use Data::Dumper;

my $file = $ARGV[0];

unless ($file && -f $file ) { 
   print "Usage: $0 <input file>\n";
   exit 1;
}

my $csv = Text::CSV::Encoded->new({ encoding_in => "UTF-8", encoding_out => "UTF-8", binary => 1, eol => $/});

my %image_versions;
my %images;
open my $io, "<", $file or die "$file: $!\n";
while (my $row = $csv->getline ($io)) {
    my @fields = @$row;
    my $urn = $fields[0];
    my @works = ();
    my @translations = ();
    @works = split /,/, $fields[8]; 
    @translations = map { my $tran = $_; $tran =~ s/perseus-lat1/perseus-eng1/; $tran; } @works; 
    next unless $urn =~ /urn:cite/;
    my $rights = $fields[2];
    my $caption = join " ", ($fields[4], $fields[3])  ;
    # urn:cite:ns:coll.n.v
    my @urn_parts = split /\./, $urn;
    my $urn_no_ver = join ".", @urn_parts[0..1];
    my $collection = $urn_parts[0];
    my $ver = 0;
    if (scalar @urn_parts > 2) {
        $ver =  $urn_parts[2];
    }
    if (! exists $image_versions{$urn_no_ver}) {
        $image_versions{$urn_no_ver} = 0;
    } 
    if ($ver >= $image_versions{$urn_no_ver}) {
        my $img =join ",", (qq!"$urn_no_ver"!,qq!"$caption"!,qq!"$rights"!);
        $image_versions{$urn_no_ver} = $ver;
        $images{$urn_no_ver} = { 
            'caption' => $caption, 
            'collection' => $collection,
            'rights' => $rights,
            'work' => \@works,
            'translation' => \@translations };
    }
}

print <<"EOS";
\@prefix hmt:        <http://www.homermultitext.org/hmt/rdf/> .
\@prefix cite:        <http://www.homermultitext.org/cite/rdf/> .
\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
\@prefix crm: <http://www.cidoc-crm.org/cidoc-crm/>.
<urn:cite:perseus:flcimg> rdf:type cite:ImageArchive .
<urn:cite:perseus:flcimg> rdf:label "Perseus Digital Library images of the Forest Law Compendium Manuscript." .
<urn:cite:perseus:flcimg> hmt:path "/usr/local/perseus/collections/images/flcimg" .
EOS

foreach my $key (sort keys %images) {
    
    print qq!<$key> cite:belongsTo <$images{$key}{'collection'}> .\n!;
    print qq!<$images{$key}{'collection'}> cite:possesses <$key> .\n!;
    print qq!<$key> rdf:label "@{[encode("UTF-8",$images{$key}{'caption'})]}" .\n!;
    print qq!<$key> cite:license "@{[encode("UTF-8",$images{$key}{'rights'})]}" .\n!;
    if (@{$images{$key}{'work'}}) {
        foreach my $work (@{$images{$key}{'work'}}) {
            print qq!<$work> crm:P138i_has_representation <$key> .\n!;
        }
    }
    if (@{$images{$key}{'translation'}}) {
        foreach my $translation (@{$images{$key}{'translation'}}) {
            print qq!<$translation> crm:P138i_has_representation <$key> .\n!;
        }
    }
}
