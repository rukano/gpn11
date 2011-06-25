s.record;
play{ EnvGen.ar(Env.perc(0.35, 0.05), Impulse.ar(2)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 400), mul:0.1)) } // attract

play{ EnvGen.ar(Env.perc(0.1, 0.3), Impulse.ar(4)) * Splay.ar(SinOsc.ar(Array.exprand(24, 200, 800), mul:0.1)) } // repel