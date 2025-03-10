import argon2 
import sys

password = sys.argv[1]

ph = argon2.PasswordHasher()

hashed_password = ph.hash(password)
print(f"Hashed password: {hashed_password}")