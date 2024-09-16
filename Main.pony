use "collections"
use "math"

actor First
  let _env: Env            // Environment variable
  let _total: USize        // Total number of elements to be processed
  let _cs: USize           // (_cs=Chunk_Size) Chunk size used for dividing the work
  let _procs: Array[Second]// Array of worker actors (Second) for parallel processing

  // Constructor for the First actor
  new create(env: Env, n: USize, k: USize) =>
    _env = env
    _total = n
    _procs = Array[Second]  // Initialized an Array to hold second actors

    // Determining the chunk_size (_cs)
    if n <= 1000 then
      _cs = n              
    else 
      _cs = Calci.ceil(Calci.sqrt(n)) 
    end

    // Calculate number of chunks (ns)
    let ns = ((n - 1) / _cs) + 1
    for i in Range(0, ns) do
      _procs.push(Second(env, k, i * _cs)) // Creating  and pushing Second actors
    end

    // Distributing work to Second actors, each actor getting a range so that they can process on that range.
    for i in Range(0, ns) do
      let st = (i * _cs) + 1             // St=Start of the range
      let en = if ((i + 1) * _cs) > n then n else (i + 1) * _cs end //en= End of the range
      try
        _procs(i)?.cal_ch(st, en)        
      end
    end

// Worker actor
actor Second
  let _env: Env            
  let _k: USize             // Length of queue 
  let _os: USize            // starting point
  let _queue: Array[U64]    // queue is used as we need to pop element from first FIFO Principle.
  var _sum: U64             // Sum variable to hold sum of squares
  var _index: USize         // Current index for processing
  let _check: PerfectSquare3// PerfectSquare3 actor to check for perfect squares

  // Constructor for the Second actor
  new create(env: Env, k: USize, os: USize) =>
    _env = env
    _k = k
    _os = os
    _queue = Array[U64](_k) // Initialize queue with size _k
    _sum = 0
    _index = 0
    _check = PerfectSquare3(env)

  // Calculating squares for a range of numbers
  be cal_ch(st: USize, en: USize) =>
    for i in Range(st, en + 1) do
      let square = (i.u64() * i.u64()) 
      add_square(square, st)           // Adding square to queue
    end

  // Add a square to the queue and process the sum
  fun ref add_square(square: U64, st: USize) =>
    // If the queue is full, remove the oldest element from the queue this is like a sliding window technique
    if _queue.size() == _k then
      try
        _sum = _sum - _queue.shift()?  // Subtracting the oldest element from the sum
      end
    end

    _queue.push(square)               
    _sum = _sum + square              

    // If the queue is full, check if the sum is a perfect square
    if _queue.size() == _k then
      _check.cps(_sum, _os + _index)  // Call PerfectSquare3 to check for perfect squares(cps)
      _index = _index + 1             
    end

// Actor3 to check if a sum of squares is a perfect square
actor PerfectSquare3
  let _env: Env            
  let _results: Array[Bool]

  // Constructor for the PerfectSquare3 actor
  new create(env: Env) =>
    _env = env
    _results = Array[Bool] 

  //checking if the given sum is a perfect square
  be cps(n: U64, index: USize) =>
    let result = is_sqrt(n)   

   
    if result == true then
      _env.out.print((index + 1).string()) // Print the index if true
    end

    _results.push(result) 

  // Function to determine if a number is a perfect square
  fun is_sqrt(num: U64): Bool =>
    let num_size = num.usize()                 
    let root = Calci.sqrt(num_size).trunc().usize() 
    let root2 = root * root                   
    root2 == num_size                          

//Calci class for Mathematical function
class Calci
  // Function that calculates the ceiling of a floating point number
  fun ceil(x: F64): USize =>
    let i = x.trunc().i64()        
    if (x > 0) and (x > i.f64()) then
      return (i + 1).usize()       
    else
      return i.usize()             
    end

  // Function to calculate the square root of an integer
  fun sqrt(n: USize): F64 =>
    if n == 0 then return 0.0 end  
    if n == 1 then return 1.0 end  

    let num: F64 = n.f64()         
    let root: F64 = num.sqrt()    
    root                           


actor Main
  new create(env: Env) =>
    try
      let n = env.args(1)?.usize()?  
      let k = env.args(2)?.usize()?  
      First(env, n + k, k)           
    else
      env.out.print("Please provide valid numbers N and K") 
    end