package Inventory;

require Exporter;
@ISA = qw(UNIVERSAL Exporter);
@EXPORT = qw(new DESTROY put_out compare get_id get_name);

sub new {
    my $classname = shift;
    my $self = {};
    $self->{CLASSNAME} = $classname;
    $self->{INV_ID} = shift;
    $self->{NAME} = shift;
    $self->{TYPE} = shift;
    $self->{QUANTITY} = shift;
    $self->{PRICE} = shift;
    $self->{LOCATION} = shift;
    $self->{DATE} = shift;
    bless $self, $classname;
    return $self;
}

sub DESTROY {
    my ($ref) = @_;
    $ref->SUPER::DESTROY;
}

sub put_out {
    my ($ref) = @_;
    printf "%-10s %-25s %-15s %6s %10s %-12s %-12s\n",
        $ref->{INV_ID},
        $ref->{NAME},
        $ref->{TYPE},
        $ref->{QUANTITY},
        $ref->{PRICE},
        $ref->{LOCATION},
        $ref->{DATE};
}

sub compare {
    my ($obj1, $obj2) = @_;
    if ($obj1->{PRICE} < $obj2->{PRICE}) {
        return -1;
    }
    elsif ($obj1->{PRICE} == $obj2->{PRICE}) {
        return 0;
    }
    else {
        return 1;
    }

}

sub get_id {
    my $ref = shift;
    return $ref->{INV_ID};
}

sub get_name {
    my $ref = shift;
    return $ref->{NAME};
}
 