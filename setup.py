from setuptools import setup, find_packages

setup(
    name="f5-tts",
    version="0.2.1",
    package_dir={"": "src"},  # Point to the `src` directory
    packages=find_packages(where="src"),
    install_requires=[
        # Add any dependencies here
    ],
)
