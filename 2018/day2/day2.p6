sub character_counts(Str $box_id) {
    my %counts;

    for $box_id.comb -> $c {
        if (!%counts{$c}) {
            %counts{$c} = 1;
        } else {
            %counts{$c}++;
        }
    }

    return %counts;
}

sub MAIN(Str $input_file) {
    my $threes = 0;
    my $twos   = 0;

    for $input_file.IO.lines -> $line {
        my %counts = character_counts($line);
        if (3 (elem) %counts.values) {
            $threes++;
        }
        if (2 (elem) %counts.values) {
            $twos++;
        }
    }

    say $threes * $twos;
}
