# Example Python file for testing Claude Code Review

def calculate_fibonacci(n):
    """Calculate the nth Fibonacci number."""
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        # This could be optimized!
        return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)

def find_prime_numbers(limit):
    """Find all prime numbers up to a given limit."""
    primes = []
    for num in range(2, limit + 1):
        is_prime = True
        for i in range(2, num):
            if num % i == 0:
                is_prime = False
                break
        if is_prime:
            primes.append(num)
    return primes

# TODO: Add more functions
# FIXME: Optimize the algorithms

if __name__ == "__main__":
    print(f"10th Fibonacci number: {calculate_fibonacci(10)}")
    print(f"Primes up to 20: {find_prime_numbers(20)}")