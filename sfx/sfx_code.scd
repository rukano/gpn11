s.record;
play{ EnvGen.ar(Env.perc(0.35, 0.025, 1, 2), Impulse.ar(0)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 400), mul:0.1)) }; // attract

play{ EnvGen.ar(Env.perc(0.1, 0.3, 1, -4), Impulse.ar(0)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 800), mul:0.1)) }; // repel
(
play{ EnvGen.ar(Env.linen(1.5, 1.5, 0.1)) * RHPF.ar(WhiteNoise.ar(), 10000, 0.5, LFNoise1.kr(40, 0.4, 0.6))!2 * 0.1}; // fuse
{
play{
	var imp = Decay2.ar(Impulse.ar(0), 0.01, 0.2);
	var snd = RLPF.ar(PinkNoise.ar() * LFNoise0.ar(40), [1000, 2000, 4000], 1).sum * imp;
	snd = snd + imp + SinOsc.ar(40, mul:XLine.ar(1, 0.0001, 0.1));
	snd = snd + GVerb.ar(snd, 20, 5.5, mul:XLine.ar(0.5, 0.0001, 0.1));
	snd = snd + GVerb.ar(snd, 30, 4.5, mul:XLine.ar(0.5, 0.0001, 0.1));
	snd = snd * EnvGen.ar(Env.linen(0.001, 0.3, 1));
//	snd = HPF.ar(snd, 40);
	snd = snd + SinOsc.ar([40,55,67], mul:XLine.ar(1, 0.0001, 1.5, doneAction:2) * 0.1).sum;
	snd = Compander.ar(snd, snd, 0.5, 1, 0.1);
	snd = Limiter.ar(snd) * 4;
	snd = Compander.ar(snd, snd, 0.5, 1, 0.01);
	snd = LeakDC.ar(0.1 - snd);
	snd = Limiter.ar(snd, 0.9);
}}.defer(3) // explosion
)

(
play{
	var seq = Duty.kr(0.08, 0, Dseq([0, 4, 7,  12] + 60)).midicps;
	var snd = SyncSaw.ar(seq * [1, 1.25, 1.5, 2, 4, 8], 800).sum!2;
	snd = RLPF.ar(snd, seq * 2, 0.1);
	snd * EnvGen.ar(Env.linen(0.005, 0.4, 0.3), doneAction:2)
}
)


(
play{
	var seq = Duty.kr(0.12, 0, Dseq([10,7,0,-10] + 60 - 10)).midicps;
	var snd = SyncSaw.ar(seq * [1, 1.25, 1.5, 2, 4, 8], 400).sum!2;
	snd = RLPF.ar(snd, seq * 5, 0.2);
	snd * EnvGen.ar(Env.linen(0.005, 0.5, 0.01), doneAction:2)
}
)