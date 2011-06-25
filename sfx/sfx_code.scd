s.record;
play{ EnvGen.ar(Env.perc(0.3, 0.1), Impulse.ar(2)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 400), mul:0.1)) } // attract

play{ EnvGen.ar(Env.perc(0.1, 0.3), Impulse.ar(2)) * Splay.ar(SinOsc.ar(Array.exprand(24, 300, 600), mul:0.1)) } // repel