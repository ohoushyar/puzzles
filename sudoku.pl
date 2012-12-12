#!/usr/bin/env perl

use 5.17.0;
use DDP colored => 1;

my $puzzle = <<_DATA_;
0 0 0 0 0 0 0 0 0
0 0 8 0 0 0 0 4 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 6 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
2 0 0 0 0 0 0 0 0
0 0 0 0 0 0 2 0 0
0 0 0 0 0 0 0 0 0
_DATA_


my ($board, $free) = init($puzzle);
my @stack;
my @not_allowed = ();
my %bad = ();

my $prev;
my $current = {
    prev => $prev,
};

#p %board;


# Get a random position
while (my $rpos = pop @{$free}) {

    my $found = 0;

    VALUE:
    foreach my $x (1..9) {
        next if exists $current->{next}->{$x} and $current->{next}->{$x} == -1;
        if (is_allowed($x, $rpos, $board)) {
            say "ok pos: $rpos, value: $x";
            $current->{pos} = $rpos;
            $board->{$rpos} = $x;
#            print p $current;
            $found = 1;

            $prev = $current;
            $current = {
                prev => $prev,
            };
            $prev->{next}->{$x} = $current;
            last VALUE;
        } else {
            $current->{next}->{$x} = -1;
        }
    }

    unless ($found) {
        say "pos: $rpos";
        say 'back';
        # print p $current;

        $DB::single=1;
        $board->{$rpos} = 0;


        if ($prev) {
            BAD:
            for my $bad (keys %{$prev->{next}}) {
                if ( scalar $current == scalar $prev->{next}->{$bad} ) {
                    $prev->{next}->{$bad} = -1;
                    say "bad: $bad";
                    last BAD;
                }
            }
            $current = $prev;
        } else {
            say 'idontknow';
        }
        push @{$free}, $rpos;
        $rpos = $current->{pos};
        $prev = $current->{prev};

        goto VALUE;
    }

    show($board) unless $found;
}

show($board);

# Get another if it's occupied
# Check if it's allowed


say 'Done.';

sub init {
    my $puzzle = shift;

    my ($i, $j) = (0, 0);
    my (%board, @free);

    map {
        map {
            $board{"$i$j"} = $_;
            $j += 1;
        } split(/\s/);
        $i += 1;
        $j = 0;
    } split("\n", $puzzle);

    map { push @free, $_ if !$board{$_} } keys %board;

    return (\%board, \@free);
}

sub is_allowed {
    my ($x, $pos, $board) = @_;

    my ($i, $j) = split('', ''.$pos);
    my (@r, @c, @g);

    map {
        push @r, $board->{"$i$_"};
        push @c, $board->{"$_$j"};
        my $row = $_;
        map {
            push @g, $board->{"$row$_"} if (int $j/3) ==  (int $_/3);
        } (0..8) if (int $i/3) == (int $row/3);
    } (0..8);

    return if (grep($_==$x, @r) || grep($_==$x, @c) || grep($_==$x, @g));

    return 1;
}

sub show {
    my $board = shift;

    for my $i (0..8) {
        for my $j (0..8) {
            print $board->{"$i$j"}, ' ';
        }
        print "\n";
    }
}
