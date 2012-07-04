#!/usr/bin/perl
use strict;
use Data::Dumper; $Data::Dumper::Indent = 0;

my $line;
my ($chars, $width, $height);
my $D = []; my $Q;
while (chomp($line = <STDIN>)){
    next if ($line eq '++font-text-file');
    if ($line eq '++chars') { chomp( $chars = <STDIN> ); }
    if ($line eq '++width') { chomp( $width = <STDIN> ); }
    if ($line eq '++height'){ chomp( $height = <STDIN> ); }
    
    if ($chars and $width and $height){
        if ($line =~ /^\+\+---(\d\d\d)-0x(..)-'(.?)'-$/){
            my ($dec,$hex,$char) = ($1,$2,$3);
            $D->[$1] = [];
            $Q = $D->[$1];
        } elsif ($line =~ /^([ X]+)$/) {
            my $dots = $1;
            $dots =~ s/ /0/g;
            $dots =~ s/X/1/g;
            push @$Q, split //, $dots;
        }
    }
}

my $i;
for (my $I = 0 ; $I < 256 ; $I++){
    $i = $I + (($I % 2) ? -1 : 1);
#    printf "# %03d\n", $i;
    my @B = @{ $D->[$i] };
    my $B = reverse join '', @B;
    
    #printf "%B = %s\n", $B;
    my $c = 128 - scalar(@B);
    my $eB = ('0' x $c) . $B;
    #print "$eB\n";
    my $H = unpack('H*', pack('B*', $eB));
    #print "$H\n";
    if ($i % 2) {
        printf "INIT_%02x => X\"%s", ($i / 2), $H;
    } else {
        printf "$H\",\n";
    }
}


#for (my $i = 0 ; $i < 256 ; $i++){
#    #printf "# %03d\n", $i;
#    my $B = join '', @{$D->[$i]};
#print length($B);
#    my $H = unpack('H*', pack('B*', $B));
#    #printf "%s\n", $H;
#    printf "INIT_%02x => X\"%s%s\",\n", $i, ('0' x (64 - length($H))), $H;
#}