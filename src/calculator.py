# Calculator module for demonstrating Anthropic Dev Agents

class Calculator:
    """A simple calculator with intentional issues for Claude to review."""
    
    def add(self, a, b):
        """Add two numbers."""
        # TODO: Add type checking
        return a + b
    
    def divide(self, a, b):
        """Divide two numbers."""
        # BUG: No zero division handling
        return a / b
    
    def calculate_average(self, numbers):
        """Calculate average of a list of numbers."""
        # FIXME: What if the list is empty?
        total = 0
        for num in numbers:
            total = total + num
        return total / len(numbers)
    
    def factorial(self, n):
        """Calculate factorial recursively."""
        # Performance issue: Could be optimized
        if n == 0:
            return 1
        return n * self.factorial(n - 1)
    
    def is_prime(self, n):
        """Check if a number is prime."""
        # Security: No input validation
        if n < 2:
            return False
        for i in range(2, n):
            if n % i == 0:
                return False
        return True

# Example usage
if __name__ == "__main__":
    calc = Calculator()
    print(f"10 + 5 = {calc.add(10, 5)}")
    print(f"10 / 2 = {calc.divide(10, 2)}")
    # This will crash:
    # print(f"10 / 0 = {calc.divide(10, 0)}")