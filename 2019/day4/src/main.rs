use std::env;

fn as_digits(number: u32) -> Vec<u32> {
    let mut remainder = number;
    let mut output = Vec::new();
    while remainder > 0 {
	output.push(remainder % 10);
	remainder = remainder / 10;
    }

    output.reverse();
    output
}

fn main() -> Result<(), std::io::Error> {
    let args: Vec<String> = env::args().collect();
    let lower_bound = &args[1].parse::<u32>().unwrap();
    let upper_bound = &args[2].parse::<u32>().unwrap();
    let mut valid_count = 0;

    for password in *lower_bound..=*upper_bound {
	let mut doubles = false;
	let mut current_run = 1;
	let mut ascending = true;
	let mut prev_digit = None;
	for digit in as_digits(password) {
	    match prev_digit {
		Some(d) => {
		    if digit < d {
			ascending = false;
			break;
		    }
		    if digit == d {
			current_run += 1;
		    } else {
			if current_run == 2 {
			    doubles = true;
			}
			current_run = 1;
		    }
		},
		None => {},
	    }
	    prev_digit = Some(digit);
	}

	if current_run == 2 {
	    doubles = true;
	}

	if doubles && ascending {
	    valid_count += 1;
	}
    }

    println!("{}", valid_count);

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn digit_test() {
	assert_eq!(as_digits(123), vec![1, 2, 3]);
    }
}
