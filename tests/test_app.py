import pytest
from app import app  # Assurez-vous que votre application Flask s'appelle 'app'


@pytest.fixture
def client():
    # Configure l'application pour les tests
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home_route(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b"Bonjour tout le monde" in response.data

def test_exercices_route(client):
    response = client.get('/exercices/')
    assert response.status_code == 200
    assert b"incroyable" in response.data
