sub delete_files {
    my ($node, $level, $file_type, $out) = @_;
    
    my $spacing = " " x $level;
    if (-f $node) {
        my $current_type = substr($node, -(length($file_type) + 1));
        print $current_type;
        if ($current_type eq ".$file_type") {
            unlink $node;
            print {$out} "$spacing- $node (Удален)\n"
        }
        else {
            print {$out} "$spacing- $node\n";
        }
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
            
            delete_files("$node/$entry", $level + 1, $file_type, $out);
        }
    }
}


sub main {
    print "Введите директорию: \n";
    my $dir = <>;
    chomp $dir;

    print "Введите расширение файлов для удаления: \n";
    my $file_type = <>;
    chomp $file_type;

    delete_files($dir, 0, $file_type, STDOUT);
}

main()