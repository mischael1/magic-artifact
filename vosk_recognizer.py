#!/usr/bin/env python3

import json
import socket
import sys
from vosk import Model, KaldiRecognizer

# Initialize Vosk with Russian language model
try:
    model = Model(lang="ru")
    print("[Vosk] Russian model loaded")
except Exception as e:
    print(f"[ERROR] Could not load Vosk model: {e}")
    sys.exit(1)

# Audio settings
AUDIO_RATE = 16000
AUDIO_CHANNELS = 1
AUDIO_FRAMES = 4096

class VoskServer:
    def __init__(self, host="localhost", port=2700):
        self.host = host
        self.port = port
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.socket.bind((host, port))
        self.socket.listen(1)
        print(f"[Vosk] Server listening on {host}:{port}")
        
    def run(self):
        while True:
            try:
                print("[Vosk] Waiting for connection...")
                client, addr = self.socket.accept()
                print(f"[Vosk] Connected from {addr}")
                self.handle_client(client)
            except Exception as e:
                print(f"[ERROR] {e}")
                
    def handle_client(self, client):
        rec = KaldiRecognizer(model, AUDIO_RATE)
        rec.SetWords("artifact shield fire ice lightning heal arrow teleport")
        
        try:
            while True:
                # Read audio size
                data = client.recv(4)
                if len(data) < 4:
                    break
                    
                size = int.from_bytes(data, byteorder='big')
                
                # Read audio data
                audio_data = b''
                while len(audio_data) < size:
                    chunk = client.recv(min(size - len(audio_data), 65536))
                    if not chunk:
                        break
                    audio_data += chunk
                
                if len(audio_data) != size:
                    break
                
                # Process audio
                if rec.AcceptWaveform(audio_data):
                    result = json.loads(rec.Result())
                    text = result.get("result", [])
                    response = {"result": text}
                else:
                    result = json.loads(rec.PartialResult())
                    text = result.get("partial", "")
                    response = {"partial": text}
                
                # Send response
                response_json = json.dumps(response).encode('utf-8')
                response_size = len(response_json).to_bytes(4, byteorder='big')
                client.send(response_size + response_json)
                
        except Exception as e:
            print(f"[Client] Error: {e}")
        finally:
            client.close()

if __name__ == "__main__":
    server = VoskServer()
    print("\n=== Magic Artifact - Vosk Recognition Server ===\n")
    
    try:
        server.run()
    except KeyboardInterrupt:
        print("\n[Vosk] Server stopped")
