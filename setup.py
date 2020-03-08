import os
from setuptools import find_packages

try:
    from skbuild import setup
    import torch
except ImportError:
    raise ImportError('scikit-build and pytorch is required for installing')

torch_root = os.path.dirname(torch.__file__)

cuda_flags = ["\"--expt-relaxed-constexpr\""]
# must add following flags to use at::Half
# but will remove raw half operators.
cuda_flags += ["-D__CUDA_NO_HALF_OPERATORS__", "-D__CUDA_NO_HALF_CONVERSIONS__"]
cuda_flags += ["-D__CUDA_NO_HALF2_OPERATORS__"] 
cuda_flags = '-DCMAKE_CUDA_FLAGS=' + " ".join(cuda_flags)

setup(
    name='spconv',
    version='1.1',
    author='Yan Yan',
    author_email='scrin@foxmail.com',
    description='spatial sparse convolution for pytorch',
    license='BSD-3-Clause',
    packages=find_packages(exclude=('tools', 'tools.*')),
    install_requires=['numpy>=1.11'],
    setup_requires=['torch>=1.0.0', 'scikit-build', 'pybind11'],
    extras_require={'test': ['pytest']},
    cmake_args=[f'-DCMAKE_PREFIX_PATH={torch_root}', cuda_flags, '-DSPCONV_BuildTests=OFF']
)
