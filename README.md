Just a couple shaders I threw together for a stream background

Showcase: https://youtu.be/6rEgTr4IpkM?si=2KaVA9Ae-3gAocPA // todo: actually link, and show current version

dithering is screen uv aligned to reduce bitrate usage


### Dot Grid Shader
Dot Grid Shader creates a grid pattern with animated dots. The dots slide and breathe over time, resulting in a pulsating effect.

- **Animated Grid**: The dots pulse along a sine wave with a given period, and slide along a path created with 5 points, traced by 5 quadratic bezier curves along a path indexed by a sine wave for smooth looping. follows curves 0 1 2, then 2 3 4, 4 0 1, 1 2 3, then 3 4 0 
- **Grid Customization**: Adjustable grid size, dot size, and edge hardness to achieve their desired aesthetic
- **Color Animation**: The shader smoothly transitions between two colors over a specified period, adding visual complexity, with background transparency for layering
- **Dithering Effect**: A dither matrix creates a slowly pulsing gradient transition for the background between the top left and bottom right corners

### Checker Tiling Shader
Checker Tiling Shader draws a transparent texture in a checkered pattern with a dynamic twist. Uses pixel-aligned dithering, with sliding noise because it looked nice

- **Checkered Pattern**: Tiles are checkered, with animated translation and pulsing size, also per-tile rotation
  **Pixelation & Color Blending**: Pixelated dithering blends two colors seamlessly for texture
- **Noise-Based Transparency**: Tile dithering is based on a slowly sliding noise map
