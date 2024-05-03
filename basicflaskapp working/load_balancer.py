import socket

# Define the ports for the load balancer and the backend server
LOAD_BALANCER_PORT = 8080
BACKEND_SERVER_PORT = 5001

# Function to forward requests from the load balancer port to the backend server port
def forward_request(request):
    # Create a socket to connect to the backend server
    backend_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    backend_socket.connect(('localhost', BACKEND_SERVER_PORT))
    
    # Forward the request to the backend server
    backend_socket.sendall(request)
    
    # Receive the response from the backend server
    response = backend_socket.recv(1024)
    
    # Close the connection to the backend server
    backend_socket.close()
    
    return response

# Main function to handle incoming requests on the load balancer port
def main():
    # Create a socket for the load balancer
    lb_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    lb_socket.bind(('localhost', LOAD_BALANCER_PORT))
    lb_socket.listen(5)
    
    print(f"Load balancer started. Listening on port {LOAD_BALANCER_PORT}...")
    
    # Accept incoming connections and forward requests to the backend server
    while True:
        client_socket, client_address = lb_socket.accept()
        print(f"Received connection from {client_address}")
        
        # Receive the request from the client
        request = client_socket.recv(1024)
        
        # Forward the request to the backend server and get the response
        response = forward_request(request)
        
        # Send the response back to the client
        client_socket.sendall(response)
        
        # Close the connection to the client
        client_socket.close()

if __name__ == "__main__":
    main()

