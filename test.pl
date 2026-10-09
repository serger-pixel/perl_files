
%cntStrInput = {};

$FILE = undef;

open(FILE, "< test.txt") or die ("Не удается открыть файл!\n");
while ($line = <FILE>) {
    if (exists $cntStrInput{$line}){
        $cntStrInput{$line} ++;
    }
    else {
        $cntStrInput{$line} = 1;
    }
}

foreach $key (keys %cntStrInput) {
    print ("Строка $key встретилась $cntStrInput{$key} раз\n")
}
close FILE;