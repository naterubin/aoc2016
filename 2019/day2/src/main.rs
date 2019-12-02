use std::env;
use std::fs::File;
use std::io::{prelude::*, self};
use std::ops::Index;
use std::vec::Vec;

struct Program {
    tape: Vec<i32>,
    pos: usize,
}

impl Program {
    fn new(tape: Vec<i32>) -> Self {
	Program {
	    tape: tape,
	    pos: 0,
	}
    }

    fn current_opcode(&self) -> i32 {
	self.tape[self.pos]
    }

    fn execute_opcode(&mut self) {
	match self.current_opcode() {
	    1 => {
		let a = self[self[self.pos + 1] as usize];
		let b = self[self[self.pos + 2] as usize];
		let dest = self[self.pos + 3];
		self.tape[dest as usize] = a + b;
	    },
	    2 => {
		let a = self[self[self.pos + 1] as usize];
		let b = self[self[self.pos + 2] as usize];
		let dest = self[self.pos + 3];
		self.tape[dest as usize] = a * b;
	    },
	    _ => {},
	}
    }

    fn run(&mut self) -> i32 {
	while self.current_opcode() != 99 {
	    self.execute_opcode();
	    self.pos += 4;
	}

	self[0]
    }
}

impl Index<usize> for Program {
    type Output = i32;

    fn index(&self, i: usize) -> &Self::Output {
	&self.tape[i]
    }
}

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    let mut file = File::open(&args[1])?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    let original_prog: Vec<i32> = contents.split(',')
	.map(|x| x.parse::<i32>())
	.filter_map(Result::ok)
	.collect();

    let mut noun = 0;
    let mut verb = 0;
    let mut output = 0;

    while output != 19690720 {
	if noun == 99 {
	    noun = 0;
	    verb += 1;
	} else {
	    noun += 1;
	}
	
	let mut prog = Program::new(original_prog.clone());

	prog.tape[1] = noun;
	prog.tape[2] = verb;

	output = prog.run();
    }

    println!("{} {}", noun, verb);

    Ok(())
}
