sub loop_through_file(Str $input_file, $freq is rw, %prev_freqs) returns Bool {
    for $input_file.IO.lines -> $line {
        $freq += Int($line);

        if (%prev_freqs{$freq}) {
            say "First dup: $freq";
            return True;
        } else {
            %prev_freqs{$freq} += 1;
        }
    }

    return False;
}

sub MAIN(Str $input_file, Bool $part2 = False) {
    my $freq = 0;
    my %prev_freqs = ();
    my $dup_found = False;

    for -200_000 .. 200_000 {
        %prev_freqs{$_} = 0;
    }

    loop {
        $dup_found = loop_through_file($input_file, $freq, %prev_freqs);

        if ($dup_found or !$part2) {
            last;
        }
    }

    say "End freq: $freq";
}
