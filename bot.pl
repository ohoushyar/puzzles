#!/usr/bin/perl

# Head ends here
sub next_move(\$\$\@) {
    #add logic here
    my($posx, $posy, $board) = @_;

    my @cells = split('', $board->[$$posx]);
    if ($cells[$$posy] eq 'd') {
        print 'CLEAN';
        return
    }
    if ( $$posx % 2 == 0 ) {
        if ( $$posy == 4 ) {
            print 'DOWN';
            return;
        }
        print 'RIGHT';
        return
    }
    if ( $$posx % 2 == 1 ) {
        if ( $$posy == 0 ) {
            print 'DOWN';
            return;
        }
        print 'LEFT';
        return
    }
}

# Tail starts here
#player id input
my @board;
my $pos = <>;
chomp($pos);
for ($i=0;$i<1;$i++) {
    $board[$i] = <>;
}
@pos = split(' ',$pos);
next_move($pos[0], $pos[1], @board);
