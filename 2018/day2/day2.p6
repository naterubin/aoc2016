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

sub id_difference(Str $id_one, Str $id_two) {
    my $difference = 0;

    for $id_one.comb.kv -> $i, $c {
        if ($id_two.comb[$i] ne $c) {
            $difference++;
        }
    }

    return $difference;
}

sub id_common_letters(Str $id_one, Str $id_two) {
    my @common_letters;

    for $id_one.comb.kv -> $i, $c {
        if ($id_two.comb[$i] eq $c) {
            @common_letters.append($c);
        }
    }

    return @common_letters.join;
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

    say "Checksum: $($threes * $twos)";

    SCAN: for $input_file.IO.lines.kv -> $i, $line {
        for $input_file.IO.lines.kv -> $j, $line2 {
            if ($i != $j) {
                my $difference = id_difference($line, $line2);

                if ($difference == 1) {
                    say "Correct IDs: $line $line2";
                    say "Common letters: $(id_common_letters($line, $line2))";
                    last SCAN;
                }
            }
        }
    }
}
