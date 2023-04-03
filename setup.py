"""For package installation.

References:
https://godatadriven.com/blog/a-practical-guide-to-using-setup-py/
"""

from setuptools import find_packages, setup

def readme():
    with open('README.md', encoding='utf-8') as f:
        content = f.read()
    return content

# TODO: Might need to alter package finding based on potential addition of
# unit testing???
setup(
    name='dmtech1',
    packages=find_packages(),
    version='0.1.0',
    description='Assignment 1: VU Data Mining Techniques 2023',
    long_description=readme(),
    author='Jared Frazier, Isabel Klennert, Fatima Gonzalez-Novo Lopez',
    author_email="cscidev001@gmail.com",
    license='MIT',
)
