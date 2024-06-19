shader_type canvas_item;

// Uniforms grouped by functionality
uniform vec2 draw_offset = vec2(0.0, 0.0);

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform bool doDither = true;
uniform float speed = 0;
uniform float speed2 = 0.2;
uniform float transOffset = -0.2;
uniform float noiseScale = 0.1;
uniform vec2 ditherScale = vec2(3200, 3200);
uniform vec2 baseScale = vec2(1, 1);
uniform vec2 dir = vec2(0.5, 0.5);
uniform vec2 dir2 = vec2(-0.3, 0.7);
uniform sampler2D noise_tex;
uniform float trueAlpha = 0.2;

uniform float rotSpeed = 5; // degrees per second

// Zoom-related uniforms
uniform float zoomFactor = 1;
uniform float minZoomOffset = -0.001; // Minimum zoom offset
uniform float maxZoomOffset = 0.001; // Maximum zoom offset
uniform float pulseFrequency = 0.5; // Frequency of the pulse

// Dithering matrix as a uniform for potential dynamic updates
uniform mat4 ditherMatrix = mat4(
    vec4(0.0625, 0.8125, 0.2500, 1.0000),
    vec4(0.5625, 0.3125, 0.7500, 0.5000),
    vec4(0.1875, 0.9375, 0.1250, 0.8750),
    vec4(0.6875, 0.4375, 0.6250, 0.3750)
);

// Uniforms for noise offset
uniform float noiseOffsetSpeed = 1.0; // Speed of noise offset change
uniform float noiseOffsetScale = 1.0; // Scale of noise offset

// Function to calculate dithering
float dither(vec2 uvPosition, float brightness) {
    // Convert the UV position to pixel space
    vec2 pixelPosition = uvPosition * vec2(1920.0, 1080.0);

    // Apply the dither scale, which is in pixel space
    vec2 ditherPos = pixelPosition / ditherScale;

    // Wrap the position to the size of the dither matrix
    ditherPos = mod(ditherPos, 4.0);

    // Get the threshold value from the dither matrix
    float ditherThreshold = ditherMatrix[int(ditherPos.x)][int(ditherPos.y)];

    // Return the dithered brightness value
    return float(brightness > ditherThreshold);
}


// Function to calculate tiling UV without pixelation
vec2 calculateTilingUV(vec2 uv, float time) {
    vec2 tiling_uv = uv * baseScale;
    tiling_uv += time * speed * dir;
    return tiling_uv;
}

// Function to apply zoom and rotation to tiling UV coordinates
vec2 applyZoomAndRotate(vec2 tiling_uv, float currentZoomFactor, float time) {
    // Calculate the center of the UV space
    vec2 center = vec2(0.5, 0.5);

    // Translate tiling_uv coordinates so that the center is at (0, 0)
    vec2 centered_uv = mod(tiling_uv, 1.0) - center;

    // Calculate rotation
    float angle = rotSpeed * time;
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);

    // Apply rotation
    vec2 rotated_uv = vec2(
        centered_uv.x * cos_angle - centered_uv.y * sin_angle,
        centered_uv.x * sin_angle + centered_uv.y * cos_angle
    );

    // Apply the zoom
    rotated_uv *= 1.0 / currentZoomFactor;

    // Translate tiling_uv coordinates back
    rotated_uv += center;
    rotated_uv = clamp(rotated_uv, vec2(0.0, 0.0), vec2(1.0, 1.0));

    return rotated_uv;
}

void vertex() {
    // No operations in vertex shader for this example
}

void fragment() {
    float time = TIME;

    // Calculate the current zoom offset using a sine wave
    float currentZoomOffset = mix(minZoomOffset, maxZoomOffset, (sin(time * pulseFrequency * 2.0 * 3.14159) + 1.0) / 2.0);

    // Apply the current zoom offset to the zoom factor
    float currentZoomFactor = zoomFactor + currentZoomOffset;

    vec2 uv = SCREEN_UV * (vec2((16.0/9.0), 1.0)) + draw_offset;

    // Calculate UVs for tiling without pixelation
    vec2 tiling_uv = calculateTilingUV(uv, time);

    // Apply zoom and rotation to tiling UV coordinates
    vec2 zoomed_uv = applyZoomAndRotate(tiling_uv, currentZoomFactor, time);

    // Sample the texture and apply alpha
    vec4 texture_color = texture(TEXTURE, zoomed_uv);
    texture_color.a *= trueAlpha;

    // Calculate noise alpha
    float noise_alpha = texture(noise_tex, SCREEN_UV * noiseScale).r;
    noise_alpha = round((noise_alpha + transOffset) * 4.0) / 4.0;

    // Calculate dithering only for the noise pattern
    float dithered_value = doDither ? dither(SCREEN_UV, noise_alpha) : noise_alpha;

    // Combine colors and apply shadow
    vec4 mixedColor = mix(color1, color2, dithered_value);
    mixedColor.a = texture_color.a;

    // Apply checker pattern and alpha blending
    bool checker = mod(floor(tiling_uv.x) + floor(tiling_uv.y), 2.0) < 1.0;
    if (checker) {
        COLOR = mixedColor;
        COLOR.a = mix(0.0, COLOR.a, step(0.5, mixedColor.a));
    } else {
        COLOR.a = 0.0;
    }
}
