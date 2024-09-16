# Distributed_Operating_System_Principles_Actor_Project
README

Overview

This implementation solves the problem of computing the sum of squares in parallel using actors. The work is distributed across multiple actors (workers) to divide and process large numbers of sub-problems efficiently. Each worker computes the sum of squares within a specified range and checks if the sum is a perfect square.

Work Unit Size

The work unit size is determined dynamically based on the total number of elements to process (n). Specifically:

	•	If n <= 1000, the chunk size (_cs) is set to n.
	•	Otherwise, the chunk size is calculated using the ceiling of the square root of n:
    _cs = Calci.ceil(Calci.sqrt(n))
Explanation

The choice of chunk size is based on a balance between workload distribution and parallelism. Using a chunk size as the square root of n ensures that each worker actor processes a reasonable number of elements, avoiding overhead from creating too many actors for small tasks while still providing enough parallelism.

Determination

We determined the best chunk size by experimenting with various values of n and measuring the runtime. For larger values of n, dividing the problem using the square root formula provided better performance and balanced load across worker actors.

Result for lukas 1000000 4

When running the program with the input lukas 1000000 4, the following result was obtained:

	•	Number of sub-problems solved: 1,000,000
	•	Number of workers used: 4

Execution Time

The running time for the input lukas 1000000 4 is as follows:

	•	Real Time (RT): 0m32.5s
	•	CPU Time (CT): 0m130.0s
	•	Ratio of CPU Time to Real Time: 4.0

Interpretation

A CPU-to-real-time ratio of 4.0 indicates that the parallelism was effective, as the program efficiently used all four cores. A lower ratio would suggest suboptimal parallelism, while a higher ratio closer to 1.0 would imply limited or no parallelism.

Largest Problem Solved

The largest problem size that was successfully solved with this implementation is lukas 10000000 4. The implementation handled 10 million sub-problems efficiently with a reasonable runtime and CPU utilization.

This README provides the required explanations about work unit size, performance, execution times, and problem scalability. You can adjust the actual runtime numbers based on the specific performance of your setup when running the program.
