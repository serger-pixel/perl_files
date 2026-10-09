sub print_tree {
    my ($node, $level, $out) = @_;
    
    my $spacing = " " x $level;
    if (-f $node) {
        print {$out} "$spacing- $node\n";
    }
    elsif (-d $node) {
        print {$out} "$spacing+ $node\n";

        opendir(my $dh, $node) or do {
            warn "Невозможно открыть $node: $!";
            return;
        };

        my @entries = readdir($dh);
        closedir($dh);

        for my $entry (sort @entries) {
            next if $entry eq "." || $entry eq "..";
            
            print_tree("$node/$entry", $level + 1, $out);
        }
    }
}

sub main {
    print "Введите имя каталога, который вы хотите вывести: \n";
    my $dir = <>;
    chomp $dir;   

    print "Как вы хотите выводить\n";
    print "1. Вывод в консоль\n";
    print "2. Вывод в файл\n";

    my $choice = <>;
    chomp $choice;

    if ($choice == 1) {
        print_tree($dir, 0, \*STDOUT);
    }
    elsif ($choice == 2) {
        print "Введите имя файла, в который вы хотите выводить: \n";
        my $file = <>;
        chomp $file;

        open(my $fh, ">", $file) or die "Не удалось открыть файл '$file': $!";
        
        print_tree($dir, 0, $fh);
        close($fh);
    }
}

main();