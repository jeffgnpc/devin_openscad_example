# devin_openscad_example

OpenSCAD cookie press designs for 3D printing. Press dough into these molds to create decorated half-sphere cookies.

## Files

- **CookiePress.scad** — Original cookie press with a simple spine and ridge pattern
- **LeafCookiePress.scad** — Leaf-patterned cookie press derived from the original
- **leaf.jpeg** — Reference photo of the target leaf cookie press design

## How the Leaf Press Was Created

The original `CookiePress.scad` uses a hemispherical dome with a straight spine and symmetric ridges cut into the interior. To create the leaf version, the following changes were made:

1. **Replaced the spine/ridge pattern with a leaf shape** — The `spine()` and `ridge()` modules were removed. A parametric leaf outline was defined using a polygon with `sin(pow(t, 0.7) * 180)` to create a natural asymmetric taper (wider toward the stem, pointed at the tip).

2. **Added a curved central midrib** — Instead of a straight spine, the midrib follows a `sin(t * 180)` arc controlled by the `midribArc` parameter. The entire leaf outline and all vein origins shift to follow this curve.

3. **Added branching side veins** — Pairs of veins branch from the curved midrib at a configurable angle (`veinAngle`). The number of vein pairs is calculated dynamically so that the gap between veins equals the vein width.

4. **Changed from cut-through to indentation** — Rather than cutting the pattern all the way through the dome wall, the leaf is carved 5mm into the inner surface using a `carvingShell` intersection. This produces a **raised** leaf pattern on the cookie.

5. **Added a leaf border** — A thin raised wall follows the leaf outline using `offset()`, framing the leaf shape.

The dome shape (`outerShell`/`innerShell`) was kept identical to the original.

## Creating Your Own Cookie Press Designs

You can use `LeafCookiePress.scad` as a template to create cookie presses with any pattern. Here is the general process:

### 1. Start with the dome

Keep the `outerShell()`, `innerShell()`, `carvingShell()`, and `press()` modules as-is. These define the half-sphere body and the carving mechanism. Key parameters to adjust:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `hullDiameter` | Dome diameter (mm) | 80 |
| `wallThickness` | Dome wall thickness (mm) | 10 |
| `imprintDepth` | How deep the pattern is carved (mm) | 5 |
| `innerScale` | Inner shell scale factor | 0.8 |

### 2. Define your pattern outline

Replace `leafOutline()` with a 2D polygon or shape that defines the boundary of your design. This can be any closed 2D shape — a star, heart, flower, animal silhouette, text, etc.

```openscad
module myPatternOutline(){
    // Example: a simple star
    polygon(points=[ /* your points */ ]);
    // Or use built-in shapes:
    // circle(r=25);
    // square([40, 40], center=true);
}
```

### 3. Define the raised features (ridges)

Replace `allVeins()` and `curvedMidrib()` with modules that define the features you want raised inside the pattern. These are subtracted from the carving, so they remain as ridges on the dome surface.

Each feature should be a `linear_extrude(height=hullDiameter)` of a 2D shape — the dome intersection handles clipping to the curved surface.

### 4. Optionally add a border

The `leafBorder()` module creates a thin raised wall around the pattern outline using `offset()`. You can reuse this approach for any outline shape.

### 5. Render and iterate

Open your `.scad` file in OpenSCAD, preview the model, and adjust parameters until the design looks right. Use cross-sections (cut the model in half with a `difference()` and a cube) to verify the carving depth.

### Tips

- All features are extruded vertically and intersected with the dome — you don't need to model curved surfaces
- Use `$fn=80` or higher for smooth dome surfaces
- The `+0.1` z-offset on the innerShell translate prevents rendering artifacts
- Keep ridge widths above 1.5mm for reliable 3D printing
- Test with a cross-section before printing: cut the model in half to verify wall thickness and carving depth

## Requirements

- [OpenSCAD](https://openscad.org/) (tested with 2021.01 and 2025.09.02)
