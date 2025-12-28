"""
Basic tests to ensure testing infrastructure works
"""
import pytest


def test_basic():
    """Basic test that always passes"""
    assert True


def test_imports():
    """Test that basic imports work"""
    import sys
    import os
    assert sys.version_info >= (3, 11)


def test_environment():
    """Test environment variables"""
    import os
    # Just verify we can access env vars
    env_test = os.getenv('ENVIRONMENT', 'test')
    assert env_test in ['test', 'staging', 'production', 'development']


class TestMath:
    """Test basic math operations"""
    
    def test_addition(self):
        assert 1 + 1 == 2
    
    def test_subtraction(self):
        assert 5 - 3 == 2
    
    def test_multiplication(self):
        assert 3 * 4 == 12


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
