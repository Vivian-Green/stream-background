Just a couple shaders I threw together for a stream background

[showcase video (just it running for a bit in 1080p60)](https://youtu.be/7dtHheMQa24)

dithering is screen uv aligned to reduce bitrate usage


Reworded gpt summary:

### Dot Grid Shader
Dot Grid Shader creates a grid pattern with animated dots. The dots slide and breathe over time, resulting in a pulsating effect.

- **Animated Grid**: The dots pulse along a sine wave with a given period, and slide along a path created with 5 points, traced by 5 quadratic bezier curves along a path indexed by a sine wave for smooth looping. follows curves 0 1 2, then 2 3 4, 4 0 1, 1 2 3, then 3 4 0 
- **Grid Customization**: Adjustable grid size, dot size, and edge hardness to achieve their desired aesthetic
- **Color Animation**: The shader smoothly transitions between two colors over a specified period, adding visual complexity, with background transparency for layering
- **Dithering Effect**: A dither matrix creates a slowly pulsing gradient transition for the background between the top left and bottom right corners

### Checker Tiling Shader
Checker Tiling Shader draws a transparent texture in a checkered pattern with a dynamic twist. Uses pixellated / pixel-aligned dithering, with sliding noise because it looked nice

- **Checkered Pattern**: Tiles are checkered, with animated translation and breathing/pulsing size, also per-tile rotation
- **Pixelation & Dithering**: Pixel-aligned dithering between a 2 color palette for texture on the tiles, based on the
- **Noise**: Slowly sliding, twice sampled noise map. Second sample slowly circles the first back and forth at a given distance and period. Acts kinda like 2 sliding noise maps or sampling one in 2 directions, less static than the one sample. Works, and gives control over the wobblyness without needing 2 different scales for the two samples.

### Misc
- **Drop shadow**: it's just another sprite it's the same thing but again and dark/transparent, with the offset shader param set
