#!/bin/bash

# Install Python if not available
if ! command -v python3 &> /dev/null; then
    echo "Installing Python..."
    # This will be handled by Vercel's environment
fi

# Install pip if not available  
if ! command -v pip3 &> /dev/null; then
    echo "Installing pip..."
    # This will be handled by Vercel's environment
fi

# Install requirements
echo "Installing Python dependencies..."
pip3 install -r requirements.txt

# Build the site
echo "Building MkDocs site..."
mkdocs build

echo "Build complete!" 