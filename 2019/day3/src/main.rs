use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::{BufReader, BufRead, Result};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct Point {
    x: i64,
    y: i64,
}

#[derive(Debug)]
struct Segment {
    p1: Point,
    p2: Point,
}

#[derive(Debug)]
struct Wire {
    points: HashMap<Point, u32>
}

impl Wire {
    fn new(input: String) -> Wire {
	let mut x = 0;
	let mut y = 0;
	let mut steps = 1;
	let mut points = HashMap::new();
	points.insert(Point { x: 0, y: 0 }, 0);
	let instructions: Vec<&str> = input.split(',').collect();
	for instruction in instructions {
	    let direction = instruction.chars().next().unwrap();
	    let quantity = &instruction[1..].parse::<i64>().unwrap();
	    match direction {
		'U' => {
		    for y_point in (y+1)..=(y+quantity) {
			points.entry(Point { x: x, y: y_point }).or_insert(steps);
			steps += 1;
		    }
		    y += quantity;
		},
		'D' => {
		    for y_point in ((y-quantity)..y).rev() {
			points.entry(Point { x: x, y: y_point }).or_insert(steps);
			steps += 1;
		    }
		    y -= quantity;
		},
		'L' => {
		    for x_point in ((x-quantity)..x).rev() {
			points.entry(Point { x: x_point, y: y }).or_insert(steps);
			steps += 1;
		    }
		    x -= quantity;
		},
		'R' => {
		    for x_point in (x+1)..=(x+quantity) {
			points.entry(Point { x: x_point, y: y }).or_insert(steps);
			steps += 1;
		    }
		    x += quantity;
		},
		_ => {},
	    }
	}

	Wire{
	    points: points
	}
    }
}

fn manhattan_distance(p1: &Point, p2: &Point) -> i64 {
    (p1.x - p2.x).abs() + (p1.y - p2.y).abs()
}

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    let file = File::open(&args[1])?;
    let mut lines = BufReader::new(file).lines();
    let wire1 = Wire::new(lines.next().unwrap()?);
    let wire2 = Wire::new(lines.next().unwrap()?);

    let mut distances = Vec::<i64>::new();
    let mut steps = Vec::<u32>::new();
    let origin = Point{ x: 0, y: 0 };

    for (point, _) in &wire1.points {
	if wire2.points.contains_key(point) {
	    let distance  = manhattan_distance(&origin, point);
	    if distance != 0 {
		distances.push(distance);
	    }
	    if wire1.points[point] != 0 || wire2.points[point] != 0 {
		steps.push(wire1.points[point] + wire2.points[point]);
	    }
	}
    }
		
    match distances.iter().min_by(|x, y| x.cmp(y)) {
	Some(min) => println!("{} is the clostest manhattan distance", min),
	None      => println!("No intersections were found."),
    };

    match steps.iter().min_by(|x, y| x.cmp(y)) {
	Some(min) => println!("{} is the closest by step", min),
	None      => println!("No intersections were found."),
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn manhattan_distance_test() {
	let p1 = Point { x: 0, y: 0 };
	let p2 = Point { x: 6, y: 6 };
	assert_eq!(manhattan_distance(&p1, &p2), 12);
    }

    #[test]
    fn wire_creation() {
	let wire = Wire::new(String::from("U2,R2,D3"));
	let mut points = HashMap::new();
	points.insert(Point{ x: 0, y: 0 }, 0);
	points.insert(Point{ x: 0, y: 1 }, 0);
	points.insert(Point{ x: 0, y: 2 }, 0);
	points.insert(Point{ x: 1, y: 2 }, 0);
	points.insert(Point{ x: 2, y: 2 }, 0);
	points.insert(Point{ x: 2, y: 1 }, 0);
	points.insert(Point{ x: 2, y: 0 }, 0);
	points.insert(Point{ x: 2, y: -1 }, 0);
	assert_eq!(wire.points, points);
    }
}
