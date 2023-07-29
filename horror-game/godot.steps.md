### Godot Steps
- New Inheritaed Scene imported glb models from blender
- Inspector > MeshInstance3D > Make Unique (Recursive)
- Inspector > Mesh > Surface (leaf, needles) > Convert to ShaderMaterial

- Inspector > Mesh > Surface (leaf, needles) > Material > Wind > Noise Tex > New NoiseTexture2D
- Set -> Seamless=on, SeamlessBlend=1, Noise= new FastNoiseLite, Frequency=0.005, Fractal > Octaves=1
- Inspector > Mesh > Surface (leaf, needles) > Material > Shader >

```
group_uniforms wind;
uniform sampler2D noise_tex;
uniform float wind_speed = .1;
uniform float wind_strength = .01;

void vertex() { 
	// add to below this method
	// ..

	vec3 GLOBAL_VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.)).xyz;
	float offset = TIME * wind_speed;
	float noise = texture(noise_tex, vec2(GLOBAL_VERTEX.x - offset)).r;
	noise -= .5;
	noise *= wind_strength;
	VERTEX.xy += noise * length(VERTEX.y) * length(VERTEX.xz);
}
```



```
group_uniforms wind;
uniform sampler2D noise_tex;
uniform float wind_speed = .1;
uniform float wind_strength = .01;

void vertex() { 
	// add to below this method
	// ..

	float offset = TIME * wind_speed;
	float noise = texture(noise_tex, NODE_POSITION_WORLD.xz - offset).r;
	noise -= .5;
	noise *= wind_strength;
	VERTEX.xy += noise * length(VERTEX.y);
}
```


```
// add to render mode 
world_vertex_coords
```

### Campfire
- Add GPUParticle3D
- Inspector > Amount > 16
- Inspector > Process Material > new ParticleProcessMaterial
- Inspector > Process Material > Direction > y=1, spead=10
- Inspector > Process Material > Gravity > 0
- Inspector > Process Material > Initial Velocity > 1
- Inspector > Process Material > Anguar Velocity > min=-50 max=50
- Inspector > Process Material > Angel > max=360
- Inspector > Process Material > Scale > min,max=2
- Inspector > Process Material > Scale > Sacle Curve > CurveText
- Inspector > Process Material > Color > Color Ramp > Gradient
 
- Inspector > Draw Passes > Pass1 > new QuadMesh
- Inspector > Draw Passes > Pass1 > new QuadMesh > Material > StandartMaterial3D > Albedo > Texture
- Inspector > Draw Passes > Pass1 > new QuadMesh > Material > Transparency > Alpha
- Inspector > Draw Passes > Pass1 > new QuadMesh > Material > Shading > Unshaded
- Inspector > Draw Passes > Pass1 > new QuadMesh > Material > VertexColor > Use as Albedo: on
- Inspector > Draw Passes > Pass1 > new QuadMesh > Material > Sampling > Filter > Nearest
- Inspector > Draw Passes > Pass1 > new QuadMesh > Material > Bilboard > Mode > Particle Billboard