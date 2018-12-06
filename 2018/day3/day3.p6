class Claim {
    has Int $.id;
    has Int $.min_x;
    has Int $.min_y;
    has Int $.max_x;
    has Int $.max_y;

    method in_claim(Int $x, Int $y) returns Bool {
        my $x_intersect = ($x >= $!min_x and $x <= $!max_x);
        my $y_intersect = ($y >= $!min_y and $y <= $!max_y);
        return ($x_intersect and $y_intersect);
    }
}

grammar ClaimRecord {
    rule  TOP    { '#'<id> '@' <offset>':' <dims> }
    token id     { \d+ }
    token offset { <x>','<y> }
    token dims   { <x>'x'<y> }
    token x      { \d+ }
    token y      { \d+ }
}

class ClaimRecord-actions {
    method TOP($/) {
        make Claim.new(
            id    => $/<id>.Int,
            min_x => $/<offset><x>.Int,
            min_y => $/<offset><y>.Int,
            max_x => $/<offset><x>.Int + $/<dims><x>.Int - 1,
            max_y => $/<offset><y>.Int + $/<dims><y>.Int - 1
        );
    }
}

sub MAIN($input_file) {
    my @claims;

    for $input_file.IO.lines -> $line {
        my $match = ClaimRecord.parse($line, actions => ClaimRecord-actions.new);
        @claims.append($match.made);
    }

    my $bottom_x = 0;
    my $bottom_y = 0;
    for @claims -> $claim {
        if ($claim.max_x > $bottom_x) {
            $bottom_x = $claim.max_x;
        }
        if ($claim.max_y > $bottom_y) {
            $bottom_y = $claim.max_y;
        }
    }

    my $doubled_squares = 0;
    for 0..^$bottom_x -> $x {
        Y_LOOP: for 0..^$bottom_y -> $y {
            my $exists_in = 0;
            for @claims -> $claim {
                if ($claim.in_claim($x, $y)) {
                    $exists_in++;
                }

                if ($exists_in >= 2) {
                    $doubled_squares++;
                    next Y_LOOP;
                }
            }
        }
    }

    say "$doubled_squares appear at least twice.";
}
