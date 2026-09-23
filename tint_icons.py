import os
import subprocess
from PIL import Image

def get_accent():
    try:
        out = subprocess.check_output(['adb', 'shell', 'cmd', 'overlay', 'lookup', 'android', 'android:color/system_accent1_500'])
        hex_val = out.decode('utf-8').strip()
        if hex_val.startswith('#ff'):
            hex_val = '#' + hex_val[3:]
        return hex_val
    except:
        return '#b66201' # Fallback to user's orange

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

accent = hex_to_rgb(get_accent())
target_dir = './src/res/drawable-xxhdpi-v4'
os.makedirs(target_dir, exist_ok=True)

# Delete XMLs
anydpi = './src/res/drawable-anydpi-v24'
if os.path.exists(anydpi):
    for f in os.listdir(anydpi):
        if f.endswith('.xml'):
            os.remove(os.path.join(anydpi, f))

# For each _inner.png, tint the background and save as .png
for f in os.listdir(target_dir):
    if f.endswith('_inner.png'):
        base = f.replace('_inner.png', '.png')
        img = Image.open(os.path.join(target_dir, f)).convert('RGBA')
        data = img.getdata()
        new_data = []
        for item in data:
            r, g, b, a = item
            if a == 0:
                new_data.append((accent[0], accent[1], accent[2], 255))
            else:
                new_data.append(item)
        img.putdata(new_data)
        img.save(os.path.join(target_dir, base), 'PNG')
