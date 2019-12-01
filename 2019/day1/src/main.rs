use std::env;
use std::fs::File;
use std::io::{Result, BufRead, BufReader};
use std::vec::Vec;

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    let file = File::open(&args[1])?;
    let reader = BufReader::new(file);
    let mut fuel_reqs = Vec::new();

    for line in reader.lines() {
	let mut fuel = (line?.parse::<i32>().unwrap() / 3) - 2;
	let mut additional_fuel = fuel / 3 - 2;
	while additional_fuel > 0 {
	    fuel += additional_fuel;
	    additional_fuel = additional_fuel / 3 - 2;
	}
	fuel_reqs.push(fuel);
    }

    let total = fuel_reqs.iter().fold(0, |acc, mass| acc + mass);
    println!("Total fuel: {}", total);

    Ok(())
}
