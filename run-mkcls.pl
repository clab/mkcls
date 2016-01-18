#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Temp;
use Cwd qw(getcwd);
my $SCRIPT_DIR; BEGIN { use Cwd qw/ abs_path /; use File::Basename; $SCRIPT_DIR = dirname(abs_path($0)); }
my $MKCLS = "$SCRIPT_DIR/src/mkcls";
die "Can't find $MKCLS ... did you compile it?\n" unless -f $MKCLS;
die "Can't execute $MKCLS ... check permissions.\n" unless -x $MKCLS;

my ($text, $help, $c);
my $n = 2;
my $alg = 'OPT';
if (GetOptions(
  "text=s" => \$text,
  "c=i" => \$c,
  "n=i" => \$n,
  'alg=s' => \$alg,
  "help" => \$help,
) == 0 || @ARGV!=0 || $help || !$text) {
  print_help();
  exit;
}
$alg = uc $alg;
my %valid = qw( OPT 1 ISR 1 TA 1 );
die "Valid algorithms are OPT, ISR, or TA\n" unless $valid{$alg};

die "Can't read corpus from $text\n" unless -f $text;
print STDERR "Reading corpus from $text ...\n";
open F, "<$text" or die "Can't open $text: $!";
my %d;
while(<F>) {
  chomp;
  s/^\s+//;
  s/\s+$//;
  my @words = split /\s+/;
  for my $w (@words) { $d{$w}++; }
}
close F;
my $vsize = scalar keys %d;
die "File was empty\n" if $vsize == 0;
my $srvsize = int(sqrt($vsize));
if ($srvsize != sqrt($vsize)) {
  $srvsize += 1;
}
print STDERR "|V| = $vsize\n";
print STDERR "sqrt(|V|) = $srvsize\n";
$c = $srvsize unless $c;
print STDERR "c = $c\n";
die "c ($c) must be less than the vocab size ($vsize)\n" unless $c < $vsize;
#./mkcls -c101 -n10 -ptrain.txt -Vout ISR

my $cmd = "$MKCLS -c$c";
$cmd .= " -n$n" unless ($alg eq 'TA');
my $ofn = get_temp_filename();
$cmd .= " -p$text -V$ofn $alg";

print STDERR "Running: $cmd\n";
my $o = `$cmd`;
print STDERR "$o\n";
die "command failed: $?" unless $? == 0;
print STDERR "mkcls succeeded.\n";
open F, "<$ofn" or die "Can't read mkcls output $ofn: $!";
my %c2w = ();
my $lc = 0;
while(<F>) {
  chomp;
  my ($w, $c) = split /\s+/;
  $c--;
  $c2w{"$c"}->{$w} = 1;
  $lc++;
}
close F;
unlink $ofn or warn "Failed to remove $ofn: $!";
if ($lc != $vsize) {
  print STDERR "[WARNING] mkcls output has different number of types than vocab size\n";
}
for my $c (sort {$a <=> $b} keys %c2w) {
  my $rw = $c2w{$c};
  my $tc = 0;
  for my $w (sort {$d{$b} <=> $d{$a}} keys %$rw) {
    print "C$c\t$w\t$d{$w}\n";
    $tc++;
  }
  print STDERR "Cluster C$c has $tc type(s)\n";
}
print STDERR "Done.\n";

sub print_help {
  print STDERR <<EOT
Usage: $0 --text file.txt [--c NUM_CLASSES] [--alg {TA,OPT,ISR}] [--n N] > output.txt

 * If --c is unspecified sqrt(|V|) will be used.

 * --alg determines the algorithm. OPT is default.
   ISR is the best, but slow, OPT is second best, TA is fastest.

 * OPT and ISR run depend on --n to control the number of restarts.
   n=2 is default, larger n get much slower

EOT
}

sub get_temp_filename {
    my $fh = File::Temp->new(
        TEMPLATE => 'tempXXXXX',
        SUFFIX   => '.txt',
    );

    return $fh->filename;
}

