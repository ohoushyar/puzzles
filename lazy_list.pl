use Test::Most;

package LazyList;

use Mo;

has 'value';
has 'rest';

sub nth {
    my $self = shift;
    my $n = shift;
    return $n <= 1 ? $self->value : $self->rest->()->nth($n-1);
}

package main;

sub integers {
    my $n = shift;
    return LazyList->new(
        value => $n,
        rest => sub { integers($n+1) },
    );
}

sub factorials {
    my $n = shift;
    return LazyList->new(
        value => ($n <= 1) ? 1 : $n * factorials($n-1)->value,
        rest => sub { factorials($n+1) },
    );
}

my $list = integers(101);
is $list->nth(10), 110, 'got the value of 10th element from initial list';

my $flist = factorials(5);
is $flist->nth(3), 5040, 'got the factorial of 5th elements';


done_testing();

1;
