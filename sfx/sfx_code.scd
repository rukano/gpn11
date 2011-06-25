s.record;
play{ EnvGen.ar(Env.perc(0.35, 0.025, 1, 2), Impulse.ar(0)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 400), mul:0.1)) } // attract

play{ EnvGen.ar(Env.perc(0.1, 0.3, 1, -4), Impulse.ar(0)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 800), mul:0.1)) } // repel