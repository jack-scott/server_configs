#!/bin/bash
set -e

BASE_DIR=/mnt/starr_data/data

echo "Setting correct permissions"
sudo chown -R $USER:$USER $BASE_DIR
sudo chmod -R a=,a+rX,u+w,g+w $BASE_DIR

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Create torrents directory structure
mkdir -p "$BASE_DIR/torrents/books"
mkdir -p "$BASE_DIR/torrents/movies"
mkdir -p "$BASE_DIR/torrents/music"
mkdir -p "$BASE_DIR/torrents/tv"

# Create usenet directory structure
mkdir -p "$BASE_DIR/usenet/incomplete"
mkdir -p "$BASE_DIR/usenet/complete/books"
mkdir -p "$BASE_DIR/usenet/complete/movies"
mkdir -p "$BASE_DIR/usenet/complete/music"
mkdir -p "$BASE_DIR/usenet/complete/tv"

# Create media directory structure
mkdir -p "$BASE_DIR/media/books"
mkdir -p "$BASE_DIR/media/movies"
mkdir -p "$BASE_DIR/media/music"
mkdir -p "$BASE_DIR/media/tv"

echo "Starr apps folder structure created successfully!"
echo ""
echo "Data directories at $BASE_DIR:"
echo "├── torrents"
echo "│   ├── books"
echo "│   ├── movies"
echo "│   ├── music"
echo "│   └── tv"
echo "├── usenet"
echo "│   ├── incomplete"
echo "│   └── complete"
echo "│       ├── books"
echo "│       ├── movies"
echo "│       ├── music"
echo "│       └── tv"
echo "└── media"
echo "    ├── books"
echo "    ├── movies"
echo "    ├── music"
echo "    └── tv"

echo "Done!"