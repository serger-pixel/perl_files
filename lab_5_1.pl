$FILE = undef;


open($FILE,  "> ./hanot.txt");

my %kernel;

sub print_state {
    print FILE "Состояние стержней:\n";
    for my $name (A, B, C) {
        my @disks = @{ $kernel{$name} };
        printf FILE "  %s: [%s]\n", $name, join(", ", @disks);
    }
    print "\n";
}

sub hanoi {
    my ($n, $from, $to, $temp) = @_;
    if ($n == 0) {
        return;
    }

    hanoi($n - 1, $from, $temp, $to);

    my $disk = pop @{ $kernel{$from} };
    push @{ $kernel{$to} }, $disk;
    printf FILE "Ход: диск %d: %s -> %s\n", $disk, $from, $to;

    print_state();

    hanoi($n - 1, $temp, $to, $from);
}

print "Введите количество дисков N: ";
chomp(my $n = <STDIN>);

if ($n <= 0) {
    print "N должно быть положительным целым числом!\n";
    exit 1;
}

$kernel{A} = [ reverse(1 .. $n) ];
$kernel{B} = [];
$kernel{C} = [];

print FILE "\nНачальное состояние:\n";
print_state();

print FILE "Решение для $n дисков:\n\n";
hanoi($n, 'A', 'C', 'B');

close(FILE);
