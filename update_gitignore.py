#!/usr/bin/env python3
"""
Script to merge Python-specific .gitignore patterns with the existing .gitignore file.
"""


def main():
    # Read the existing .gitignore
    with open(".gitignore", "r") as f:
        existing_lines = set(
            line.strip() for line in f if line.strip() and not line.startswith("#")
        )

    # Read the Python-specific .gitignore
    with open("python.gitignore", "r") as f:
        python_lines = [
            line.strip() for line in f if line.strip() and not line.startswith("#")
        ]

    # Add Python-specific lines that don't already exist
    new_lines = []
    for line in python_lines:
        if line not in existing_lines:
            new_lines.append(line)

    # If there are new lines to add, append them to the .gitignore
    if new_lines:
        with open(".gitignore", "a") as f:
            f.write("\n# Python specific\n")
            f.write("\n".join(new_lines) + "\n")
        print(f"Added {len(new_lines)} new patterns to .gitignore")
    else:
        print("No new patterns to add to .gitignore")

    # Clean up the temporary file
    import os

    os.remove("python.gitignore")
    print("Removed temporary python.gitignore file")


if __name__ == "__main__":
    main()
