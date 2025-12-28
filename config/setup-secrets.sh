#!/bin/bash

# Decrypt secrets
echo "Decrypting secrets..."
openssl enc -d -aes-256-cbc -in config/secrets.enc -out config/secrets.tar.gz -k sertila -pbkdf2

# Extract secrets
if [ -f config/secrets.tar.gz ]; then
    echo "Extracting secrets..."
    tar -xzf config/secrets.tar.gz -C .
    rm config/secrets.tar.gz
    echo "Secrets have been successfully decrypted and extracted to config/secrets/"
else
    echo "Error: Decryption failed."
fi