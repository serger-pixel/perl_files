use strict;
use warnings;

sub copy_dir {
    my ($current_from, $current_to) = @_;

    print STDERR "from=[$current_from] to=[$current_to]\n";

    if (-f $current_from) {
        my $slash_pos = rindex($current_from, "/");
        my $current_file_name = substr($current_from, $slash_pos + 1);
        my $target = "$current_to/$current_file_name";

        open(my $in, "<", $current_from)
            or do { warn "Не могу открыть $current_from: $!"; return; };

        open(my $out, ">", $target)
            or do { warn "Не могу создать $target: $!"; close($in); return; };

        while (my $line = <$in>) {
            print {$out} $line;
        }

        close($in);
        close($out);
    }

    elsif (-d $current_from) {
        my $slash_pos = rindex($current_from, "/");
        my $dir_name;
        if ($current_from eq ".") {
            $dir_name = "";
        }
        elsif ($slash_pos >= 0) {
            $dir_name = substr($current_from, $slash_pos + 1);
        } else {
            $dir_name = $current_from;
        }

        $current_to = "$current_to/$dir_name";

        unless (-d $current_to) {
            mkdir $current_to, 0755
                or warn "Не удалось создать каталог $current_to: $!";
        }

        opendir(my $dh, $current_from) or do {
            warn "Не могу открыть $current_from: $!";
            return;
        };
        my @entries = readdir($dh);
        print(@entries);
        closedir($dh);

        for my $entry (sort @entries) {
            next if $entry eq "." || $entry eq "..";
            copy_dir("$current_from/$entry", $current_to);
        }
    }
}

print "Откуда: ";
my $from = <STDIN>;
unless (defined $from) { warn "Ввод прерван.\n"; exit 1; }
chomp $from;

print "Куда: ";
my $to = <STDIN>;
unless (defined $to) { warn "Ввод прерван.\n"; exit 1; }
chomp $to;

if ($from eq '' || $to eq '') {
    warn "Пустой путь, отмена.\n";
    exit 1;
}

unless (-e $from) {
    warn "Источник не существует: $from\n";
    exit 1;
}

copy_dir($from, $to);
print "\nГотово.\n";
