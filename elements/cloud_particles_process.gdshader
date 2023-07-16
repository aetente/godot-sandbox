shader_type particles;

uniform float angular_spacing = 4.5;
uniform float outward_amt = 30.;
uniform float min_cloud_size = 0.03;
uniform float max_cloud_size = 1.0;

float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}

void start() {
}

void process() {
	// Place process code here.
		//create some random seeds
		//uint alt_seed_3 = hash(uint(INDEX) + uint(43) + RANDOM_SEED);
		
		//position clouds in spiral
		
		float index = float(INDEX);
		float pt_index = sqrt(index);
		
		float x = 20.*cos(34.*pt_index + TIME / 40.);
		float y = pt_index*sin(pt_index * 345.) / 2.;
		float z = 2.*sin(angular_spacing*pt_index);
		
		TRANSFORM[3].xyz = EMISSION_TRANSFORM[3].xyz + vec3(x,y,z);
		
		float scale = cos(pt_index * 1678.) + 2.;
		
		TRANSFORM[0].x = scale;
		TRANSFORM[1].y = scale;
		TRANSFORM[2].z = scale;
}
