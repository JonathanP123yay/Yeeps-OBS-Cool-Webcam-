#!/bin/bash

echo ""
echo "=============================================="
echo "   Welcome to the YOBSCW setup!"
echo "=============================================="
echo ""

# --- Step 1: Headset Selection ---
read -p "First, what headset do you use? (2 / Pro / 3 / 3s) " HEADSET
HEADSET_LOWER=$(echo "$HEADSET" | tr '[:upper:]' '[:lower:]')

# Map headset to GitHub raw URLs
case "$HEADSET_LOWER" in
  "2")
    MODEL_URL="https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/quest2.glb"
    MODEL_NAME="Quest 2"
    ;;
  "pro")
    MODEL_URL="https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/questpro.glb"
    MODEL_NAME="Quest Pro"
    ;;
  "3")
    MODEL_URL="https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/quest3.glb"
    MODEL_NAME="Quest 3"
    ;;
  "3s")
    MODEL_URL="https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/quest3s.glb"
    MODEL_NAME="Quest 3S"
    ;;
  *)
    echo "Unknown headset type. Defaulting to Quest 2."
    MODEL_URL="https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/quest2.glb"
    MODEL_NAME="Quest 2"
    ;;
esac

# --- Step 1a: Optional Touch Controllers for Quest 2 ---
echo "Creating Models folder..."
mkdir -p Models
echo "Downloading Meta $MODEL_NAME model..."
curl -L -o Models/headset.glb "$MODEL_URL"

if [ "$HEADSET_LOWER" == "2" ]; then
  read -p "Does your Quest 2 have touch controllers? (Y/N) " TOUCH
  TOUCH_LOWER=$(echo "$TOUCH" | tr '[:upper:]' '[:lower:]')
  if [ "$TOUCH_LOWER" == "y" ]; then
    echo "Downloading Quest 2 Touch Controllers..."
    curl -L -o Models/controller.glb https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/controllers/quest2_controller.glb
  else
    echo "Ok, We will use the ring controllers."
  fi
else
  echo "Downloading $MODEL_NAME controllers..."
  curl -L -o Models/controller.glb https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/controllers/default_controller.glb
fi

# --- Step 2: Room Model ---
read -p "What is the path to the room 3D model you are going to use (.glb, .stl, or .obj)? " ROOM_PATH
if [ ! -f "$ROOM_PATH" ]; then
  echo "Room model not found at $ROOM_PATH. Downloading default room model from GitHub..."
  curl -L -o Models/room.glb https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/Models/room.glb
else
  cp "$ROOM_PATH" Models/room.glb
fi

# --- Step 3: Software storage path ---
read -p "Where do you want to store the software files? " SOFTWARE_PATH
mkdir -p "$SOFTWARE_PATH"
echo "Created (if not existing) directory: $SOFTWARE_PATH"
mkdir -p "$SOFTWARE_PATH/Models"
echo "Created $SOFTWARE_PATH/Models"
mkdir -p "$SOFTWARE_PATH/src"
echo "Created $SOFTWARE_PATH/src"

# Copy downloaded models into chosen folder
cp -R Models/* "$SOFTWARE_PATH/Models/"

# --- Step 4: OBS installation path ---
read -p "Where is the path to your OBS installation? (Default: /Applications/OBS.app) " OBS_PATH
OBS_PATH=${OBS_PATH:-/Applications/OBS.app}

# --- Step 5: Download src scripts ---
echo "Downloading source scripts..."
SRC_FILES=("helper.js" "obs_scene_creator.py")  # Add more as needed

for FILE in "${SRC_FILES[@]}"; do
  echo "Downloading $FILE..."
  curl -L -o "$SOFTWARE_PATH/src/$FILE" "https://raw.githubusercontent.com/JonathanP123YAY/Yeeps-OBS-Cool-Webcam-/HEAD/src/$FILE"
done

# Make scripts executable
chmod +x "$SOFTWARE_PATH/src/"*

echo ""
echo "=============================================="
echo "Installation complete! ✅"
echo "Software files stored in: $SOFTWARE_PATH"
echo "OBS path set to: $OBS_PATH"
echo "You can now open the project in Unity or your preferred engine."
echo "=============================================="
