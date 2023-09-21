///////////////////////////////////
// Composición con SuperCollider //
///////////////////////////////////

// enviroment variables (global variables)
// las variables globales (o variables de entorno en SC) son útiles para la reusabilidad del código
// son palabras (n caracteres) precididas por el signo ~

~something = {Pulse.ar(80) * EnvGen.ar(Env.perc,doneAction:2)};
~something.play;

// CLOCK - ROUTINES Y TASKS //

// relojes

// SystemClock programa eventos en segundos
SystemClock.sched(2, {"foo".postln; ~something.play;});
SystemClock.sched(0, {"foo".postln; ~something.play; 1.0;});
SystemClock.sched(0, {"foo".postln; ~something.play; 1.0.rand;});
SystemClock.clear;

// SystemClock no puede usarse para programar eventos que afecten elementos de GUI, para esto se usa
// AppClock o un atajo que consiste en llamar el método .defer en la funcion de un SystemClock
SystemClock.sched(1, {Window.new.front});          // error!
SystemClock.sched(1, {{Window.new.front}.defer});  // así funciona, reprogramando en un AppClock
AppClock.sched(1, {Window.new.front});

// TempoClock

// TempoClock programa eventos en valores de pulso o tempo musical
// a diferencia de SystemClock y AppClock es necesario crear instancias de TempoClock y enviar a las mismas
// mensajes de programacion, esto es porque es posible correr varias instancias diferentes de TempoClock
// con diferentes tempos, mientras que solo es posible una instancia de SystemClock o AppClock

(
t = TempoClock.new; // crea instancia
t.sched(0, {"foo".postln; ~something.play; 1;});  //valor de programación dado en pulsos por segundo
)
t.tempo = 2; // 2 bps
t.tempo = 72/60; // 72 bpm
t.clear;
// TempoClock también permite programar eventos según un compás determinado

//////////////////////////////////
//////////////////////////////////

// Routine
// una Routine es como un Function que puede ser evaluada de a pedazos
// en casi cualquier lugar donde se usa una funcion se puede usar una Routine, y dentro de la misna
// se usa el método .yield para pausar la ejecución y retornar un valor o sentencia
(
r = Routine({
	"foo".yield;
	"bar".yield;
});
)
r.value; // foo     tb puede usarse r.next;
r.value; // bar
r.value; // nil, la Routine ya había sido completada

// como una Routine puede reemplazar una función, si se evalúa una Routine en un Clock y se programa
// un número de retorno (yield) la Routine puede ser programada de manera similar a SystemClock
(
r = Routine({
	"foo".postln;
	1.yield;
	"bar".postln;
	1.yield;
	"foobar".postln;
})
)
SystemClock.sched(0,r);

// Calderon
(
r = Routine({
	x = Synth(\default, [freq: 76.midicps]);
	1.wait; // sinónimo de .yield

	x.release(0.1);
	y = Synth(\default, [freq: 73.midicps]);
	"Waiting...".postln;
	nil.yield; // fermata

	y.release(0.1);
	z = Synth(\default, [freq: 69.midicps]);
	2.wait;
	z.release;
})
)
// espera de calderon
r.play;
// tónica
r.play; // atajo para programar un Routine en un Clock, aca hay que rellamra debido a nil.yield

// una función responde a un método .fork, que automatiza el encapsulado de la misma en una Routine
// y su programación en un Clock
(
{"something".postln;
	1.wait;
	"something else".postln;
	1.wait;
}.fork;
)

//////////////////////////////////////
//////////////////////////////////////

// una Task funciona de manera casi idéntica a Routine pero esta pensada solo para usarse en un clock y provee
// algunos métodos útiles como .pause para pausar la ejecución
// idem anterior pero utilizando Task y GUI
(
t = Task({
	loop({ // loop the whole thing
		3.do({
			x.release;
			x = Synth(\default, [freq: 76.midicps]);
			0.5.wait;
			x.release(0.1);
			x = Synth(\default, [freq: 73.midicps]);
			0.5.wait;
		});
		" i am waiting you to press resume".postln;
		nil.yield; // fermata
		x.release(0.1);
		x = Synth(\default, [freq: 69.midicps]);
		1.wait;
		x.release;
	});
});

w = Window.new("Task Example", Rect(400,400,200,30)).front;
w.view.decorator = FlowLayout(w.view.bounds);
Button.new(w, Rect(0,0,100,20)).states_([["Play/Resume", Color.black, Color.clear]]).action_({t.resume(0);});
Button.new(w, Rect(0,0,40,20)).states_([["Pause", Color.black, Color.clear]]).action_({t.pause;});
Button.new(w, Rect(0,0,40,20)).states_([["Finish", Color.black, Color.clear]]).action_({
	t.stop;
	x.release(0.1);
	w.close;
	});
)

// se puede resetear Routine y Task con el método .reset;
r.reset;
//

// mixed time
(
r = Routine({
	c = TempoClock.new; //  TempoClock
	// start  loop
	t = Task({
		loop({
			x.release(0.1);
			x = Synth(\default, [freq: 61.midicps, amp: 0.2]);
			0.2.wait;
			x.release(0.1);
			x = Synth(\default, [freq: 67.midicps, amp: 0.2]);
			rrand(0.075,0.25).wait; // random wait
		})
	},c); // use TempoClock to play this Task
	t.start;
	nil.yield;

	// now add some notes
	y = Synth(\default, [freq: 73.midicps, amp: 0.3]);
	nil.yield;
	y.release(0.1);
	y = Synth(\default, [freq: 79.midicps, amp: 0.3]);
	c.tempo = 2; // double time
	nil.yield;
	t.stop; y.release(1); x.release(0.1); // stop the Task and Synths
});
)

r.next; // start loop
r.next; // first note
r.next; // second note and loop goes double time
r.next; // stop loop and fade

r.reset; // reset before restart

///////////////////////////////////////////
///////////////////////////////////////////

// PATTERNS y SCORE //

// PATERNS provee una manera eficiente de programar Streams de valores u otros objetos y puede
// usarse facilmente con los métodos vistos arriba

// Pseq es una secuencia ordenada de objetos
// Pxrand es una secuencia aleatoria sin repetición
(
// random notes ftom lydian b7 scale
p = Pxrand([64,66,68,70,71,73,74,76],inf).asStream; // inf = infinite repetitions
// ordered sequence of durations
q = Pseq([1,2,0.5],inf).asStream;
t = Task({
	loop({
		x.release(2);
		x = Synth(\default, [freq: p.value.midicps]);
		q.value.wait;
	});
});
t.start;
)
t.stop; x.release;
//


// demostracion de polimorfismo en el mensaje que permite modificar la variable en tiempo real
(
p = 64; // a constant note
q = Pseq([1,2,0.5],inf).asStream; // ordered sequence of durations
t = Task({
	loop({
		x.release(2);
		x = Synth(\default,[freq: p.value.midicps]);
		q.value.wait; // schedule time
	});
});
t.start;
)
// now change p!!
p = Pseq([64,66,68],inf).asStream; // to a Pattern do re mi
p = {rrand(64,76)}; // to a function providing random notes from a chromatic octave
t.stop; x.release;
//

// SCORE
// otra forma de controlar secuencias de eventos es a través de el objeto Score
// este esencialmente es una lista de tiempos y mensajes OSC en forma de arrays anidados
// [ [time1, [cmd1]],[time2, [cmd2]],[time3, [cmd3]], ... ]

// esto es usar mensajería OSC en forma directa en vez de abstracciones comunes de lenguaje para
// comunicar acciones al server. "messaging style" instead of "object style"
(
SynthDef(\ScoreSine, {arg freq = 440;
	Out.ar(0, SinOsc.ar(freq,0,0.2) * Line.kr(1,0,0.5,doneAction:2));
}).add;

x = [
	// args for s_new are synthdef, nodeID, addAction, targetID, syntargs...
	[0.0, [\s_new, \ScoreSine, 1000, 0, 0, \freq, 1413]],
	[0.5, [\s_new, \ScoreSine, 1001, 0, 0, \freq, 712]],
	[1.0, [\s_new, \ScoreSine, 1002, 0, 0, \freq, 417]],
	[2.0, [\c_set, 0, 0]] // dummy command to mark end of NRT synthesis time
];
z = Score(x);
)
z.play;
//

// CUE PLAYERS
// disparo de archivos de audio en una situación de tape performance
// una cuestion a considerar en estos casos es la carga del archivo en RAM o lectura del mismo
// desde HD
~myBuffer = Buffer.read(s, "sounds/a11wlk01.wav"); // load sound
~myBuffer.play; // play sound and relase the node afterplaying

(
// synthdef to play from a buffer with a fadeout
SynthDef(\playbuf, {arg out = 0, buf = 0, gate = 1;
	Out.ar(0, PlayBuf.ar(buf.numChannels,buf,BufRateScale.kr(buf),loop:1.0)
		* Linen.kr(gate, doneAction:2); // release synth when fade done
	);
}).add;
// load all the paths in the sounds folder
~someSounds = "sounds/*".pathMatch.collect{ |path| Buffer.read(s, path)};
)

// now execute this one by one, this is the score!
~nowPlaying = Synth(\playbuf, [buf: ~someSounds[0]]);
~nowPlaying.release; ~nowPlaying = Synth(\playbuf, [buf: ~someSounds[1]]); // 2 statments!
~nowPlaying.release; ~nowPlaying = Synth(\playbuf, [buf: ~someSounds[2]]); // executed at once
~nowPlaying.release;
// free the buffer memory
~someSounds.do(_.free);
//


