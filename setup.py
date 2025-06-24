from setuptools import setup, find_packages

with open('README.md', 'r', encoding='utf-8') as f:
    long_description = f.read()

setup(
    name="makefile-command-runner",
    version="0.1.0",
    description="A web-based interface for running Makefile commands",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author="Your Name",
    author_email="your.email@example.com",
    url="https://github.com/yourusername/makefile-command-runner",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        'grpcio>=1.60.0',
        'grpcio-tools>=1.60.0',
        'protobuf>=4.21.0,<5.0.0',
    ],
    extras_require={
        'dev': [
            'pytest>=7.0.0',
            'pytest-cov>=3.0.0',
            'pytest-mock>=3.10.0',
            'black>=22.0.0',
            'flake8>=4.0.0',
            'mypy>=0.910',
            'isort>=5.10.0',
        ],
    },
    entry_points={
        'console_scripts': [
            'makefile-runner=grpc_server:serve',
            'makefile-http=http_server:run_server',
        ],
    },
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
    ],
    python_requires='>=3.10',
)
