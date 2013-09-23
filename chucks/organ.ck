//Machine.add("vector.ck");

// BEGIN_VECTOR_CK

fun float norm (float x[]) {
	return Math.sqrt(snorm(x));
}

fun float snorm (float x[]) {
	0 => float res;
	for (0 => int i; i < x.size(); i++) {
		x[i]*x[i] +=> res;
	}
	return res;
}

fun float[] diff (float x[], float y[]) {
	float res[x.size()];
	for (0 => int i; i < x.size(); i++) {
		x[i] - y[i] => res[i];
	}
	return res;
}

fun float dist (float x[], float y[]) {
	return norm(diff(x,y));
}

fun float dot (float x[], float y[]) {
	0 => float res;
	for (0 => int i; i < x.size(); i++) {
		x[i] * y[i] +=> res;
	}
	return res;
}

fun float angle (float x[], float y[]) {
	return dot(x,y) / (norm(x) * norm(y));
}

fun float[] unit (float x[]) {
	norm(x) => float n;
	float res[x.size()];
	for (0 => int i; i < x.size(); i++) {
		x[i]/n => res[i];
	}
	return res;
}

fun float[] punit (float x[]) {
	0 => float n;
	float res[x.size()];
	for (0 => int i; i < x.size(); i++) {
		x[i] +=> n;
	}
	for (0 => int i; i < x.size(); i++) {
		x[i]/n => res[i];
	}
	return res;
}

fun float[] sunit (float x[]) {
	snorm(x) => float n;
	float res[x.size()];
	for (0 => int i; i < x.size(); i++) {
		x[i]/n => res[i];
	}
	return res;
}

// END_VECTOR_CK


// BEGIN MAIN

float fingers[0][3];
fingers << [1.0, 1.0, 1.0];
fingers << [1.0, 1.0, 1.0];
fingers << [1.0, 1.0, 1.0];
fingers << [1.0, 1.0, 1.0];

[2.0, 2.0, 1.0] @=> float palm[];
[0, 1, 2, 3] @=> int ids[];
[0.5, 0.5, 0.5, 0.5] @=> float coeff[];

SinOsc osc[4];
Gain g;
300 => float f;

fun int map2osc (int id) {
	for (0 => int i; i < ids.size(); i++) {
		if (id == ids[i]) {
			return i;
		}
	}
}

for (0 => int i; i < osc.size(); i++) {
	f * (i+1) => osc[i].freq;
	0.5/i => osc[i].gain;
	osc[i] => g => dac;
}
0.5 => g.gain;

while (true) {

	Math.randomf()*2-1 => fingers[0][0];
	Math.randomf()*2-1 => fingers[0][1];
	Math.randomf()*2-1 => fingers[0][2];
	Math.randomf()*2-1 => fingers[1][0];
	Math.randomf()*2-1 => fingers[1][1];
	Math.randomf()*2-1 => fingers[1][2];
	Math.randomf()*2-1 => fingers[2][0];
	Math.randomf()*2-1 => fingers[2][1];
	Math.randomf()*2-1 => fingers[2][2];
	Math.randomf()*2-1 => fingers[3][0];
	Math.randomf()*2-1 => fingers[3][1];
	Math.randomf()*2-1 => fingers[3][2];
	Math.randomf()*-1 => palm[1];

	for (0 => int i; i < fingers.size(); i++) {
		angle(fingers[i], palm) => coeff[i];
	}
	unit(coeff) @=> coeff;
	for (0 => int i; i < ids.size(); i++) {
		Std.fabs(coeff[i]) => osc[map2osc(ids[i])].gain;
		f * (i*palm[1]+1) => osc[map2osc(ids[i])].freq;
	}

	100::ms => now;

}