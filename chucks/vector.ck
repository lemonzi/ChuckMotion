/***********************************
 ** vChucK: basic vectorial utils **
 ***********************************/

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
