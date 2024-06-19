shader_type canvas_item;

// Uniforms for controlling the animation and appearance
uniform float GridRotation : hint_range(0.0, 360.0) = 0.0; // Speed of sliding
uniform vec2 grid_size = vec2(200.0, 200.0); // Size of the grid

uniform vec2 dot_width_range; // 0-1
uniform float dot_width_period; // seconds
uniform vec2 dot_width_range2; // 0-1
uniform float dot_width_period2; // seconds

uniform float dot_hardness : hint_range(0.0, 1.0); // Hardness of the dots' edges
uniform vec4 background_color : source_color; // Background color of the grid
uniform vec4 background_color2 : source_color; // unimplemented
uniform float background_color_period = 20.0;

uniform float gradient_strength : hint_range(0.0, 1.0);

uniform vec4 dot_color : source_color; // Color of the dots
uniform vec4 shadow_dot_color : source_color = vec4(0.1, 0.1, 0.1, 1.0); // Color of the shadow dots
uniform vec2 shadow_offset;

// Uniforms for the control points of the Bezier curve
uniform vec2 p0;
uniform vec2 p1;
uniform vec2 p2;
uniform vec2 p3;
uniform vec2 p4;

// Uniform for controlling the animation speed
uniform float animation_speed;

// Dither matrix for dithering effect
uniform mat4 ditherMatrix = mat4(
    vec4(0.0625, 0.8125, 0.2500, 1.0000),
    vec4(0.5625, 0.3125, 0.7500, 0.5000),
    vec4(0.1875, 0.9375, 0.1250, 0.8750),
    vec4(0.6875, 0.4375, 0.6250, 0.3750)
);

// Function to calculate dithering
float dither(vec2 position, float brightness) {
    vec2 ditherPos = mod(position, 4.0);
    float ditherThreshold = ditherMatrix[int(ditherPos.x)][int(ditherPos.y)];
    return float(brightness > ditherThreshold) * 1.0;
}

// Function to calculate a point on a cubic Bezier curve
vec2 bezier(float t, vec2 lp0, vec2 lp1, vec2 lp2) {
    float one_minus_t = 1.0 - t;
    return one_minus_t * one_minus_t * lp0 +
           2.0 * one_minus_t * t * lp1 +
           t * t * lp2;
}

// Function to interpolate between the five points
vec2 interpolate(float t) {
    float segmentLength = 1.0 / 5.0;
    int segment = int(t / segmentLength);
    float segmentT = mod((t - float(segment) * segmentLength) / segmentLength, 5);

    if (segment == 0) {
        return bezier(segmentT, p0, p1, p2);
    } else if (segment == 1) {
        return bezier(segmentT, p2, p3, p4);
    } else if (segment == 2) {
        return bezier(segmentT, p4, p0, p1);
    } else if (segment == 3) {
        return bezier(segmentT, p1, p2, p3);
    } else {
        return bezier(segmentT, p3, p4, p0);
    }
}

// Function to rotate and slide UV coordinates
vec2 rotate_uv(vec2 uv, vec2 center, vec2 position) {
    vec2 uv_rotated;
    uv_rotated.x = cos(GridRotation) * (uv.x - center.x + position.x) - sin(GridRotation) * (uv.y - center.y + position.y) + center.x;
    uv_rotated.y = sin(GridRotation) * (uv.x - center.x + position.x) + cos(GridRotation) * (uv.y - center.y + position.y) + center.y;
    return uv_rotated;
}

// Function to calculate dot intensity
float calculate_dot_intensity(vec2 uv, vec2 grid, float width, float hardness) {
    vec2 grid_uv = fract(uv * grid);
    float distance_from_center = length(grid_uv - 0.5);
    return smoothstep(width - hardness, width, distance_from_center);
}

void fragment() {
    float t = (sin(animation_speed * TIME) + sin(animation_speed * TIME + 0.1)) / 2.0;
    vec2 position = interpolate(t);
    vec2 center = vec2(0.5, 0.5);

    // Rotate the UV coordinates
    vec2 uv_rotated = rotate_uv(UV, center, position);

    // Calculate the dot width based on dot_width_period
    float dot_width = mix(dot_width_range.x, dot_width_range.y, 0.5 * (sin(TIME / dot_width_period * 2.0 * PI) + 1.0));
    dot_width += mix(dot_width_range2.x, dot_width_range2.y, 0.5 * (sin(TIME / dot_width_period2 * 2.0 * PI) + 1.0));

    // Calculate the dot intensity for the main and shadow dots
    float dot_intensity = calculate_dot_intensity(uv_rotated, grid_size, dot_width, 1.0 - dot_hardness);
    float shadow_dot_intensity = calculate_dot_intensity(uv_rotated + shadow_offset, grid_size, dot_width, 1.0 - dot_hardness);

    // Calculate background intensity based on period
	float gradient = sqrt((UV.x * UV.x + UV.y * UV.y)) * gradient_strength;
    float background_intensity = sin(TIME / background_color_period) * (1.0-gradient) + gradient;

    // Calculate dithering between background colors
    vec4 dithered_background_color = mix(background_color, background_color2, dither(UV*(160.0*4.0), background_intensity));

    // Combine the main dot and shadow dot colors
    vec3 combined_color = mix(shadow_dot_color.rgb, dithered_background_color.rgb, shadow_dot_intensity);
    combined_color = mix(dot_color.rgb, combined_color, dot_intensity);

    // Output the combined color
    COLOR = vec4(combined_color, 1.0);
}