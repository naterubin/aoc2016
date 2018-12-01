sub MAIN(Str $input_file) {
    my $freq = 0;

    for $input_file.IO.lines -> $line {
        $freq += Int($line);
    }

    say $freq;
}
