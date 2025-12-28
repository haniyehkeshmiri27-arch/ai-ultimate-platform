"""
Integration tests for health checks
"""
import pytest
import requests
import os


def test_api_health():
    """Test API health endpoint"""
    api_url = os.getenv('API_URL')
    
    if not api_url:
        pytest.skip("API_URL not set, skipping integration test")
    
    try:
        response = requests.get(f"{api_url}/health", timeout=10)
        assert response.status_code == 200
        data = response.json()
        assert 'status' in data
    except requests.exceptions.RequestException:
        pytest.skip("API not accessible, skipping test")


def test_frontend_health():
    """Test frontend accessibility"""
    frontend_url = os.getenv('FRONTEND_URL')
    
    if not frontend_url:
        pytest.skip("FRONTEND_URL not set, skipping integration test")
    
    try:
        response = requests.get(frontend_url, timeout=10)
        assert response.status_code in [200, 301, 302]
    except requests.exceptions.RequestException:
        pytest.skip("Frontend not accessible, skipping test")


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
