//Machine.add("vector.ck");

// BEGIN_VECTOR_CK

/*
 * Computes the norm of the given vector
 */
fun float norm (float x[]) {
	0 => float res;
	for (0 => int i; i < x.size(); i++) {
		x[i]*x[i] +=> res;
	}
	return Math.sqrt(res);
}

/*
 * Computes the difference between 2 vectors
 */
fun float[] diff (float x[], float y[]) {
	float res[x.size()];
	for (0 => int i; i < x.size(); i++) {
		x[i] - y[i] => res[i];
	}
	return res;
}

/*
 * Computes the Euclidean distance between 2 vectors
 */
fun float dist (float x[], float y[]) {
	return norm(diff(x,y));
}

/*
 * Computes the dot product of two vectors
 */
fun float dot (float x[], float y[]) {
	0 => float res;
	for (0 => int i; i < x.size(); i++) {
		x[i] * y[i] +=> res;
	}
	return res;
}

/*
 * Computes the cosine of the angle between two vectors
 */
fun float angle (float x[], float y[]) {
	return dot(x,y) / (norm(x) * norm(y));
}

/*
 * Returns a normalized copy of the given vector
 * (norm == 1)
 */
fun float[] unit (float x[]) {
	norm(x) => float n;
	float res[x.size()];
	for (0 => int i; i < x.size(); i++) {
		x[i]/n => res[i];
	}
	return res;
}

/*
 * Returns a normalized copy of the given vector
 * (sum of components == 1)
 */
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

// END_VECTOR_CK

// BEGIN OSC_CK

public class OSCR extends OscRecv {

	fun OSCE event (string path) {
		return event(path) $ OSCE;
	}

	fun OSCE event (string path, int flots, int ints, int strings) {
		string oscAddress;
		path +=> oscaddress;
		"," +=> oscAddress;
		for (0 => int foo; foo < floats ; foo++ ) {
		  " f" +=> oscAddress;
		}
		for (0 => int foo; foo < ints; foo++) {
		  " i" +=> oscAddress;
		}
		for (0 => int foo; foo < strings; foo++ ) {
		  " s" +=> oscAddress;
		}
		return event(oscAddress) $ OSCE;
	}

}

class OSCE extends OscEvent {

	fun float[] getVector(OscEvent e) {
		float v[3];
		v[0] = e.getFloat();
		if (e.nextMsg()) v[1] = e.getFloat();
		if (e.nextMsg()) v[2] = e.getFloat();
		return v;
	}
	
}

// END OSC_CK


// BEGIN MAIN

class Finger {
	float position[3];
	string id;
	SinOsc osc;

	fun void init(string _id, UGen sink, float freq, float gain) {
		osc => sink;
		gain => osc.gain;
		freq => osc.freq;
		_id @=> id;
	}

	fun void init(string _id, UGen sink, float freq) {
		init(_id, skin, freq, 1);
	}
}

class Hand {
	string id;
	Finger fingers[0]; // map
	string fIds // list
	Gain audio;
	float palm[3];
	OSCR @ receiver;
	OSCE @ event;

	fun void init(string _id, OSCR r, float _palm[]) {
		_id => id;
		_palm @=> palm;
		r @=> receiver;
		receiver.event("/hand/"+id);
	}

	fun void updateCoeffs() {
		0 => float totalSqGain;
		for (0 => int i; i < fIds.size(); i++) {
			fingers[fIds[i]] @=> Finger @ f;
			Std.fabs(angle(f.position, palm)) => float g;
			g*g +=> totalSqGain;
			g => f.osc.gain;
		}
		1/Math.sqrt(totalSqGain) => audio.gain;
	}

	fun void addFinger(string fid) {
		fIds << fid;
		Finger f;
		f.init(fid, audio, ***FREQ***);
		f @=> fingers[fid];
		f * (i*palm[1]+1) => f.osc.freq;
	}
 
}

Hand hands[0]; // map


Gain g;
300 => float f;


for (0 => int i; i < osc.size(); i++) {
	f * (i+1) => osc[i].freq;
	0.5/i => osc[i].gain;
	osc[i] => g => dac;
}
0.5 => g.gain;

while (true) {


	100::ms => now;

}