use lib "/home/sergey/studing/pvs/lab_4/";
use Inventory;

my $head = undef;

sub insert {
    my ($current, $obj) = @_;
    my $id = $obj->{INV_ID};

    
    if (!defined $current || $id lt $current->{INFO}{INV_ID}) {
        return {
            INFO => $obj,
            NEXT => $current,
        };
    }

 
    if ($id eq $current->{INFO}{INV_ID}) {
        print "Элемент с инвентарным номером $id уже есть в списке!\n";
        return $current;
    }


    $current->{NEXT} = insert($current->{NEXT}, $obj);
    return $current;
}


sub delete_item {
    my ($current, $id) = @_;

    if (!defined current) {
        print "Элемент с инвентарным номером $id не найден!\n";
        return;
    }

    if ($current->{INFO}->{INV_ID} eq $id) {
        return $current->{NEXT};
    }

    $current->{NEXT} = delete_item($current->{NEXT}, $id);
    return $current;
}


sub list_print {
    my ($current) = @_;
    if (!defined $current) {
        return;
    };

    $current->{INFO}->put_out;
    list_print($current->{NEXT});
}


sub find_item {
    my ($current, $id) = @_;
    if (!defined $current) {
        return;
    }

    else 
    {
        if ($current->{INFO}{INV_ID} == $id) {
            return $current;
        }
        else {
            return find_item($current->{NEXT}, $id);
        }
    }
  
}

sub print_header {
    print "=" x 100, "\n";
    printf "%-10s %-25s %-15s %6s %10s %-12s %-12s\n",
        'Инв. №', 'Наименование', 'Тип', 'Кол-во', 'Цена', 'Расположение', 'Дата';
    print "=" x 100, "\n";
}


sub show_menu {
    print "\n";
    print "=" x 40, "\n";
    print "  МЕНЮ УПРАВЛЕНИЯ ИНВЕНТАРЁМ\n";
    print "=" x 40, "\n";
    print "  1. Добавить элемент\n";
    print "  2. Удалить элемент\n";
    print "  3. Показать весь список\n";
    print "  4. Найти элемент по инв. номеру\n";
    print "  5. Сравнить два элемента\n";
    print "  0. Выход\n";
    print "=" x 40, "\n";
    print "Ваш выбор: ";
}


sub input_object {
    print "Введите инвентарный номер: ";
    chomp(my $id = <STDIN>);
    print "Введите наименование: ";
    chomp(my $name = <STDIN>);
    print "Введите тип: ";
    chomp(my $type = <STDIN>);
    print "Введите количество: ";
    chomp(my $qty = <STDIN>);
    print "Введите цену за единицу: ";
    chomp(my $price = <STDIN>);
    print "Введите местонахождение: ";
    chomp(my $loc = <STDIN>);
    print "Введите дату постановки на учёт: ";
    chomp(my $date = <STDIN>);

    return new Inventory($id, $name, $type, $qty, $price, $loc, $date);
}


my $choice;
do {
    show_menu();
    chomp($choice = <STDIN>);

    if ($choice == 1) {
        my $obj = input_object();
        $head = insert($head, $obj);

    } elsif ($choice == 2) {
        print "Введите инвентарный номер для удаления: ";
        chomp(my $id = <STDIN>);
        $head = delete_item($head, $id);
        print "Операция удаления завершена.\n";

    } elsif ($choice == 3) {
        if (!defined $head) {
            print "Список пуст.\n";
        } else {
            print_header();
            list_print($head);
            print "=" x 100, "\n";
        }

    } 
    elsif ($choice == 4) {
        print "Введите инвентарный номер для поиска: ";
        chomp(my $id = <STDIN>);
        my $found = find_item($head, $id);
        if (defined $found) {
            print_header();
            $found->{INFO}->put_out;
            print "=" x 100, "\n";
        } else {
            print "Элемент с номером $id не найден.\n";
        }
    } 

    elsif ($choice == 5) {
        print "Введите первый номер объекта: ";
        chomp(my $id = <STDIN>);
        my $is_found = 0;
        my $first = find_item($head, $id);
        if (defined $first) {
            print_header();
            $first->{INFO}->put_out;
            print "=" x 100, "\n";
            $is_found = 1;
        } else {
            print "Элемент с номером $id не найден.\n";
        }

        my $second = undef;

        if ($is_found == 1) {
            print "Введите второй номер объекта: ";
            chomp(my $id = <STDIN>);
            my $second = find_item($head, $id);
            if (defined $second) {
                $second->{INFO}->put_out;
                print "=" x 100, "\n";
            } else {
                $is_found = 0;
                print "Элемент с номером $id не найден.\n";
            }
        }

        if ($is_found == 1) {
            my $result = $first->{INFO}->compare($second->{INFO});
            if ($result == -1) {
                print "Первый объект меньше по цене, чем второй";
            }

            elsif ($result == 0) {
                print "Первый элемент равен по цене второму";
            }

            else {
                print "Первый объект больше по цене, чем второй";
            }
        }

    }

    elsif ($choice == 6) {
        print "Введите первый инвентарный номер: ";
        chomp(my $id1 = <STDIN>);
        print "Введите второй инвентарный номер: ";
        chomp(my $id2 = <STDIN>);
        my $o1 = find_item($head, $id1);
        my $o2 = find_item($head, $id2);
        if (defined $o1 && defined $o2) {
            my $r = Inventory::compare($o1, $o2);
            if ($r < 0) {
                print "$id1 < $id2\n";
            } elsif ($r == 0) {
                print "$id1 = $id2\n";
            } else {
                print "$id1 > $id2\n";
            }
        } else {
            print "Один или оба элемента не найдены.\n";
        }
    }

} while ($choice != 0);

print "Работа программы завершена.\n";